#!/bin/bash

rm /mnt/nickwalkdesk/g/appsvc/kudu/kudu/kudu.zip
pushd /mnt/nickwalkdesk/g/kudu/dotnetcore/Kudu.Services.Web/bin/Release/netcoreapp2.0/publish
zip -r /mnt/nickwalkdesk/g/appsvc/kudu/kudu/kudu.zip *
popd

cd /mnt/nickwalkdesk/g/appsvc/kudu/kudu
docker build --tag nickwalk/kudu .
