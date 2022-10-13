## Check list for VIM3L mainline kernel 

**Preparation work** 
* [x] Email Igor Pecovnik
* [x] Collect VIM3L
* [x] Setup protection case
* [x] Test VIM3L/ Check boot factory new
* [x] Setup debug environment
* [x] Setup VM Ubuntu Jammy
* [x] Copy DEXQ build/ adapt for mp1
* [x] Create a default Armbian buster image as a reference
* [failed] Test default Armbian image
    * [x] Fix mainline boot issue (factory initialised boards won't boot mainline kernel)
    Erase emmc with "store init 3", then boot from SD. Works with the "old" board series. 
    This would also need support from a Volumio core team member on a fresh factory vim3l board ("new" series ref. Andrey).
    * [x] Check Khadas/ Armbian forum for help
    * [x] Test boot issue
    * [x] Extract mainline boot script for reference  
  
**03.10.22/ Preparation completed**

**Building volumio-specific kernel and u-boot**
* [x] Develop "automated" Armbian kernel/u-boot build for mp1
* [x] Setup platform files
* [x] Create default kernel config **linux-meson64-current.config** from the default Ubuntu image
* [x] Create default patch file **kernel-meson64-current.patch** (using usb audio as an example)
* [x] Test "automated" Armbian kernel/u-boot build for mp1
* [x] Compress platform files
* [x] Check u-boot "dd" offsets
* [] Check legacy kernel patch(es) from the Volumio Team with Mi, are they still relevant with the mainline kernel? 

**Build recipe for mp1 mainline kernel image**
* [in progress] Develop build recipe for mp1 mainline
    * [x] Extract uboot env (use 'printenv' from u-boot cmd line)
        * [x] Compare with Volumio's legacy u-boot env 
        * [x] Compare with Armbian u-boot script   
* [] Add Volumio patches
    * [] Enable UART3
    * [] Support for higher I2S frequencies (384Khz, check legacy patch)
* [] Setup mainline boot script
    * [x] Volumio-like u-boot script? 
        * [no] or .. stick to the Armbian script standard?
        * [x] or .. mix the two?
    * [x] Watch out for board difference VIM3 and VIM3L (user space may need to know)
    * [fails] Resetting GPIOH_4 to low and echo (gpio 35)  
        * [] GPIOH_4 does not exist, fix for mainline u-boot (unknown gpio)
    * [] Create boot.scr form boot.ini (boot.ini not working with mainline)
        * [x] Initial boot.scr working?
    * [] Recreate "multiboot": "usb -> sd -> emmc" sequence 
* [x] Combine mp1.sh/kvims.sh/nanopim4.sh into a new **mp1ml**
* [] Add wireless and bluetooth (note VIM3/VIM3L differences)
* [] Modify initramfs to check for legacy u-boot in "kernel update block" --> replace by mainline u-boot
* [] Debug boot volumio image

**Mainline u-boot boot issue with Volumio updater**
* [failed] Boot mainline kernel with legacy u-boot
* [x] System still bootable from sd when update u-boot on emmc crashed? 
* [failed] Emergency option, fix via bootloader special recover image (only works on booted device).
* [x] u-boot recovery via specific initrd (simplified installer). This is **THE** only feasible and working option.

**Autoinstaller and u-boot recovery**
* [] Create autoinstaller 
    * [] NOTE!!!!: A current 4.9 kernel MP1 device will not be able to "update" to a Kernel 5.0
    This is because it needs a mainline u-boot, we can't change u-boot just with the Volumio updater.
    It will need a full-proof initramfs fix, not sure how to do that yet.
* [] Create simple u-boot recovery image 

<br />
<br />
<br />
<br />
[sub]
2022.10.13/ Gé

