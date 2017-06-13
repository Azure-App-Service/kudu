#!/usr/bin/env bash
set -x -e

docker build -t "$1"/kudu:1.7 1.7

docker login -u "$2" -p "$3"

docker push "$1"/kudu:1.7

docker logout