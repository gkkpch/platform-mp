## Check list for 
* **VIM3L mainline kernel & u-boot**
* **VIM1S vendor kernel & u-boot**

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
**20.10.22/ Preparation reopened for Khadas Fenix use**
* [x] Install khadas-fenix on VM
* [ ] Document build procedure (README.md)
* [x] Contact Khadas (numbqq)
    * [ ] Follow up on Khadas response
    * [ ] Fix GPIOH_4  
    * [ ] Why is Fenix failing since 28.10??

**Building volumio-specific kernel and u-boot**
* [] Develop "automated" Khadas kernel/u-boot build for mp1ml
* [x] Setup platform files
* [x] Create default kernel config **linux-meson64-current.config** from the default Ubuntu image
* [x] Test "automated" Khadas kernel/u-boot build for mp1ml
* [x] Compress platform files
* [x] Check u-boot "dd" offsets
* [x] Check legacy kernel patch(es) from the Volumio Team with Mi, are they still relevant with the mainline kernel? 
* [ ] Add Volumio patches
    * [ ] Enable UART3 (dtb overlay)
    * [ ] Support for higher I2S frequencies (384Khz, check legacy patch)


**28.10.22/ AddVIM1S kernel & u-boot**
* [x] Develop automated Khadas kernel and u-boot build for mp2
* [x] VIM1S kernel (5.4)
* [x] VIM1S u-boot
* [x] Add to platform files
* [failed] Test build
    * [ ] Check Fenix with Khadas 
    * [ ] Correct build process
* [ ] Document build procedure (README.md)

**Build recipe for mp1ml mainline kernel image**
* [in progress] Develop build recipe for mp1 mainline
    * [x] Extract uboot env (use 'printenv' from u-boot cmd line)
        * [x] Compare with Volumio's legacy u-boot env 
        * [x] Compare with Armbian u-boot script   
* [x] Setup mainline boot script
    * [x] Volumio-like u-boot script? 
        * [no] or .. stick to the Armbian script standard?
        * [x] or .. mix the two?
        * [ ] Add overlay dtb handling (see Armbian boot script)
    * [x] Watch out for board difference VIM3 and VIM3L (user space may need to know)
    * [fails] Resetting GPIOH_4 to low and echo (gpio 35)  
        * [ ] GPIOH_4 does not exist, fix for mainline u-boot (unknown gpio)
            * [x] Raise question on Armbian forum
    * [x] Create boot.scr form boot.ini (boot.ini not working with mainline)
        * [x] Initial boot.scr working?
    * [x] Recreate "multiboot": "usb -> sd -> emmc" sequence 
    * [ ] Fix kernel issues resulting from the boot process (nls, alsa, br4cmfmac4359-sdio.khadas.vim3l.txt, more?) 
* [x] Combine mp1.sh/kvims.sh/nanopim4.sh into a new **mp1ml**
* [x] Check Khadas Fenix BSP (firmware changes for mainline, alsa asound.state etc.)
* [x] Add wireless and bluetooth (note VIM3/VIM3L differences)
    * [x] Only copy relevant wifi and bluetooth firmware (see fenix/build-board-deb line 349-362 and kvims.sh)

=== Armbian kernel dropped
* [x] **Switch to Khadas uboot/kernel**
    * [x] small changes mp1ml (use ".deb"-folder "Khadas", use u-boot binary name "uboot.bin.sd.bin")
    * [x] Optimise boot.cmd (minimal)
* [x] Remove ohdmi.service (depricated) and fan.service (not necessary)
* [ ] Add mainline asound.state for vim3l
* [ ] Modify initramfs to check for legacy u-boot in "kernel update block" --> replace by mainline u-boot
* [ ] Debug boot volumio image

**Build recipe for mp2**
* [x] Make an mps-family from mp1ml.sh and mp2.sh
* [ ] Create mp2.sh 
* [ ] Test mp2.sh boot process
* [ ] See if we can change the extlinux.conf method to boot.scr
* [ ] Adapt boot process to volumio requirements

**Mainline u-boot boot issue with Volumio updater**
* [failed] Boot mainline kernel with legacy u-boot
* [x] System still bootable from sd when update u-boot on emmc crashed? 
* [failed] Emergency option, fix via bootloader special recover image (only works on booted device).
* [x] u-boot recovery via specific initrd (simplified installer). This is **THE** only feasible and working option.

**Autoinstallers and u-boot recovery for mp1ml**
* [ ] Create autoinstaller 
    * [ ] NOTE!!!!: A current 4.9 kernel MP1 device will not be able to "update" to a Kernel 5.0
    This is because it needs a mainline u-boot, we can't change u-boot just with the Volumio updater.
    It will need a full-proof initramfs fix, not sure how to do that yet.
* [ ] Create simple u-boot recovery image for mp1ml

<br />
<br />
<br />
<br />
[sub]
2022.11.01/ Gé

