FROM appsvctest/php-build-5.6:latest as php5.6-build
FROM appsvctest/php-build-7.0:latest as php7.0-build
FROM appsvctest/php-build-7.2:latest as php7.2-build
FROM appsvctest/python-3.6-build:latest as python-3.6-build
FROM appsvctest/python-3.7-build:latest as python-3.7-build

#FROM oryxprod/build:20181001.3 as main
FROM oryxprod/build:20181031.3 as main

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list \
  && apt-get update \
  && apt-get install -y openssh-client --no-install-recommends \
  && apt-get install -y vim tree --no-install-recommends \
  && apt-get install -y tcptraceroute \
  && wget -O /usr/bin/tcpping http://www.vdberg.org/~richard/tcpping \
  && chmod 755 /usr/bin/tcpping 

#TODO : node in the path (6.11)
#TODO: RUBY  

# SQL Server gem support
RUN apt-get install -y unixodbc-dev freetds-dev freetds-bin 

####
#### GO
####

#ENV GOLANG_VERSION=1.10
#ENV GOLANG_DOWNLOAD_URL="https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz" GOLANG_DOWNLOAD_SHA="b5a64335f1490277b585832d1f6c7f8c6c11206cba5cd3f771dcb87b98ad1a33"

#RUN curl -SL $GOLANG_DOWNLOAD_URL --output golang.tar.gz \
#  && echo "$GOLANG_DOWNLOAD_SHA golang.tar.gz" | sha256sum -c - \
#  && tar -zxf golang.tar.gz -C /usr/local \
#  && rm golang.tar.gz \
#  && apt-get install -y musl-tools

#ENV PATH /usr/local/go/bin:$PATH

# Download Dep executable
#ENV DEP_VERSION=0.4.1
#ENV DEP_DOWNLOAD_URL="https://github.com/golang/dep/releases/download/v$DEP_VERSION/dep-linux-amd64" DEP_DOWNLOAD_SHA="31144e465e52ffbc0035248a10ddea61a09bf28b00784fd3fdd9882c8cbb2315"
#RUN curl -fL -o /usr/local/go/bin/dep $DEP_DOWNLOAD_URL \
#  && echo "$DEP_DOWNLOAD_SHA /usr/local/go/bin/dep" | sha256sum -c - \
#  && chmod +x /usr/local/go/bin/dep
  
  
####
#### PHP
####  

# Section PHP
#RUN  apt-get update; \
#     apt-get install -y --no-install-recommends \
#     libcurl4-openssl-dev \
#     libssl-dev \
#     zlib1g-dev \
#     libpng-dev \
#     libpq-dev \
#     libc-client-dev \
#     libsqlite3-dev \
#     libgmp-dev \
#     libmcrypt-dev \
#     libldap2-dev \
#     libtidy-dev \
#     libkrb5-dev \
#     libicu-dev \
#     libedit-dev \
#     libxml2-dev \
#     libxslt-dev \
#     unixodbc-dev \
#     libmagickwand-dev \
#     dpkg-dev \
#     file \
#     g++ \
#     gcc \
#     libc-dev \
#     libsodium-dev \
#     libsodium18 \
#     && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so 


#RUN mkdir -p /usr/local/php/5.6
#COPY --from=php5.6-build /usr/local/php/5.6 /usr/local/php/5.6

#RUN mkdir -p /usr/local/php/7.0
#COPY --from=php7.0-build /usr/local/php/7.0 /usr/local/php/7.0

#RUN mkdir -p /usr/local/php/7.2
#COPY --from=php7.2-build /usr/local/php/7.2 /usr/local/php/7.2

#ENV PATH /usr/local/php/7.2/bin:$PATH

#ENV PHP_5_6_PATH /usr/local/php/5.6/bin
#ENV PHP_7_0_PATH /usr/local/php/7.0/bin
#ENV PHP_7_2_PATH /usr/local/php/7.2/bin

# PHP Composer
#RUN php -r "copy('https://getcomposer.org/installer', '/tmp/composer-setup.php');" \
#  && php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer --quiet \
#  && rm -f /tmp/composer-setup.php

#ENV PHP_VERSION=7.2
#ENV COMPOSER_VENDOR_DIR=/home/site/wwwroot/vendor

COPY LogAnalyzer.zip TunnelExtension.zip webssh.zip ssh /tmp/
COPY KuduStaticFiles/503.html /opt/Kudu/503.html

# Install Kudu
RUN mkdir -p /opt/Kudu/local \
  && chmod 755 /opt/Kudu/local \
  && apt-get update \
  && apt-get  install -y unzip \
# Install pm2 and pm2-logrotate
  &&  mkdir /opt/LogAnalyzer \
  && unzip /tmp/LogAnalyzer.zip -d /opt/LogAnalyzer \
  && rm -f /tmp/LogAnalyzer.zip \
  && mkdir -p /home/LogFiles \
# Install TunnelExtension
  && mkdir /opt/tunnelext \
  && unzip /tmp/TunnelExtension.zip -d /opt/tunnelext \
# Install webssh
  && mkdir /opt/webssh \
  && unzip /tmp/webssh.zip -d /opt/webssh \
# Replace ssh with wrapper script for CIFS mount permissions workaround
  && mv /usr/bin/ssh /usr/bin/ssh.original \
  && mv /tmp/ssh /usr/bin/ssh \
  && chown root:root /usr/bin/ssh \
  && chmod 755 /usr/bin/ssh \
  && chmod -R 777 /home \
  && rm -rf /tmp/*

ENV DOTNET_RUNNING_IN_CONTAINER=true
ENV jlawversion=1

# Enable correct mode for dotnet watch (only mode supported in a container)
ENV DOTNET_USE_POLLING_FILE_WATCHER=true

# Skip extraction of XML docs - generally not useful within an image/container - helps performance
ENV NUGET_XMLDOC_MODE=skip

#Instal Kudu
RUN cd /tmp \
    && git clone https://github.com/sanchitmehta/KuduLight.git \
    && cd ./KuduLight \
    && git checkout jennylaw-test \
    && cd ./Kudu.Services.Web \
    && dotnet publish -c Release -o /opt/Kudu \
    && echo $(date) doing groupadd \
    && groupadd -g "1002" "kudu_group" \
    && echo $(date) doing useradd \
    && useradd -u "1001" -g "kudu_group" "kudu_user" \
    && chmod 777 /opt/Kudu/Kudu.Services.Web.dll \
    && chmod -R +x /opt/Kudu/ \
    && rm -rf /tmp/*             

COPY startup.sh /

RUN chmod 777 /startup.sh

RUN ln -s /opt/nodejs/8.11.2/lib/node_modules/npm/bin/npm-cli.js /usr/bin/npm-cli.js

RUN npm install -g kudusync

ENV PATH=$PATH:/opt/nodejs/8.11.2/bin 
RUN echo "2.15.9" > /opt/nodejs/4.5.0/npm.txt 

EXPOSE 8181

ENTRYPOINT [ "/startup.sh" ]
CMD [ "1002", "kudu_group", "1001", "kudu_user", "localsite" ]

