#!/bin/bash
set -ex
#Install Pre-req
apt-get update
apt-get install -y rubygems ruby-dev build-essential
gem install fpm
export DIR=${PWD#}
export PACKAGE="nginx"
export PACKAGE_VERSION=1.10.1

ARCH=`uname -m`
if [ ${ARCH} = "armv7l" ]
then
  ARCH="armhf"
fi

./build.sh

#package
cd $DIR
fpm -f -m info@openrov.com -s dir -t deb -a $ARCH \
	-n ${PACKAGE} \
	-v ${PACKAGE_VERSION} \
	--description "NGINX" \
	-C ${DIR}/nginx_install .
