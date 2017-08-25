#!/usr/bin/env bash
set -x -e

buildnumber=${4-$(date -u +"%y%m%d%H%M")}
version=1.7

docker build -t "$1"/kudu:${version}_"$buildnumber" -t "$1"/kudu:latest_"$buildnumber" $version

docker login -u "$2" -p "$3"

docker push "$1"/kudu:${version}_"$buildnumber"
docker push "$1"/kudu:latest_"$buildnumber"

docker logout
