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
chown -R $USER_NAME:$GROUP_NAME /etc/apache2
chown -R $USER_NAME:$GROUP_NAME /opt/Kudu
touch /var/log/apache2/kudu-error.log
touch /var/log/apache2/kudu-access.log
mkdir -p /var/lock/apache2 /var/run/apache2
chown -R $USER_NAME:$GROUP_NAME /var/log/apache2 /var/lock/apache2 /var/run/apache2
chown -R $USER_NAME:$GROUP_NAME /tmp
sed -i -- "s/port-placeholder/$PORT/g" /etc/apache2/sites-available/kudu.conf
sed -i -- "s/KuduSite/$SITE_NAME/g" /etc/apache2/sites-available/kudu.conf
sed -i -- "s/user-placeholder/$USER_NAME/g" /etc/apache2/apache2.conf
sed -i -- "s/group-placeholder/$GROUP_NAME/g" /etc/apache2/apache2.conf
sed -i -- "s/80/8080/g" /etc/apache2/ports.conf
mkdir -p /etc/mono/registry
chmod uog+rw /etc/mono/registry
chown -R $USER_NAME:$GROUP_NAME /etc/mono/registry
cd /etc/apache2/sites-available
a2dissite 000-default.conf
a2ensite kudu.conf
mkdir -p /home/LogFiles/webssh

/bin/bash -c "pm2 start /opt/webssh/index.js -o /home/LogFiles/webssh/pm2.log -e /home/LogFiles/webssh/pm2.err &"

#chmod 777 /opt/tunnelext/tunnelwatcher.sh
/bin/bash -c "/opt/tunnelext/tunnelwatcher.sh dotnet /opt/tunnelext/DebugExtension.dll &"

export KUDU_RUN_USER="$USER_NAME"
export MONO_IOMAP=all
export HOME=/home
export WEBSITE_SITE_NAME=$SITE_NAME
export APPSETTING_SCM_USE_LIBGIT2SHARP_REPOSITORY=0
export KUDU_APPPATH=/opt/Kudu
export KUDU_MSBUILD=/usr/bin/xbuild
export APPDATA=/opt/Kudu/local
export SCM_BIN_PATH=/opt/Kudu/bin

# Start mod-mono-server and give it a chance to warm up before
# hitting it with requests. This prevents a pathological behavior
# in mod_mono where it keeps starting new mod-mono-server processes
# because they aren't responding fast enough, and it parallelizes
# mod-mono-server startup with apache startup, resulting in faster cold start.
# mod_mono will still spawn new instances in the event that this one exits early.
runuser -p -u "$USER_NAME" -- /usr/bin/mono /usr/lib/mono/4.5/mod-mono-server4.exe \
  --filename /tmp/mod_mono_server_default --applications /:/opt/Kudu,/loganalyzer:/opt/LogAnalyzer --nonstop &

while [ ! -S /tmp/mod_mono_server_default ] ; do
 sleep 1
done

#Run apache
/usr/sbin/apache2ctl -D FOREGROUND
