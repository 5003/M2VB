@echo off
setlocal
set DATETIMESUFFIX=%DATE:/=-%_%TIME::=%
  set DATETIMESUFFIX=%DATETIMESUFFIX: =0%

set PATH=%~dp0lib;%PATH%
  REM WIN64
  if /i "%PROCESSOR_ARCHITECTURE%"=="amd64" set PATH=%~dp0lib\amd64;%PATH%
set PATH=%VBOX_MSI_INSTALL_PATH%;%PATH%

set BOX_HEX=66b7a6b11e040f20e78ce269c8459918fcb1941c938bacc71bbc48eac33b9cdf
set BOX_HASH=sha256

call :OPTIMIZATION . optimized_only "%~dp0boxes\centos65-x86_64-20131205.box"
  REM Merge
  call :OPTIMIZATION "%~dp0vagrant_files" merged "%output_file%"

goto :eof


:OPTIMIZATION
CD /D %1 2>NUL

set BOX_NAME=m2vg_centos_x64
  set BOX_NAME=%BOX_NAME%_%2

set BOX_URL=%~3
  REM File Protocol
  set BOX_URL=file:///%BOX_URL:\=/%

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

set output_file=%~dp0output\%BOX_NAME%_%DATETIMESUFFIX:~,17%.box
vagrant package --output "%output_file%"
vagrant destroy --force

rd /s /q "%CD%\.vagrant"