
## Prerequisites for building with Armbian

- x64 machine with at least 2GB of memory and ~35GB of disk space for a VM, container or native OS,
- Ubuntu Hirsute 21.04 x64 for native building or any [Docker](https://docs.armbian.com/Developer-Guide_Building-with-Docker/) capable x64 Linux for containerised,
  - Hirsute is required for newer non-LTS releases.. ex: Bullseye, Sid, Groovy, Hirsute
  - If building for LTS releases.. ex: Focal, Bionic, Buster, it is possible to use Ubuntu 20.04 Focal, but it is not supported
- superuser rights (configured sudo or root access).

Note 5.x.y in the instructions stands for the *current* mainline kernel version used by Armbian.  
This is **5.10.y** at the time of writing this documentation.

## How to build the Armbian kernel and u-boot for Volumio?

Download the armbian build system
```
sudo apt-get install git
git clone https://github.com/armbian/build armbian-volumio
```
Prepare the customized build script
```
cd armbian-volumio
cat <<-EOF > compile-custom-mp1.sh
sudo ./compile.sh  BOARD=khadas-vim3l BRANCH=current KERNEL_ONLY=yes KERNEL_CONFIGURE=yes KERNEL_KEEP_CONFIG=yes CREATE_PATCHES=yes
EOF
sudo chmod +x compile-custom-mp1.sh
mkdir output
cd ..
git clone https://github.com/gkkpch/platform-mp
cd platform-mp
tar xfJ mp1.tar.xz
cd ..
```

## Prepare kernel configurations

**Important:**  
Before starting the very first compile with *./compile-custom-mp1.sh*, you need to 
- copy ```linux-meson64-current.config``` from *platform-mp/mp1/armbian* to *armbian-volumio/output/config*.

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
This is **22.08.0** at the tiome of writing this documentation.

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

