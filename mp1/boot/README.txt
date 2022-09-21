Boot folder notes
==================
 

File: Image		 	
Khadas kernel vor VIM3L

Folder: dtb			 	
Folder containing the device tress for VIM3L

File: boot.ini	 	
Khadas boot configuration script for normal VIM3L operation.
This file should not be modified, modfied parameters should go into env.user.txt

File: aml_autoscript	
Khadas boot configuration script for booting from an Android emmc uboot environment
This is only used by the Volumio Autoinstaller for VIM3L (mp1)

File: env.system.txt	
Contains volumio-specific boot parameters, read while processing aml_autoscript or boot.ini
DO NOT modify this file, instead add modifications to env.user.txt
For the Volumio Autoinstaller this file will contain an extra parameter "DTB=kvim3l_linux.dtb"
This addition is necessary because the Android uboot environment also identifies a VIM3L as a VIM3.
The DTB parameter will overwrite the incorrect VIM3 default.

File: env.txt
Contains all current boot parameters, read while processing aml_autoscript or boot.ini
DO NOT modify, instead add modified parameters to env.user.txt (will overwrite)


