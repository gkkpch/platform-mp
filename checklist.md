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

**Build recipe for mp1 image**
* [] Develop build recipe for mp1 mainline
* [] Add wireless and bluetooth
* [] Setup mainline boot script
* [] Debug boot volumio image




* [] Create autoinstaller 
    * [] NOTE!!!!: A current 4.9 kernel MP1 device will not be able to "update" to a Kernel 5.0
    This is because it needs a mainline u-boot, we can't change u-boot just with the installer.
    It will need a full-proof initramfs fix, not sure how to do that yet.


<br />
<br />
<br />
<br />
[sub]
2022.10.03/ Gé

