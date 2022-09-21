##
## this universal script for VOLUMIO VIMx devices
## + mainline uboot + legacy uboot - OK
## + mmc + sd + usb                - OK
##

LABEL=VOLUMIO
UBOOT_KERNEL=Image
UBOOT_UINITRD=uInitrd

UBOOT_ENV_INI=env.txt
UBOOT_ENV_SYS=env.system.txt
UBOOT_ENV_USR=env.user.txt

### ENV FILES REWRITE SEQUENCE ###
#ENVS="$UBOOT_ENV_INI"
#ENVS="$UBOOT_ENV_INI $UBOOT_ENV_USR"
ENVS="$UBOOT_ENV_INI $UBOOT_ENV_USR $UBOOT_ENV_SYS"
##################################

#UUIDCONFIG=$UBOOT_ENV_INI
UUIDCONFIG=$UBOOT_ENV_SYS

UBOOT_SCRIPT=aml_autoscript
VIMAGE_FILE=/volumio_current.sqsh

UBOOT_DTB_DIR=dtb

UBOOT_DTB_VIM1=kvim_linux.dtb
UBOOT_DTB_VIM2=kvim2_linux.dtb
UBOOT_DTB_VIM3=kvim3_linux.dtb
UBOOT_DTB_VIM3L=kvim3l_linux.dtb

UBOOT_DTBM_VIM1=amlogic/meson-gxl-s905x-khadas-vim.dtb
UBOOT_DTBM_VIM2=amlogic/meson-gxm-khadas-vim2.dtb
UBOOT_DTBM_VIM3=amlogic/meson-g12b-a311d-khadas-vim3.dtb
UBOOT_DTBM_VIM3L=amlogic/meson-sm1-khadas-vim3l.dtb

# mainline kernel
SERIAL=ttyAML0,115200n8
# legacy kernel
SERIAL=ttyS0,115200n8

 KERNEL_ADDR=0x11000000
    DTB_ADDR=0x01000000
UINITRD_ADDR=0x13000000


# autodetect dtb file vars
# legacy
DTB=
# mainline
DTBM=
BOARD=

# NOTE: no need to use env everywhere we can use just local vars !

echo "Starting $LABEL $UBOOT_SCRIPT..."

#
# fix to custom uboot display init + logo
#
if test "$init_display2" = ""; then
echo "[i] setup custom init for display"
setenv init_display 'run init_display2'
setenv init_display2 'mode=1080p60hz; hdmitx output $mode; vout output $mode; osd open; osd clear; load mmc 1 $loadaddr logo.bmp && bmp display $loadaddr && bmp scale; osd close'
saveenv
run init_display2
fi
#

## booted from LEGACY UBOOT
echo "Board: $hwver CPUS: $maxcpus"
if test "$hwver" = "VIM1.V13" || test "$hwver" = "VIM1.V12" || test "$hwver" = "VIM1.V14" ; then
    BOARD=VIM1; DTB=$UBOOT_DTB_VIM1; DTBM=$UBOOT_DTBM_VIM1
else
    if test "$maxcpus" = "8"; then
	BOARD=VIM2; DTB=$UBOOT_DTB_VIM2; DTBM=$UBOOT_DTBM_VIM2
    else
	if test "$maxcpus" = "4"; then
	    BOARD=VIM3L; DTB=$UBOOT_DTB_VIM3L; DTBM=$UBOOT_DTBM_VIM3L
	else
	    BOARD=VIM3; DTB=$UBOOT_DTB_VIM3; DTBM=$UBOOT_DTBM_VIM3
	fi
    fi
fi

## booted from MAINLINE UBOOT

test "$fdtfile" = "$UBOOT_DTBM_VIM1"  && DTB=$UBOOT_DTB_VIM1
test "$fdtfile" = "$UBOOT_DTBM_VIM2"  && DTB=$UBOOT_DTB_VIM2
test "$fdtfile" = "$UBOOT_DTBM_VIM3"  && DTB=$UBOOT_DTB_VIM3
test "$fdtfile" = "$UBOOT_DTBM_VIM3L" && DTB=$UBOOT_DTB_VIM3L
test "$fdtfile" = "" || DTBM=$fdtfile

