@echo off
set CYGWIN_BASH="C:\APP\cygwin64\bin\bash.exe"
if not exist %CYGWIN_BASH% (
    echo Error: Cygwin not found at %CYGWIN_BASH%
    echo Please install Cygwin or update the path in script
    pause
    exit /b 1
)
echo ------------------------------------ 
echo Start building ipk packadge
echo ------------------------------------

set BUILD_SCRIPT="/cygdrive/c/Users/User/Documents/Git/kvas/ipk/building/build_ipk.sh"
%CYGWIN_BASH% --login -c "%BUILD_SCRIPT%"
pause