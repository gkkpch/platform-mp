#!/bin/bash

echo "Populate platform-mp with necessary platform files"
[ -e "/tmp/linux-image" ] && rm -r /tmp/linux-image
[ -e "/tmp/linux-firmware" ] && rm -r /tmp/linux-firmware
[ -e "/tmp/khadas-dt-overlays" ] && rm -r /tmp/khadas-dt-overlays
mkdir /tmp/linux-image
mkdir /tmp/linux-firmware
mkdir /tmp/khadas-dt-overlays

echo "Get the latest platform/mp2 folder" 
cd platform-mp
git pull
[ -e mp2 ] && rm -r mp2 && tar xfJ mp2.tar.xz 
cd ..

echo "Unpacking boot, lib and dtb from Khadas .deb file..."  
dpkg-deb -R platform-mp/khadas/debs/mp2/linux-image*.deb /tmp/linux-image
cp /tmp/linux-image/boot/vmlinuz-* platform-mp/mp2/boot/Image
cp /tmp/linux-image/boot/config* platform-mp/mp2/boot/
cp -R /tmp/linux-image/lib/modules platform-mp/mp2/lib/
cp -R /tmp/linux-image/usr/lib/linux-image*/amlogic/* platform-mp/mp2/boot/dtb/amlogic/

echo "Unpacking pre-copmpiled khadas vim1s device tree overlay modules"
[ -e platform-mp/mp2/boot/overlays ] && rm -r platform-mp/mp2/boot/overlays
dpkg-deb -R platform-mp/khadas/debs/mp2/khadas-vim1s-linux-5.4-dt-overlays_*.deb /tmp/khadas-dt-overlays
cp -R /tmp/khadas-dt-overlays/boot/overlays platform-mp/mp2/boot
  
echo "Unpacking firmware and merge Khadas-specific firmware with it"
dpkg-deb -R platform-mp/khadas/debs/common/armbian-firmware*.deb /tmp/linux-firmware
cp -R /tmp/linux-firmware/lib/firmware platform-mp/mp2/lib/
cp -R platform-mp/mp2/hwpacks/wlan-firmware/* platform-mp/mp2/lib/firmware

rm -r /tmp/linux-image
rm -r /tmp/linux-firmware
rm -r /tmp/khadas-dt-overlays

echo "Done"
