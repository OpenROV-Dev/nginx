#!/bin/bash
set -x
set -e
nginxVersion=$PACKAGE_VERSION

apt-get update -qq
apt-get install -y \
g++ \
cmake \
build-essential \
pkg-config \
wget \ 
libpcre3 \
libpcre3-dev \
libssl-dev

wget http://nginx.org/download/nginx-$(nginxVersion).tar.gz
tar xf nginx-$(nginxVersion).tar.gz
cd nginx-$(nginxVersion)
./configure \
    --prefix=/usr/share/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/lock/nginx.lock \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --user=www-data \
    --group=www-data \
    --without-mail_pop3_module \
    --without-mail_imap_module \
    --without-mail_smtp_module \
    --without-http_fastcgi_module \
    --without-http_uwsgi_module \
    --without-http_scgi_module \
    --without-http_memcached_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_gzip_static_module \
    --with-http_v2_module

mkdir nginx_install
make install DESTDIR=./nginx_install/usr/local
