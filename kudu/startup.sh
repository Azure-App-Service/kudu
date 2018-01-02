#!/bin/bash

echo $(date) In startup.sh

if [ $# -ne 5 ]; then
	echo "Missing parameters; exiting"
	exit 1
fi

GROUP_ID=$1
GROUP_NAME=$2
USER_ID=$3
USER_NAME=$4
SITE_NAME=$5

echo $(date) doing groupadd

groupadd -g $GROUP_ID $GROUP_NAME

echo $(date) doing useradd
useradd -u $USER_ID -g $GROUP_NAME $USER_NAME

echo $(date) doing kudu chown

chown -R $USER_NAME:$GROUP_NAME /opt/Kudu

echo $(date) doing tmp chown 
chown -R $USER_NAME:$GROUP_NAME /tmp

echo $(date) Running webssh

/bin/bash -c "node /opt/webssh/index.js &"

echo $(date) exporting vars

export KUDU_RUN_USER="$USER_NAME"
export HOME=/home
export WEBSITE_SITE_NAME=$SITE_NAME
export APPSETTING_SCM_USE_LIBGIT2SHARP_REPOSITORY=0
export KUDU_APPPATH=/opt/Kudu
export APPDATA=/opt/Kudu/local

cd /opt/Kudu

echo $(date) running .net
ASPNETCORE_URLS=http://+:8181 runuser -p -u "$USER_NAME" -- dotnet Kudu.Services.Web.dll