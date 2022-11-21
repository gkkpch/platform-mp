#!/usr/bin/env bash
# shellcheck disable=SC2034

## Setup for Volumio "mp2" device (based on Khadas VIM1S)
# Note: these images are using vendor kernel & u-boot, generated with the
#       Khadas Fenix build system

DEVICE_SUPPORT_TYPE="O" # First letter (Community Porting|Supported Officially|OEM)
DEVICE_STATUS="T"       # First letter (Planned|Test|Maintenance)

# Base system
BASE="Debian"
ARCH="armhf"
BUILD="armv7"
UINITRD_ARCH="arm64"

### Device information
DEVICENAME="Volumio MP2"
DEVICE="mp2"
DEVICEFAMILY="mp"
DEVICEBASE="mp2"
#DEVICEREPO="https://github.com/volumio/platform-${DEVICEFAMILY}.git"
DEVICEREPO="https://github.com/gkkpch/platform-${DEVICEFAMILY}.git"

UBOOTBIN="u-boot.bin.sd.bin.signed"
### What features do we want to target
# TODO: Not fully implement
VOLVARIANT=no # Custom Volumio (Motivo/Primo etc)
MYVOLUMIO=no
VOLINITUPDATER=yes

## Partition info
BOOT_START=16
BOOT_END=80
BOOT_TYPE=msdos          # msdos or gpt
BOOT_USE_UUID=yes        # Add UUID to fstab
IMAGE_END=3800
INIT_TYPE="init.nextarm" # init.{x86/nextarm/nextarm_tvbox}
# Modules that will be added to intramsfs
MODULES=("overlay" "squashfs" "nls_cp437" "fuse")

# Packages that will be installed
PACKAGES=("lirc" "fbset" "bluez-firmware"
  "bluetooth" "bluez" "bluez-tools" 
)

### Device customisation
# Copy the device specific files (Image/DTS/etc..)

### Device customisation
# Copy the device specific files (Image/DTS/etc..)
write_device_files() {
  log "Running write_device_files" "ext"

  cp -R "${PLTDIR}/${DEVICEBASE}/boot" "${ROOTFSMNT}"
  cp -R "${PLTDIR}/${DEVICEBASE}/lib/modules" "${ROOTFSMNT}/lib"
  cp -R "${PLTDIR}/${DEVICEBASE}/lib/firmware" "${ROOTFSMNT}/lib"

  #log "Adding Wifi & Bluetooth firmware and helpers NOT COMPLETED, TBS"
  #cp "${PLTDIR}/${DEVICEBASE}/hwpacks/bluez/hciattach-armhf" "${ROOTFSMNT}/usr/local/bin/hciattach"
  #cp "${PLTDIR}/${DEVICEBASE}/hwpacks/bluez/brcm_patchram_plus-armhf" "${ROOTFSMNT}/usr/local/bin/brcm_patchram_plus"

  #log "Adding services"
  #mkdir -p "${ROOTFSMNT}/lib/systemd/system"
  #cp "${PLTDIR}/${DEVICEBASE}/lib/systemd/system/bluetooth-khadas.service" "${ROOTFSMNT}/lib/systemd/system"

  log "Load modules, specific for VIM1S, to /etc/modules" 
  cp "${PLTDIR}/${DEVICEBASE}/etc/modules" "${ROOTFSMNT}/etc"

  log "Add Alsa asound.state" 
  cp -R "${PLTDIR}/${DEVICEBASE}/var" "${ROOTFSMNT}"

  #log "Adding usr/local/bin & usr/bin files"
  #cp -R "${PLTDIR}/${DEVICEBASE}/usr" "${ROOTFSMNT}"

  #log "Copying rc.local with all prepared ${DEVICE} tweaks"
  #cp "${PLTDIR}/${DEVICEBASE}/etc/rc.local" "${ROOTFSMNT}/etc"

  #log "Copying triggerhappy configuration"
  #cp -R "${PLTDIR}/${DEVICEBASE}/etc/triggerhappy" "${ROOTFSMNT}/etc"
}

write_device_bootloader() {

  log "Running write_device_bootloader" "ext"
  dd if="${PLTDIR}/${DEVICE}/u-boot/${UBOOTBIN}" of="${LOOP_DEV}" bs=444 count=1 conv=fsync,notrunc >/dev/null 2>&1
  dd if="${PLTDIR}/${DEVICE}/u-boot/${UBOOTBIN}" of="${LOOP_DEV}" bs=512 skip=1 seek=1 conv=fsync,notrunc >/dev/null 2>&1

}

# Will be called by the image builder for any customisation
device_image_tweaks() {
  :
}

# Will be run in chroot - Pre initramfs
device_chroot_tweaks_pre() {
  log "Performing device_chroot_tweaks_pre" "ext"

  log "Creating boot parameters from template"
  #sed -i "s/#imgpart=UUID=/imgpart=UUID=${UUID_IMG}/g" /boot/env.system.txt
  #sed -i "s/#bootpart=UUID=/bootpart=UUID=${UUID_BOOT}/g" /boot/env.system.txt
  #sed -i "s/#datapart=UUID=/datapart=UUID=${UUID_DATA}/g" /boot/env.system.txt

  sed -i "s/#imgpart=UUID=/imgpart=UUID=${UUID_IMG}/g" /boot/uEnv.txt
  sed -i "s/#bootpart=UUID=/bootpart=UUID=${UUID_BOOT}/g" /boot/uEnv.txt
  sed -i "s/#datapart=UUID=/datapart=UUID=${UUID_DATA}/g" /boot/uEnv.txt

  cat <<-EOF >>/boot/overlays/kvims.dtb.overlay.env
fdt_overlays=i2s spdifout uart_c
EOF

  log "Fixing armv8 deprecated instruction emulation, allow dmesg"
  cat <<-EOF >>/etc/sysctl.conf
#Fixing armv8 deprecated instruction emulation with armv7 rootfs
abi.cp15_barrier=2
#Allow dmesg for non.sudo users
kernel.dmesg_restrict=0
EOF

}

# Will be run in chroot - Post initramfs
device_chroot_tweaks_post() {
  # log "Running device_chroot_tweaks_post" "ext"
  :
}

# Will be called by the image builder post the chroot, before finalisation
device_image_tweaks_post() {
  log "Running device_image_tweaks_post" "ext"
  log "Creating uInitrd from 'volumio.initrd'" "info"
  if [[ -f "${ROOTFSMNT}"/boot/volumio.initrd ]]; then
    mkimage -v -A "${UINITRD_ARCH}" -O linux -T ramdisk -C none -a 0 -e 0 -n uInitrd -d "${ROOTFSMNT}"/boot/volumio.initrd "${ROOTFSMNT}"/boot/uInitrd
    #rm "${ROOTFSMNT}"/boot/volumio.initrd
  fi
  if [[ -f "${ROOTFSMNT}"/boot/boot.cmd ]]; then
    log "Creating boot.scr"
    mkimage -A arm -T script -C none -d "${ROOTFSMNT}"/boot/boot.cmd "${ROOTFSMNT}"/boot/boot.scr
  fi
}

