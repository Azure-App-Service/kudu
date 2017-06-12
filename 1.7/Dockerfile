FROM buildpack-deps:jessie-curl
MAINTAINER Nazim Lala <naziml@microsoft.com>

ENV DEBIAN_FRONTEND noninteractive

COPY apache2.conf /tmp
COPY kudu.conf /tmp
COPY ssh /tmp
COPY startup.sh /tmp
COPY webssh.zip /tmp 
COPY mod_mono.tar /tmp
COPY hostingstart.html /home/site/wwwroot/hostingstart.html

# Install dependencies
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
  --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
  && echo "deb http://download.mono-project.com/repo/debian jessie/snapshots/5.0.0.100/. main" > \
  /etc/apt/sources.list.d/mono-xamarin.list \
  && apt-get update \
  && apt-get install -y apt-utils --no-install-recommends \
  && apt-get install -y unzip --no-install-recommends \
  && apt-get install -y xz-utils --no-install-recommends \
  && apt-get install -y mono-complete --no-install-recommends \
  && apt-get install -y mono-apache-server4 --no-install-recommends \
  && apt-get install -y libapache2-mod-mono --no-install-recommends \
  && apt-get install -y git --no-install-recommends \
  && apt-get install -y openssh-client --no-install-recommends \
  && apt-get install -y vim tree --no-install-recommends \
  && apt-get install -y tcptraceroute \
#  && wget -O /usr/bin/tcpping http://www.vdberg.org/~richard/tcpping \
#  && chmod 755 /usr/bin/tcpping \
  && wget -O /tmp/Kudu.zip https://nildev.blob.core.windows.net/kudu/Kudu.63.60612.2890.zip \
  && wget -O /tmp/node-v4.4.7-linux-x64.tar.xz https://nodejs.org/dist/v4.4.7/node-v4.4.7-linux-x64.tar.xz \
  && wget -O /tmp/node-v4.5.0-linux-x64.tar.xz https://nodejs.org/dist/v4.5.0/node-v4.5.0-linux-x64.tar.xz \
  && wget -O /tmp/node-v6.2.2-linux-x64.tar.xz https://nodejs.org/dist/v6.2.2/node-v6.2.2-linux-x64.tar.xz \
  && wget -O /tmp/node-v6.6.0-linux-x64.tar.xz https://nodejs.org/dist/v6.6.0/node-v6.6.0-linux-x64.tar.xz \
  && wget -O /tmp/node-v6.9.3-linux-x64.tar.xz https://nodejs.org/dist/v6.9.3/node-v6.9.3-linux-x64.tar.xz \
  && wget -O /tmp/node-v6.10.3-linux-x64.tar.xz https://nodejs.org/dist/v6.10.3/node-v6.10.3-linux-x64.tar.xz \
  && wget -O /tmp/node-v6.11.0-linux-x64.tar.xz https://nodejs.org/dist/v6.11.0/node-v6.11.0-linux-x64.tar.xz \
  && wget -O /tmp/node-v8.0.0-linux-x64.tar.xz https://nodejs.org/dist/v8.0.0/node-v8.0.0-linux-x64.tar.xz \
  && wget -O /tmp/node-v8.1.0-linux-x64.tar.xz https://nodejs.org/dist/v8.1.0/node-v8.1.0-linux-x64.tar.xz \
  && wget -O /tmp/npm-2.15.8.zip https://github.com/npm/npm/archive/v2.15.8.zip \
  && wget -O /tmp/npm-2.15.9.zip https://github.com/npm/npm/archive/v2.15.9.zip \
  && wget -O /tmp/npm-3.9.5.zip https://github.com/npm/npm/archive/v3.9.5.zip \
  && wget -O /tmp/npm-3.10.3.zip https://github.com/npm/npm/archive/v3.10.3.zip \
  && wget -O /tmp/npm-3.10.10.zip https://github.com/npm/npm/archive/v3.10.10.zip \
  && wget -O /tmp/npm-5.0.3.zip https://github.com/npm/npm/archive/v5.0.3.zip \
  && a2enmod proxy \
  && a2enmod proxy_http \
  && a2enmod proxy_wstunnel \
  && a2enmod rewrite \
  && a2enmod proxy_ajp \
  && a2enmod deflate \
  && a2enmod headers \ 
  && a2enmod proxy_balancer \
  && a2enmod proxy_connect \
  && a2enmod proxy_html \
  && tar -xf /tmp/mod_mono.tar \
  && cp mod_mono.so.0.0.0 /usr/lib/apache2/modules/mod_mono.so.0.0.0

