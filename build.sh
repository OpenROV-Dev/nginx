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
dpkg-dev

mkdir /opt/buildlocal
cd /opt/buildlocal
#since we are extending an exisitng source, we don't have to add keys or anything
echo "deb http://httpredir.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/backports.list
echo "deb-src http://httpredir.debian.org/debian jessie-backports main" >> /etc/apt/sources.list.d/backports.list

#this command only updates a single source list file
apt-get update -o Dir::Etc::sourcelist="sources.list.d/backports.list" \
    -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"

DIR=${PWD}
wget https://www.openssl.org/source/openssl-1.0.2f.tar.gz
tar xzvf openssl-1.0.2f.tar.gz

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
sed -ri '/^common_configure_flags := \\$/ a\			--with-openssl=/opt/buildlocal/openssl-1.0.2f \\' rules 
sed -ri '/^common_configure_flags := \\$/ a\			--with-openssl-opt="-fPIC" \\' rules 

popd

cd nginx-*
dpkg-buildpackage -b
cd ..    
mv nginx-common_* /build/
#mkdir -p ../nginx_install
#make install DESTDIR=../nginx_install/usr/local

