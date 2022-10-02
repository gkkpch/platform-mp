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
    Some work has been done on this today, but not concluded yet. The only option seems to be erasing emmc,
    which might cause additional problems when testing the autoinstaller. This would need support
    from a Volumio core team member on a fresh factory vim3l board (old and new).
    * [x] Check Khadas/ Armbian forum for help
    * [] Test boot issue, from the above, "Old" factory boards now have to be treated the same as the "new"
    Seems clearing emmc is a must
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





Next dev day: 27.09.2022


* [] Create autoinstaller 
    * [] NOTE!!!!: A current 4.9 kernel MP1 device will not be able to "update" to a Kernel 5.0
    This is because it needs a mainline u-boot, we can't change u-boot just with the installer.
    It will need a full-proof initramfs fix, not sure how to do that yet.


<br />
<br />
<br />
<br />
[sub]
2022.10.02/ Gé