# Install npm and node
RUN mkdir -p /opt/npm/2.15.8/node_modules \
  && unzip -q /tmp/npm-2.15.8.zip -d /opt/npm/2.15.8/node_modules \
  && mv /opt/npm/2.15.8/node_modules/npm-2.15.8 /opt/npm/2.15.8/node_modules/npm \
  && ln -s /opt/npm/2.15.8/node_modules/npm/bin/npm /opt/npm/2.15.8/npm \
  && chmod -R 755 /opt/npm/2.15.8/node_modules/npm/bin \
  && mkdir -p /opt/npm/2.15.9/node_modules \
  && unzip -q /tmp/npm-2.15.9.zip -d /opt/npm/2.15.9/node_modules \
  && mv /opt/npm/2.15.9/node_modules/npm-2.15.9 /opt/npm/2.15.9/node_modules/npm \
  && ln -s /opt/npm/2.15.9/node_modules/npm/bin/npm /opt/npm/2.15.9/npm \
  && chmod -R 755 /opt/npm/2.15.9/node_modules/npm/bin \
  && mkdir -p /opt/npm/3.9.5/node_modules \
  && unzip -q /tmp/npm-3.9.5.zip -d /opt/npm/3.9.5/node_modules \
  && mv /opt/npm/3.9.5/node_modules/npm-3.9.5 /opt/npm/3.9.5/node_modules/npm \
  && ln -s /opt/npm/3.9.5/node_modules/npm/bin/npm /opt/npm/3.9.5/npm \
  && chmod -R 755 /opt/npm/3.9.5/node_modules/npm/bin \
  && mkdir -p /opt/npm/3.10.3/node_modules \
  && unzip -q /tmp/npm-3.10.3.zip -d /opt/npm/3.10.3/node_modules \
  && mv /opt/npm/3.10.3/node_modules/npm-3.10.3 /opt/npm/3.10.3/node_modules/npm \
  && ln -s /opt/npm/3.10.3/node_modules/npm/bin/npm /opt/npm/3.10.3/npm \
  && chmod -R 755 /opt/npm/3.10.3/node_modules/npm/bin \
  && mkdir -p /opt/npm/3.10.10/node_modules \
  && unzip -q /tmp/npm-3.10.10.zip -d /opt/npm/3.10.10/node_modules \
  && mv /opt/npm/3.10.10/node_modules/npm-3.10.10 /opt/npm/3.10.10/node_modules/npm \
  && ln -s /opt/npm/3.10.10/node_modules/npm/bin/npm /opt/npm/3.10.10/npm \
  && chmod -R 755 /opt/npm/3.10.10/node_modules/npm/bin \
  && mkdir -p /opt/npm/5.0.3/node_modules \
  && unzip -q /tmp/npm-5.0.3.zip -d /opt/npm/5.0.3/node_modules \
  && mv /opt/npm/5.0.3/node_modules/npm-5.0.3 /opt/npm/5.0.3/node_modules/npm \
  && ln -s /opt/npm/5.0.3/node_modules/npm/bin/npm /opt/npm/5.0.3/npm \
  && chmod -R 755 /opt/npm/5.0.3/node_modules/npm/bin \ 
  && chown -R root:root /opt/npm \
  && mkdir -p /opt/nodejs \
  && tar xfJ /tmp/node-v4.4.7-linux-x64.tar.xz -C /opt/nodejs \
  && rm -f node-v4.4.7-linux-x64.tar.xz \
  && mv /opt/nodejs/node-v4.4.7-linux-x64 /opt/nodejs/4.4.7 \
  && echo "2.15.8" > /opt/nodejs/4.4.7/npm.txt \
  && mkdir -p /opt/nodejs \
  && tar xfJ /tmp/node-v4.5.0-linux-x64.tar.xz -C /opt/nodejs \
  && rm -f node-v4.5.0-linux-x64.tar.xz \
  && mv /opt/nodejs/node-v4.5.0-linux-x64 /opt/nodejs/4.5.0 \
  && echo "2.15.9" > /opt/nodejs/4.5.0/npm.txt \
  && tar xfJ /tmp/node-v6.2.2-linux-x64.tar.xz -C /opt/nodejs \
  && rm -f node-v6.2.2-linux-x64.tar.xz \
  && mv /opt/nodejs/node-v6.2.2-linux-x64 /opt/nodejs/6.2.2 \
  && echo "3.9.5" > /opt/nodejs/6.2.2/npm.txt \
  && tar xfJ /tmp/node-v6.6.0-linux-x64.tar.xz -C /opt/nodejs \
  && rm -f node-v6.6.0-linux-x64.tar.xz \
  && mv /opt/nodejs/node-v6.6.0-linux-x64 /opt/nodejs/6.6.0 \
  && echo "3.10.3" > /opt/nodejs/6.6.0/npm.txt \
  && tar xfJ /tmp/node-v6.9.3-linux-x64.tar.xz -C /opt/nodejs \
  && rm -f node-v6.9.3-linux-x64.tar.xz \
  && mv /opt/nodejs/node-v6.9.3-linux-x64 /opt/nodejs/6.9.3 \
  && echo "3.10.10" > /opt/nodejs/6.9.3/npm.txt \
  && tar xfJ /tmp/node-v6.10.3-linux-x64.tar.xz -C /opt/nodejs \
  && rm -f node-v6.10.3-linux-x64.tar.xz \
  && mv /opt/nodejs/node-v6.10.3-linux-x64 /opt/nodejs/6.10.3 \
  && echo "3.10.10" > /opt/nodejs/6.10.3/npm.txt \
  && tar xfJ /tmp/node-v6.11.0-linux-x64.tar.xz -C /opt/nodejs \
  && rm -f node-v6.11.0-linux-x64.tar.xz \
  && mv /opt/nodejs/node-v6.11.0-linux-x64 /opt/nodejs/6.11.0 \
  && echo "3.10.10" > /opt/nodejs/6.11.0/npm.txt \
  && tar xfJ /tmp/node-v8.0.0-linux-x64.tar.xz -C /opt/nodejs \
  && rm -f node-v8.0.0-linux-x64.tar.xz \
  && mv /opt/nodejs/node-v8.0.0-linux-x64 /opt/nodejs/8.0.0 \
  && echo "5.0.3" > /opt/nodejs/8.0.0/npm.txt \
  && tar xfJ /tmp/node-v8.1.0-linux-x64.tar.xz -C /opt/nodejs \
  && rm -f node-v8.1.0-linux-x64.tar.xz \
  && mv /opt/nodejs/node-v8.1.0-linux-x64 /opt/nodejs/8.1.0 \
  && echo "5.0.3" > /opt/nodejs/8.1.0/npm.txt \
  && chown -R root:root /opt/nodejs \
  && ln -s /opt/nodejs/6.11.0/bin/node /opt/nodejs/node \
  && ln -s /opt/nodejs/6.11.0/npm.txt /opt/nodejs/npm.txt \
  && rm -f /usr/bin/node \
  && ln -s /opt/nodejs/6.11.0/bin/node /usr/bin/node \
  && rm -f /opt/nodejs/6.11.0/bin/npm \
  && ln -s /opt/npm/3.10.10/node_modules/npm/bin/npm /opt/nodejs/npm \
  && ln -s /opt/npm/3.10.10/node_modules /opt/nodejs/node_modules \
  && rm -rf /usr/bin/npm \
  && ln -s /opt/npm/3.10.10/node_modules/npm/bin/npm /usr/bin/npm \
  && ln -s /opt/npm/3.10.10/node_modules/npm/bin/npm-cli.js /usr/bin/npm-cli.js \
  && ln -s /opt/npm/3.10.10/node_modules /usr/bin/node_modules
  
