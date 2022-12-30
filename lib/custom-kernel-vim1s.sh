#!/bin/bash

DT_OVERLAYS="$HOME/dt-overlays-debs"
PLATFORM="$HOME/platform-mp"
FENIX="$HOME/fenix-vim1s"
export NO_GIT_UPDATE=1

echo "Fetch the pre-compiled Khadas vim1s device tree overlay module .deb file"
if [ ! -e $DT_OVERLAYS ]; then
   git clone http://github.com/numbqq/dt-overlays-debs --depth=1
else
   cd $DT_OVERLAYS
   git pull
   cd ..
fi   
if [ -f $PLATFORM/khadas/debs/vim1s/khadas-vim1s-linux-5.4-dt-overlays* ];then
   rm $PLATFORM/khadas/debs/vim1s/khadas-vim1s-linux-5.4-dt-overlays* 
fi   
echo "... and back it up to the platform folder"
cp $DT_OVERLAYS/jammy/arm64/VIM1S/khadas-vim1s-linux-5.4-dt-overlays_*.deb $PLATFORM/khadas/debs/vim1s/
   
cd $FENIX
source config/version

if [ ! -e build/linux ]; then
   mkdir -p build/linux	
   git clone http://github.com/khadas/linux -b khadas-vims-5.4.y build/linux --depth=1
   cd build/linux
   echo "Backup original Khadas kernel config"
   cp arch/arm64/configs/kvims_defconfig $PLATFORM/khadas/configs/vim1s/kvims_defconfig-original 
   echo "Replace by our own config" 
   cp $PLATFORM/khadas/configs/vim1s/kvims_defconfig arch/arm64/configs/ 
else
   cd build/linux
   echo "Temporary restore backup khadas config"
   cp $PLATFORM/khadas/configs/vim1s/kvims_defconfig-original arch/arm64/configs/kvims_defconfig
   git pull
   echo "Replace by our own config"
   cp $PLATFORM/khadas/configs/vim1s/kvims_defconfig arch/arm64/configs/  
fi

cd $FENIX
source env/setenv.sh -q -s  KHADAS_BOARD=VIM1S LINUX=5.4 UBOOT=2019.01 DISTRIBUTION=Ubuntu DISTRIB_RELEASE=jammy DISTRIB_RELEASE_VERSION=22.04 DISTRIB_TYPE=server DISTRIB_ARCH=arm64 INSTALL_TYPE=SD-USB COMPRESS_IMAGE=no

make kernel-clean
make kernel-config
make kernel-deb
echo "Copying kernel config to platform-mp/configs/vim1s"
cp build/linux/.config $PLATFORM/khadas/configs/vim1s/kvims_defconfig

echo "Cleaning previous .deb files from platform-mp"
rm $PLATFORM/khadas/debs/vim1s/linux-dtb*.deb
rm $PLATFORM/khadas/debs/vim1s/linux-headers*.deb
rm $PLATFORM/khadas/debs/vim1s/linux-image*.deb

echo "Backup new .deb files to platform-mp/debs/vim1s"
cp build/images/debs/$VERSION/VIM1S/linux-dtb*.deb $PLATFORM/khadas/debs/vim1s/
cp build/images/debs/$VERSION/VIM1S/linux-headers*.deb $PLATFORM/khadas/debs/vim1s/
cp build/images/debs/$VERSION/VIM1S/linux-image*.deb $PLATFORM/khadas/debs/vim1s/


echo "Done..."
