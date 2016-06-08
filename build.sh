#!/bin/bash
set -x
set -e

#1.9.10-1
apt-get update -qq
apt-get install -y \
g++ \
cmake \
build-essential \
pkg-config \
wget \
libpcre3 \
libpcre3-dev \
<<<<<<< HEAD
dpkg-dev 

#since we are extending an exisitng source, we don't have to add keys or anything
echo "deb http://httpredir.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/backports.list
echo "deb-src http://httpredir.debian.org/debian jessie-backports main" >> /etc/apt/sources.list.d/backports.list

#this command only updates a single source list file
apt-get update -o Dir::Etc::sourcelist="sources.list.d/backports.list" \
    -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"

wget https://www.openssl.org/source/openssl-1.0.2f.tar.gz
tar xzvf openssl-1.0.2f.tar.gz

mkdir /opt/rebuildnginx
cd /opt/rebuildnginx

# Get Nginx (ppa:nginx/stable) source files
apt-get -t jessie-backports source nginx

# Install the build dependencies
apt-get -t jessie-backports build-dep -y nginx


#--with-openssl=/root/build/openssl-1.0.2f

#wget http://nginx.org/download/nginx-${nginxVersion}.tar.gz
#tar xf nginx-${nginxVersion}.tar.gz
#cd nginx-${nginxVersion}

# Add the desired configuration options to 
# /opt/rebuildnginx/nginx-$PACKAGE_VERSION/debian/rules
pushd nginx-*/debian
sed -ri '/^common_configure_flags := \\$/ a\			--with-http_v2_module \\' rules 
sed -ri '/^common_configure_flags := \\$/ a\			--with-openssl=/root/build/openssl-1.0.2f \\' rules 
sed -ri '/^common_configure_flags := \\$/ a\			--with-openssl-opt="-fPIC" \\' rules 

popd

cd nginx-*
dpkg-buildpackage -b    
mv nginx-common_* ..
#mkdir -p ../nginx_install
#make install DESTDIR=../nginx_install/usr/local
=======
libssl-dev

wget http://nginx.org/download/nginx-${nginxVersion}.tar.gz
tar xf nginx-${nginxVersion}.tar.gz
cd nginx-${nginxVersion}
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

mkdir -p ../nginx_install
make install DESTDIR=../nginx_install
>>>>>>> origin/master
