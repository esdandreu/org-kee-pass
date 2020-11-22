@echo off
:: Navigate credentials directory
cd %~dp0
cls
:: Path to KeePass
set KeePass=%~dp0KeePass-Windows\KeePass.exe
:SelectParent
echo A shortcut is a file you can double click and search in the windows 
echo search bar. It will directly attempt to open the databases you select.
setlocal enabledelayedexpansion
set N=1
for %%i in (*.kdbx) do (
    echo !N! - %%i
    set databases[!N!]=%%i
    set database_names[!N!]=%%~ni
    set /a N+=1
)
for %%i in (..\*.kdbx) do (
    echo !N! - %%i
    set databases[!N!]=%%i
    set database_names[!N!]=%%~ni
    set /a N+=1
)
set /a N-=1
set choices=
for /l %%i in (1,1,!N!) do set choices=!choices!%%i
choice /C %choices% /M "For which database do you need a shortcut"
set /a database=!ERRORLEVEL!
set database_name=!database_names[%database%]!
set database=!databases[%database%]!
echo Selected "%database_name%"
:CreateShortcut
:: Create the .lnk file in the desktop using a temporal VBA script
set SCRIPT="%~dp0%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "%USERPROFILE%\Desktop\%database_name%.lnk" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%KeePass%" >> %SCRIPT%
echo oLink.Arguments = """%~dp0%database%""" >> %SCRIPT%
echo oLink.IconLocation = "%~dp0KeePass-Windows\Icon.ico" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%
cscript /nologo %SCRIPT%
del %SCRIPT%
:: Check if the shortcut was created correctly
if %ERRORLEVEL% == 0 (
    echo Shortcut created in: 
    echo %USERPROFILE%\Desktop
) else (
    choice /M "Failed shortcut creation, try again "
    if !ERRORLEVEL!==1 (
        goto :CreateShortcut
    ) else (
        goto :Exit
    )
)
:Exit
echo Press any key to close the window . . .
pause>nul
exit 0