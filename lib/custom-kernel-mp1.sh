#/bin/bash

source mp1.conf
export NO_GIT_UPDATE=1

cd $FENIX
source config/version

echo "Re-apply the last mofified kernel configuration"  
if [ -f "${PLATFORM}/khadas/configs/mp1ml/kvims_defconfig" ] && [ -e "${FENIX}/build/linux" ]; then
  cp ${PLATFORM}/khadas/configs/mp1ml/kvims_defconfig ${FENIX}/build/linux/arch/arm64/configs/kvims_defconfig  
fi
  
source env/setenv.sh -q -s  KHADAS_BOARD=VIM3L LINUX=mainline UBOOT=mainline DISTRIBUTION=Ubuntu DISTRIB_RELEASE=jammy DISTRIB_RELEASE_VERSION=22.04 DISTRIB_TYPE=server DISTRIB_ARCH=arm64 INSTALL_TYPE=SD-USB COMPRESS_IMAGE=no

make kernel-clean
make kernel-config
make kernel-deb
echo "Copying kernel config to platform-mp/configs/mp1ml"
cp build/linux/.config $PLATFORM/khadas/configs/mp1ml/kvims_defconfig

echo "Removing old kernel .deb files from platform-mp/debs"
rm $PLATFORM/khadas/debs/mp1ml/linux-dtb*.deb
rm $PLATFORM/khadas/debs/mp1ml/linux-headers*.deb
rm $PLATFORM/khadas/debs/mp1ml/linux-image*.deb

echo "Copying the new .deb files to platform-mp/debs"
cp build/images/debs/${VERSION}/VIM3L/linux-dtb*.deb $PLATFORM/khadas/debs/mp1ml/
cp build/images/debs/${VERSION}/VIM3L/linux-headers*.deb $PLATFORM/khadas/debs/mp1ml/
cp build/images/debs/${VERSION}/VIM3L/linux-image*.deb $PLATFORM/khadas/debs/mp1ml/


echo "Done..."
