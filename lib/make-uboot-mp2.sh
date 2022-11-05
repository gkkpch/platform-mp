#!/bin/bash

cd fenix-mp2
source config/version

source env/setenv.sh -q -s  KHADAS_BOARD=VIM1S LINUX=5.4 UBOOT=2019.01 DISTRIBUTION=Ubuntu DISTRIB_RELEASE=jammy DISTRIB_RELEASE_VERSION=22.04 DISTRIB_TYPE=server DISTRIB_ARCH=arm64 INSTALL_TYPE=SD-USB COMPRESS_IMAGE=no

make uboot-deb
cp build/images/debs/$VERSION/VIM1S/linux-u-boot*.deb ../platform-mp/khadas/debs/mp2/
echo "Done..."
