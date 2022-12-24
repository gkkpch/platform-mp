#!/bin/bash

PLATFORM="$HOME/platform-mp"

echo "Populate $PLATFORM with necessary platform files"
[ -e "/tmp/linux-image" ] && rm -r /tmp/linux-image
[ -e "/tmp/linux-firmware" ] && rm -r /tmp/linux-firmware
[ -e "/tmp/khadas-dt-overlays" ] && rm -r /tmp/khadas-dt-overlays
mkdir /tmp/linux-image
mkdir /tmp/linux-firmware
mkdir /tmp/khadas-dt-overlays

echo "Get the latest platform/vim1s folder" 
cd $PLATFORM
git pull
[ -e vim1s ] && rm -r vim1s && tar xfJ vim1s.tar.xz 
cd ..

echo "Unpacking boot, lib and dtb from Khadas .deb file..."  
dpkg-deb -R $PLATFORM/khadas/debs/vim1s/linux-image*.deb /tmp/linux-image
cp /tmp/linux-image/boot/vmlinuz-* $PLATFORM/vim1s/boot/Image
cp /tmp/linux-image/boot/config* $PLATFORM/vim1s/boot/
cp -R /tmp/linux-image/lib/modules $PLATFORM/vim1s/lib/
cp -R /tmp/linux-image/usr/lib/linux-image*/amlogic/* $PLATFORM/vim1s/boot/dtb/amlogic/

echo "Unpacking pre-copmpiled khadas vim1s device tree overlay modules"
[ -e $PLATFORM/vim1s/boot/dtb/amlogic/kvim1s.dtb.overlays ] && rm -r $PLATFORM/vim1s/boot/dtb/amlogic/kvim1s.dtb.overlays
dpkg-deb -R $PLATFORM/khadas/debs/vim1s/khadas-vim1s-linux-5.4-dt-overlays_*.deb /tmp/khadas-dt-overlays
cp -R /tmp/khadas-dt-overlays/boot/overlays/* $PLATFORM/vim1s/boot/dtb/amlogic/

echo "Compile renamesound.dts overlay (which, when used, renames AML_AGUGESOUND to AML_AUGESOUND-V1S"
dtc -O dtb -o $PLATFORM/vim1s/boot/dtb/amlogic/kvim1s.dtb.overlays/renamesound.dtbo $PLATFORM/khadas/patches/vim1s/renamesound.dts
  
echo "Unpacking firmware and merge Khadas-specific firmware with it"
dpkg-deb -R $PLATFORM/khadas/debs/common/armbian-firmware*.deb /tmp/linux-firmware
cp -R /tmp/linux-firmware/lib/firmware $PLATFORM/vim1s/lib/
cp -R $PLATFORM/vim1s/hwpacks/wlan-firmware/* $PLATFORM/vim1s/lib/firmware

rm -r /tmp/linux-image
rm -r /tmp/linux-firmware
rm -r /tmp/khadas-dt-overlays

cd $PLATFORM
tar cvfJ vim1s.tar.xz ./vim1s

echo "Done"