## fixup dtb paths
DTB=$UBOOT_DTB_DIR/$DTB
DTBM=$UBOOT_DTB_DIR/$DTBM
##

## INFO

echo "[i] DTBM   $DTBM"
echo "[i] KERNEL $UBOOT_KERNEL"
echo "[i] INITRD $UBOOT_UINITRD"
echo "[i] ENV    $UBOOT_ENV_INI"

## Boot support for USB, SD and eMMC devices, order:
## 0 - USB, highest priority
## 1 - SD card, higher priority
## 2 - eMMC
## With Volumio, each device will only hold boot files in the first (FAT32) partition

##
## this is emmc image no need init and scan usb becouse we just spend 5 sec more
##

DEVTYPES="mmc"
DEVTYPES="usb mmc"
DEVNUMS="0 1 2"

## mainline storeboot scan # devnum # devtype
## core device devnr

test "$device" = "" || DEVTYPES=$device
test "$devnr" = "" || DEVNUMS=$devnr
test "$devtype" = "" || DEVTYPES=$devtype
test "$devnum" = "" || DEVNUMS=$devnum

for dev_type in $DEVTYPES; do
test "$dev_type" = "usb" && usb start
for dev_num in $DEVNUMS; do

    LOADER="fatload $dev_type $dev_num"
    echo "[i] Scanning $dev_type $dev_num..."

## IMPORT CONFIGS BY ENVS ORDER
    for E in $ENVS; do
    if $LOADER $loadaddr $E; then
	echo "[i] Import $E"
	env import -t $loadaddr $filesize
    fi
    done
    echo "[i] Final DTB $DTB"
    if $LOADER $UINITRD_ADDR $UBOOT_UINITRD; then
	if $LOADER $KERNEL_ADDR $UBOOT_KERNEL; then
	    if $LOADER $DTB_ADDR $DTB || $LOADER $DTB_ADDR $DTBM; then

## fixup partition remove from dtb
fdt addr $DTB_ADDR
fdt resize 65536
fdt rm /partitions
#fdt set /adc_keypad key_val <120>

hdmiargs="logo=${display_layer},loaded,${fb_addr},${outputmode} vout=${outputmode},enable hdmimode=${hdmimode} plymouth.ignore-serial-consoles"
test "X$lcd_exist" = "X1" && panelargs="panel_exist=${lcd_exist} panel_type=${panel_type}"
volumioargs="imgpart=$imgpart imgfile=$VIMAGE_FILE bootpart=$bootpart datapart=$datapart bootconfig=$UUIDCONFIG hwdevice=${hwver}"
# set first prio for UART console
condev="console=tty0 console=$SERIAL no_console_suspend consoleblank=0"
# lookup ethernet mac
test "$mac" = "" && mac=$eth_mac
test "$mac" = "" && mac=$ethaddr
bootargs_="${volumioargs} ${condev} ${hdmiargs} ${panelargs} fsck.repair=yes net.ifnames=0 ddr_size=${ddr_size} wol_enable=${wol_enable} mac=${mac} fan=${fan_mode} hwver=${hwver} coherent_pool=${dma_size}"

		## append to bootargs BOOTARGS_USER
		setenv bootargs "$bootargs_ $BOOTARGS_USER"
		## rewrite bootargs if defined BOOTARGS
		test "$BOOTARGS" = "" || setenv bootargs "$BOOTARGS"
		sleep 1
		echo "[i] bootargs: $bootargs"
		echo "[i] Booting..."
		#
		osd close 
		#
		## start
		booti $KERNEL_ADDR $UINITRD_ADDR $DTB_ADDR
		## never come there if prev cmd OK
		echo "[i] fail..."

	    fi
	fi
    fi

done
done

## END ##

## hyphop ##
