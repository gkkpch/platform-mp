#!/bin/bash



if [ ! -e dt-overlays-debs ]; then
   git clone http://github.com/numbqq/dt-overlays-debs --depth=1
else
   cd dt-overlays-debs
   git pull
   cd ..
fi   
if [ -f platform-mp/khadas/debs/mp2/khadas-vim1s-linux-5.4-dt-overlays* ];then
   rm platform-mp/khadas/debs/mp2/khadas-vim1s-linux-5.4-dt-overlays* 
fi   
cp dt-overlays-debs/jammy/arm64/VIM1S/khadas-vim1s-linux-5.4-dt-overlays_*.deb platform-mp/khadas/debs/mp2/
   
cd fenix-mp2
source config/version

if [ ! -e build/linux ]; then
   mkdir -p build/linux	
   git clone http://github.com/khadas/linux -b khadas-vims-5.4.y build/linux 
fi  
cp ../platform-mp/khadas/configs/mp2/kvims_defconfig build/linux/arch/arm64/configs/  

source env/setenv.sh -q -s  KHADAS_BOARD=VIM1S LINUX=5.4 UBOOT=2019.01 DISTRIBUTION=Ubuntu DISTRIB_RELEASE=jammy DISTRIB_RELEASE_VERSION=22.04 DISTRIB_TYPE=server DISTRIB_ARCH=arm64 INSTALL_TYPE=SD-USB COMPRESS_IMAGE=no

make kernel-clean
make kernel-config
make kernel-deb
echo "Copying kernel config to platform-mp/configs/mp2"
cp build/linux/.config ../platform-mp/khadas/configs/mp2/kvims_defconfig

echo "Cleaning previous .deb files from platform-mp"
rm ../platform-mp/khadas/debs/mp2/linux-dtb*.deb
rm ../platform-mp/khadas/debs/mp2/linux-headers*.deb
rm ../platform-mp/khadas/debs/mp2/linux-image*.deb

echo "Copying new .deb files to platform-mp/debs/mp2"
cp build/images/debs/$VERSION/VIM1S/linux-dtb*.deb ../platform-mp/khadas/debs/mp2/
cp build/images/debs/$VERSION/VIM1S/linux-headers*.deb ../platform-mp/khadas/debs/mp2/
cp build/images/debs/$VERSION/VIM1S/linux-image*.deb ../platform-mp/khadas/debs/mp2/
echo "Done..."
