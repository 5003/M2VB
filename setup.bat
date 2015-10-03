@echo off
setlocal
set PATH=%~dp0lib;%PATH%
set PATH=%VBOX_MSI_INSTALL_PATH%;%PATH%

set BOX_NAME=m2vg_centos_x64
set BOX_URL=file:///C:/Users/Public/boxes/centos65-x86_64-20140116.box
set BOX_HEX=84eda9c4f00c86b62509d1007d4f1cf16b86bccb3795659cb56d1ea0007c3adc
set BOX_HASH=sha256

vagrant up
vagrant halt

set /p BOX_UUID=<%~dp0.vagrant\machines\default\virtualbox\id
for /f "tokens=2 delims==" %%i in (
  '"VBoxManage showvminfo --machinereadable %BOX_UUID% | FINDSTR /R /C:SATA-.-"'
) do (
  REM http://kb.vmware.com/kb/1023856
  REM -d: Defragment
  REM -k: Shrink Virtual Hard Disk
  1023856-vdiskmanager-windows-7.0.1 -d %%i
  1023856-vdiskmanager-windows-7.0.1 -k %%i
)

vagrant package --output "%BOX_NAME%_%BOX_UUID:~,7%.box"
vagrant destroy --force

rd /s /q "%~dp0.vagrant"