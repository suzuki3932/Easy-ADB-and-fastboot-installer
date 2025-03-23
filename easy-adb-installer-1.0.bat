chcp 65001
@echo off
color 17
echo Easy ADB and Fastboot Installer
echo Creating Folder...
if not exist "C:\platform-tools" mkdir "C:\platform-tools"
cd C:\platform-tools
echo Downloading Files... please wait
where curl >nul 2>&1
if %errorlevel% neq 0 (
echo curl command not found. please install curl and try again.
pause
exit /b 1
)
curl -o platform-tools-latest-windows.zip https://dl.google.com/android/repository/platform-tools-latest-windows.zip?hl=ja
if %errorlevel% neq 0 (
echo Failed to download platform-tools-latest-windows.zip. Error code: %errorlevel%.
pause
exit /b 1
)
echo Download Complete.
echo Installing..
echo Unzipping..
powershell -Command "Expand-Archive -Path 'platform-tools-latest-windows.zip' -DestinationPath '.'"
if %errorlevel% neq 0 (
echo Failed to unzip platform-tools-latest-windows.zip. please try again. Error code: %errorlevel%.
pause
exit /b 1
)
echo Unzip Complete.
if exist platform-tools (
set "ADB_INSTALL_TO=C:\platform-tools\platform-tools"
) else (
set "ADB_INSTALL_TO=C:\platform-tools"
)
echo Are you sure setting path?
choice /c YN /m "yes (y) no(n)"
if %errorlevel% == 1 (
echo Setting path...
setx PATH "%PATH%;%ADB_INSTALL_TO%" /M >nul 2>&1
if %errorlevel% == 1 (
echo Path set successfully.
) else (
echo Failed to set Path. Error code: %errorlevel%.
pause
exit /b 1
)
) else (
echo Path is not set.
)
echo Installed!
echo To execute adb and fastboot command, please install Google USB driver. ggrks
pause