ENV PATH $PATH:/opt/nodejs/6.11.0/bin

# Install webssh
RUN mkdir /opt/webssh \ 
  && unzip /tmp/webssh.zip -d /opt/webssh

# Install Kudu
RUN npm install -g kudusync \
  && cp /tmp/kudu.conf /etc/apache2/sites-available/kudu.conf \
  && cp /tmp/apache2.conf /etc/apache2/apache2.conf  \
  && unzip -q -o /tmp/Kudu.zip \
  && mkdir /opt/Kudu \
  && cp -rf ./63.60612.2890/* /opt/Kudu \
  && rm -f /tmp/Kudu.zip \
  && rm -f /tmp/apache2.conf \
  && rm -f /tmp/kudu.conf \
  && rm -rf ./63.60612.2890 \
  && cat /opt/Kudu/Web.config | \
  sed 's|  <location path="." inheritInChildApplications="false">|  <location path="~/../../../opt/Kudu" inheritInChildApplications="false">|' > /opt/Kudu/Web.config2 \
  && mv /opt/Kudu/Web.config2 /opt/Kudu/Web.config \
  && chmod 755 /opt/Kudu/bin/kudu.exe \
  && chmod 755 /opt/Kudu/bin/node_modules/.bin/kuduscript \
  && chmod 755 /opt/Kudu/bin/Scripts/starter.sh \
  && mkdir -p /opt/Kudu/local \
  && chmod 755 /opt/Kudu/local

# Upgrade mono
RUN echo "deb http://download.mono-project.com/repo/debian beta/snapshots/c7-ms/. main" | tee /etc/apt/sources.list.d/mono-xamarin-c7-ms.list \
  && apt-get update \
  && apt-get install -y libmono-system-net-http-webrequest4.0-cil --no-install-recommends

  
# Ruby installations

# Dependencies for various ruby and rubygem installations
RUN apt-get install -y libreadline-dev bzip2 build-essential libssl-dev zlib1g-dev libpq-dev libsqlite3-dev \
  curl patch gawk g++ gcc make libc6-dev patch libreadline6-dev libyaml-dev sqlite3 autoconf \
  libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev bison libxslt-dev \
  libxml2-dev libmysqlclient-dev --no-install-recommends

# rbenv 
RUN git clone https://github.com/rbenv/rbenv.git /usr/local/.rbenv
RUN chmod -R 777 /usr/local/.rbenv

ENV RBENV_ROOT="/usr/local/.rbenv"

ENV PATH="$RBENV_ROOT/bin:/usr/local:$PATH"

RUN git clone https://github.com/rbenv/ruby-build.git /usr/local/.rbenv/plugins/ruby-build
RUN chmod -R 777 /usr/local/.rbenv/plugins/ruby-build

RUN /usr/local/.rbenv/plugins/ruby-build/install.sh

# Install ruby 2.3.1 
ENV RUBY_CONFIGURE_OPTS=--disable-install-doc

ENV RUBY_CFLAGS=-O3

RUN eval "$(rbenv init -)" \
  && export WEBSITES_LATEST_NODE_VERSION="2.3.3" \
  && rbenv install $WEBSITES_LATEST_NODE_VERSION \
  && rbenv rehash \
  && rbenv global $WEBSITES_LATEST_NODE_VERSION \
  && ls /usr/local -a \
  && gem install bundler --version "=1.13.6"\
  && chmod -R 777 /usr/local/.rbenv/versions \
  && chmod -R 777 /usr/local/.rbenv/version

RUN eval "$(rbenv init -)" \
  && rbenv global $WEBSITES_LATEST_NODE_VERSION \
  && bundle config --global build.nokogiri -- --use-system-libraries

# Because Nokogiri tries to build libraries on its own otherwise
ENV NOKOGIRI_USE_SYSTEM_LIBRARIES=true

# SQL Server gem support
RUN apt-get install -y unixodbc-dev freetds-dev freetds-bin

# Replace ssh with wrapper script for CIFS mount permissions workaround
RUN mv /usr/bin/ssh /usr/bin/ssh.original \
  && mv /tmp/ssh /usr/bin/ssh \
  && chown root:root /usr/bin/ssh \
  && chmod 755 /usr/bin/ssh

# Install .NET Core 1.0
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libc6 \
        libcurl3 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu52 \
        liblttng-ust0 \
        libssl1.0.0 \
        libstdc++6 \
        libunwind8 \
        libuuid1 \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*
    
ENV DOTNET_SDK_VERSION 1.0.4
ENV DOTNET_SDK_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-dev-debian-x64.$DOTNET_SDK_VERSION.tar.gz

RUN curl -SL $DOTNET_SDK_DOWNLOAD_URL --output dotnet.tar.gz \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    && find /usr/share/dotnet/sdk/$DOTNET_SDK_VERSION \( -name \*.dll -or -name \*.exe \) -exec chmod +r {} \;
	
# PHP5.6
RUN apt-get update \
  && apt-get install -y --no-install-recommends php5-cli

# PHP7
RUN echo "deb http://deb.debian.org/debian stretch main" > /etc/apt/sources.list.d/stretch.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends php7.0-cli php7.0-zip php7.0-mbstring php7.0-xml \
  && rm -f /etc/apt/sources.list.d/stretch.list

# PHP Composer
RUN php -r "copy('https://getcomposer.org/installer', '/tmp/composer-setup.php');" \
  && php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer --quiet \
  && rm -f /tmp/composer-setup.php

ENV PHP_VERSION=7.0
ENV COMPOSER_VENDOR_DIR=/home/site/wwwroot/vendor

RUN chmod 755 /tmp/startup.sh \
 && mkdir -p /home/LogFiles \
 && chmod -R 777 /home

EXPOSE 8181

WORKDIR /home/site/wwwroot

ENTRYPOINT [ "/tmp/startup.sh" ]
CMD [ "1002", "kudu_group", "1001", "kudu_user", "localsite" ]