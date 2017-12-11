#!/bin/bash
if [ $# -ne 5 ]; then
	echo "Missing parameters; exiting"
	exit 1
fi

GROUP_ID=$1
GROUP_NAME=$2
USER_ID=$3
USER_NAME=$4
SITE_NAME=$5

groupadd -g $GROUP_ID $GROUP_NAME
useradd -u $USER_ID -g $GROUP_NAME $USER_NAME
chown -R $USER_NAME:$GROUP_NAME /opt/Kudu
chown -R $USER_NAME:$GROUP_NAME /tmp

/bin/bash -c "node /opt/webssh/index.js &"

export KUDU_RUN_USER="$USER_NAME"
export MONO_IOMAP=all
export HOME=/home
export WEBSITE_SITE_NAME=$SITE_NAME
export APPSETTING_SCM_USE_LIBGIT2SHARP_REPOSITORY=0
export KUDU_APPPATH=/opt/Kudu
export KUDU_MSBUILD=/usr/bin/xbuild
export APPDATA=/opt/Kudu/local
export SCM_BIN_PATH=/opt/Kudu/bin

cd /opt/Kudu
ASPNETCORE_URLS=http://+:8181 runuser -p -u "$USER_NAME" -- dotnet Kudu.Services.Web.dll