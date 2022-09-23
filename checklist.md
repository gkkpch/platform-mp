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
    * [] Fix mainline boot issue (factory initialised boards won't boot mainline kernel)
    * [] Check Khadas/ Armbian forum for help
    * [] Extract mainline boot script for reference

**Building volumio-specific kernel and u-boot**
* [x] Develop "automated" Armbian kernel/u-boot build for mp1
* [x] Setup platform files
* [x] Create default kernel config **linux-meson64-current.config** from the default Ubuntu image
* [x] Create default patch file **kernel-meson64-current.patch** (using usb audio as an example)
* [x] Test "automated" Armbian kernel/u-boot build for mp1
* [] Compress platform files
* [] Check u-boot "dd" offsets

**Build recipe for mp1 image**
* [] Develop build recipe for mp1 mainline
* [] Add wireless and bluetooth
* [] Setup mainline boot script
* [] Debug boot volumio image








* [] Create autoinstaller 


<br />
<br />
<br />
<br />
[sub]
2022.09.23/ Gé

