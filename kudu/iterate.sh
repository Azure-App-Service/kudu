#!/bin/bash

rm /mnt/nickwalkdesk/nick/g/appsvc/kudu/kudu/kudu.zip
pushd /mnt/nickwalkdesk/nick/g/kudu/dotnetcore/Kudu.Services.Web/bin/Release/netcoreapp2.0/publish
zip -r /mnt/nickwalkdesk/nick/g/appsvc/kudu/kudu/kudu.zip *
popd

cd /mnt/nickwalkdesk/nick/g/appsvc/kudu/kudu
docker build --tag nickwalk/kudu .
