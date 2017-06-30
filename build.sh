#!/usr/bin/env bash
set -x -e

buildnumber=${4-$(date -u +"%y%m%d%H%M")}

docker build -t "$1"/kudu:1.7_"$buildnumber" -t "$1"/kudu:latest_"$buildnumber" 1.7

docker login -u "$2" -p "$3"

docker push "$1"/kudu:1.7_"$buildnumber"
docker push "$1"/kudu:latest_"$buildnumber"

docker logout
