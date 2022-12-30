#!/bin/bash

source mp1.conf

echo "Populate $PLATFORM with necessary platform files"
[ -e "/tmp/linux-image" ] && rm -r /tmp/linux-image
[ -e "/tmp/linux-firmware" ] && rm -r /tmp/linux-firmware

mkdir /tmp/linux-image
mkdir /tmp/linux-firmware

echo "Get the latest platform/mp1ml folder" 
cd $PLATFORM
git pull
[ -e mp1ml ] && rm -r mp1ml && tar xfJ mp1ml.tar.xz 
cd ..

echo "Unpacking boot, lib and dtb from Khadas .deb file..."  
dpkg-deb -R $PLATFORM/khadas/debs/mp1ml/linux-image*.deb /tmp/linux-image
cp /tmp/linux-image/boot/vmlinuz-* $PLATFORM/mp1ml/boot/Image
cp /tmp/linux-image/boot/config* $PLATFORM/mp1ml/boot/
cp -R /tmp/linux-image/lib/modules $PLATFORM/mp1ml/lib/
cp -R /tmp/linux-image/usr/lib/linux-image*/amlogic/* $PLATFORM/mp1ml/boot/dtb/amlogic/

echo "Unpacking firmware and merge Khadas-specific firmware with it"
dpkg-deb -R $PLATFORM/khadas/debs/common/armbian-firmware*.deb /tmp/linux-firmware
cp -R /tmp/linux-firmware/lib/firmware $PLATFORM/mp1ml/lib/
cp -R platform-mp/mp1ml/hwpacks/wlan-firmware/* $PLATFORM/mp1ml/lib/firmware

rm -r /tmp/linux-image
rm -r /tmp/linux-firmware

cd $PLATFORM
tar cvfJ mp1ml.tar.xz ./mp1ml

echo "Done"
