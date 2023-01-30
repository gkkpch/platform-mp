# **HOW-TO build a kernel & u-boot using Khadas Fenix**
## **Board coverage: VIM1S and VIM3L** 
### **Prerequisites** 

- x86/x64 machine running any OS; at least 4G RAM, SSD.
- VirtualBox or similar virtualization software (highly recommended with a minimum of 50GB hard disk space for the virtual disk image).
- Supported compilation environment is Ubuntu 20.04 LTS (Focal) or later!
- Superuser rights (configured sudo or root access).

### **Recommendation**
Compilation environment support changes from time to time.
A Virtualbox is therefore strongly advised as it gives you more flexibility when your build environment needs to be changed.

### **Notes on kernel and u-boot version**
Fenix 1.4.2 currently supports 
- VIM1S
    - kernel **5.4.y**
    - u-boot **v2019.01**
- VIM3L
    - kernel **6.1.y** 
    - u-boot **v2021.04**

Please do **not modify** the downloaded Fenix script tree.
These changes will be removed each time the ```custom-kernel.sh``` script (see below) is executed.
In case you do need modifications, save them on the platform folder and re-apply them after the custom script does its initial "git pull".
For an example, see the re-application of the kernel configuration file in ```custom-kernel-mp1.sh```.

## **How to build the Khadas kernel and u-boot for Volumio?**

Install the essentials
```
$ sudo apt-get update
$ sudo apt-get install git
```

Prepare the build environment with 2 separate fenix script folders

```
$ cd $HOME
$ git clone https://${GH_TOKEN}github.com/gkkpch/platform-mp
$ cd platform-mp/lib
$ chmod +x *.sh
$ cd $HOME
$ git clone http://github.com/khadas/fenix fenix-mp1 --depth 1         # VIM3L
$ git clone http://github.com/khadas/fenix fenix-vim1s --depth 1       # VIM1S
```
In case you decide not to clone them to your $HOME folder, then do not forget to
modify the paths in the ```mp1.conf``` and ```vim1s.conf``` files.  
You will find these in ```platform-mp/lib```. Best to quickly review these anyway.

## **Compile u-boot**

Use this when you initially build kernel and u-boot or when taking Fenix updates into account:
### VIM1S

```
$ cd <your platform-mp/lib>
$ ./make-uboot-vim1s.sh
```
### VIM3L
```
$ cd <your platform-mp/lib>
$ ./make-uboot-mp1.sh
```

After succesfull compilation, the u-boot .deb package is transferred automatically to the correct khadas/debs subfolder in the platform repo. It will be used by the Volumio build recipies.

## **Compile the kernel** ##

For VIM1S 
```
$ cd <your platform-mp/lib>
$ ./custom-kernel-vim1s.sh
```
For VIM3L
```
$ cd <your platform-mp/lib>
$ ./custom-kernel.mp1.sh
```
The script has 5 stages
- Preparation 
- Kernel configuration (you can leave with <exit> when there is nothing to do)
- Kernel compilation
- Backing up the kernel configuration to the correct khadas/configs subfolder in the platform repo. It will be picked from there with for the next kernel compile.
- Copying the kernel .deb packages to the correct khadas/debs subfolder in the platform repo. These will be used by the Volumio build recipies.

## **Build the platform files** ##

This step needs to be done to transfer the necessary information from the previously generated .deb files in to the platform-mp folder used by the Volumio 3 build recipe.

For MP1:
```
$ cd <your platform-mp/lib>
$ ./build-platform-mp1.sh
$ cd ..
$ git add mp1ml.tar.xz
$ git commit -m "{your comment}"
$ git push
```

For VIM1S it is similar
```
$ cd <your platform-mp/lib>
$ ./build-platform-vim1s.sh
$ cd ..
$ tar cfJ vim1s.tar.xz ./vim1s
$ git add vim1s.tar.xz
$ git commit -m "{your comment}"
$ git push
```

<br />

## Changelog

<sub> 

|Date|Author|Change
|---|---|---|
|||gkkpch/ Gé koerkamp/ ge.koerkamp@gmail.com
|29.12.2022|gkkpch|v1.1 Completed vim1s platform build
|30.12.2022|gkkpch|v1.2 Completed mp1 platform build
|25.01.2023|gkkpch|v1.3 Optimized some scripts and documentation
|26.01.2023|gkkpch|v1.4 Updated documentation
|30.01.2023|gkkpch|Cleaned up, correct the XATTR/ squashfs issue (lost on 26.01)


