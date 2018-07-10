#!/usr/bin/env bash
set -x -e

buildnumber=${4-$(date -u +"%y%m%d%H%M")}

#docker build --no-cache -t "$1"/kudu:"$buildnumber" kudu
docker build -t "$1"/kudu:"$buildnumber" kudu
docker tag "$1"/kudu:"$buildnumber" "$1"/kudu:latest

