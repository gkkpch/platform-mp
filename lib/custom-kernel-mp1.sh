#/bin/bash

cd fenix-mp1
source config/version

echo "Re-apply the last mofified kernel configuration"  
cp ../platform-mp/khadas/configs/mp1ml/VIM1.conf packages/linux-mainline/configs/VIM1.config  
  
source env/setenv.sh -q -s  KHADAS_BOARD=VIM3L LINUX=mainline UBOOT=mainline DISTRIBUTION=Ubuntu DISTRIB_RELEASE=jammy DISTRIB_RELEASE_VERSION=22.04 DISTRIB_TYPE=server DISTRIB_ARCH=arm64 INSTALL_TYPE=SD-USB COMPRESS_IMAGE=no

make kernel-clean
make kernel-config
make kernel-deb
cp .config ../platform-mp/khadas/configs/mp1ml
cp build/images/debs/${VERSION}/VIM3L/linux-dtb*.deb ../platform-mp/khadas/debs/mp1ml/
cp build/images/debs/${VERSION}/VIM3L/linux-headers*.deb ../platform-mp/khadas/debs/mp1ml/
cp build/images/debs/${VERSION}/VIM3L/linux-image*.deb ../platform-mp/khadas/debs/mp1ml/
echo "Done..."
