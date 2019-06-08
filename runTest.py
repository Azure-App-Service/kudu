import requests
import argparse
import json
import time
import threading
import sys


def getConfig():
    f = open("blessedImageConfig.json", "r")
    return json.loads(f.read(), strict=False)


def appendPR(buildRequest, pullRepo, pullId):
    if (pullRepo != False):
        buildRequest.update( { "pullRepo": pullRepo } )
        buildRequest.update( { "pullId": pullId } )
    return buildRequest


def appendOutputRepo(buildRequest, pullRepo, pullId):
    if (pullRepo != False):
        buildRequest.update( { "pullRepo": pullRepo } )
        buildRequest.update( { "pullId": pullId } )
    return buildRequest


def triggerBuild(buildRequests, code):
    url = "https://appsvcbuildfunc-test.azurewebsites.net/api/HttpBuildPipeline_HttpStart"
    querystring = {"code": code}
    payload = json.dumps(buildRequests)
    headers = {
        'Content-Type': "application/json",
        'cache-control': "no-cache"
        }
    response = requests.request("POST", url, data=payload, headers=headers, params=querystring)
    return json.loads(response.content.decode('utf-8'), strict=False)


def getStatusQueryGetUri(jsonResponse):
    return jsonResponse["statusQueryGetUri"]


def pollPipeline(statusQueryGetUri):
    url = statusQueryGetUri
    headers = {
        'cache-control': "no-cache"
        }
    response = requests.request("GET", url, headers=headers)
    return json.loads(response.content.decode('utf-8'), strict=False)


def buildImage(br, code, results):
    tries = 0
    success = False
    while tries < 1:
        try:
            tries = tries + 1
            print("building")
            print(br)
            statusQueryGetUri = getStatusQueryGetUri(triggerBuild(br, code))
            print(statusQueryGetUri)
            while True:
                time.sleep(60)
                content = pollPipeline(statusQueryGetUri)
                runtimeStatus = content["runtimeStatus"]
                if runtimeStatus == "Completed":
                    print(content)
                    output = json.loads(content["output"].replace("\\", "/"), strict=False)
                    status = output["status"]
                    if (status == "success"):
                        print("pass")
                        success = True
                        break
                    else:
                        print("failed on")
                        break
                elif runtimeStatus == "Running":
                    print("running")
                    continue
                else:
                    print("failed on")
                    break
            if success:
                break
            else:
                print("trying again")
                print(br)
                continue
        except:
            print(sys.exc_info())
    if success:
        results.append(True)
        sys.exit(0)
    else:
        results.append(False)
        sys.exit(1)


parser = argparse.ArgumentParser()
parser.add_argument('--code', help='code')
parser.add_argument('--pullId', help='pullId')
parser.add_argument('--pullRepo', help='pullRepo')
args = parser.parse_args()

code = args.code
pullId = args.pullId
pullRepo = args.pullRepo

threads = []
results = []
buildRequests = getConfig()
for br in buildRequests:
    br = appendPR(br, pullRepo, pullId)
    print(br)
    t = threading.Thread(target=buildImage, args=((br, code, results)))
    threads.append(t)
    t.start()
    time.sleep(60)

# Wait for all of them to finish
for t in threads:
    t.join()

for r in results:
    if r == False:
        print("Failed")
        sys.exit(1)

print("Passed")
sys.exit(0)
