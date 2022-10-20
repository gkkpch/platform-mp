


## Prerequisites/ recommendation for building with Khadas Fenix


- x86/x64 machine running any OS; at least 4G RAM, SSD, quad core (recommended),
- VirtualBox or similar virtualization software (highly recommended with a minimum of 50GB hard disk space for the virtual disk image)
- The officially supported compilation environment is Ubuntu Jammy 22.04.x amd64 only!
- Superuser rights (configured sudo or root access).

20.10.2022 To be rewritten for use of Khadas BSP "Fenix"


============================================

## Prerequisites/ recommendation for building with Armbian

- x86/x64 machine running any OS; at least 4G RAM, SSD, quad core (recommended),
- VirtualBox or similar virtualization software (highly recommended with a minimum of 25GB hard disk space for the virtual disk image)
- The officially supported compilation environment is Ubuntu Jammy 22.04.x amd64 only!
- Superuser rights (configured sudo or root access).

**Note on current requirements**
Compilation environment support changes from time to time.
A Virtualbox is therefore strongly advised as it gives you more flexibility when your build environment needs to be changed.
Please check https://docs.armbian.com/Developer-Guide_Build-Preparation/ for current needs.

**Note on kernel version**
Kernel 5.x.y in the instructions stands for the *current* mainline kernel version used by Armbian.
This was **5.10.y** at the time of writing this documentation.

## How to build the Armbian kernel and u-boot for Volumio?

Download the armbian build system
```
sudo apt-get install git
git clone https://github.com/armbian/build armbian-volumio
```

Prepare the customized build script & build environment
```
#
echo "Prepare Armbian build script"
#
cd armbian-volumio
cat <<-EOF > compile-custom-mp1.sh
sudo ./compile.sh  BOARD=khadas-vim3l BRANCH=current KERNEL_ONLY=yes KERNEL_CONFIGURE=yes KERNEL_KEEP_CONFIG=yes CREATE_PATCHES=yes
cp output/debs/armbian-firmware_*.deb ../platform-mp/armbian/debs
cp output/debs/linux-headers-*.deb ../platform-mp/armbian/debs
cp output/debs/linux-image-*.deb ../platform-mp/armbian/debs
cp output/debs/linux-u-boot-*.deb ../platform-mp/armbian/debs
cp output/config/linux-meson64-current.config ../platform-mp/armbian/config
EOF
sudo chmod +x compile-custom-mp1.sh
#
echo "Prepare build for Volumio"
#
mkdir -p output/config
mkdir -p output/patch
cd ..
#
echo "Get Volumio platform files"
#
git clone https://${GH_TOKEN}github.com/gkkpch/platform-mp
cd platform-mp
tar xfJ mp1.tar.xz
cd ..
#
echo "Move armbian-volumio build presets to their location"
#
cp platform-mp/armbian/config/* armbian-volumio//output/config
cp platform-mp/armbian/patch/* armbian-volumio/output/patch
```

## Prepare kernel configurations

**Important:**
Before starting the very first compile with *./compile-custom-mp1.sh*, you need to
- create armbian-volumio/output
- copy ```linux-meson64-current.config``` from *platform-mp/armbian* to *armbian-volumio/output/config*.

## Start compiling u-boot and kernel
```
cd armbian-volumio
./compile-custom-mp1.sh
```
The script has 6 main stages
- Armbian main preparation
- user-defined u-boot patching
- uboot compilation
- user-defined kernel patching
- kernel compilation
- conclusion

## Stage Armbian main preparation
*./compile-custom-mp1.sh* will download all further prerequisites.
Once finished downloading and applying all Armbian standard patches,  you get the opportunity to add your own patches (valid both for u-boot and kernel). The script stops for two pre-defined patch breaks.

## Stage break 1, u-boot patching
The first patch break is before compiling u-boot, now modify the sources in *armbian-volumio/output/cache/sources/u-boot/* in the rare occasion that you have them.
Press \<Enter> when finished, also when you don't have any (which would be the  normal case).

## Stage u-boot compilation
Self-explanatory

## Break 2, kernel patching
The 2nd patch break will be before compiling the kernel.
Do any modifications in *output/cache/sources/linux-mainline/linux-5.x.y* (or you when don't have any) press \<Enter>.
**==>** You will find your patches here: *armbian-volumio/output/patch/kernel-meson64-current.patch*.
*kernel-meson64-current.patch* is incremental (meaning your existing ones will be carried over).

## Kernel compilation
Next step is Kernel Configuration, just \<exit> when you do not want to modify anything. If you modify enything, do not forget to press \<save>.

**Note 1:** Kernel comnfiguration settings will be saved for the next build (also when you left with \<exit> without modification).
**Note 2:** When you want to keep a backup of kernel configurations and patches outside the armbian tree, copy them from *armbian/output/patch/* and *armbian/output/config*

## Conclusion

Move the following .deb packages from *armbian/output/debs* to your version of *platform-mp/mp1/*
```
armbian-firmware_x.y.z-trunk_all.deb
linux-headers-current-meson64_x.y.z-trunk_arm64.deb
linux-image-current-meson64_x.y.z-trunk_arm64.deb
linux-u-boot-current-meson64_x.y.z-trunk_arm64.deb
```
Where *x.y.z* is the used armbian version.
This is **22.11.0** at the tiome of writing this documentation.

Refer to ```armbian-firmware-full_x.y.z-trunk_all.deb``` for a full copy of all current firmware for 5.x.y

## Generating platform files

This will be part of the mp1 build recipe.
It will unpack firmware, image and u-boot debs and put the information straight into the right place.

## Note on recompiling
**Recompiling**

Restart the u-boot and kernel compilation.
```
./compile-custom-mp1.sh
```
This time you only need to pay attention to the 2 patch breaks and the kernel config.
Your previous patches and kernel configuration changes will be taken into account (all incremental).





<br />
<br />
<br />
<br />
<sub>Sept/Oct. 2022/ Gé koerkamp
<br />ge.koerkamp@gmail.com
<br />22.09.2022 v1.0 Initial

