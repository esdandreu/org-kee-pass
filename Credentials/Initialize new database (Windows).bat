@echo off
:: Navigate credentials directory
cd %~dp0
cls
:: Path to KeePass
set KeePass=%~dp0KeePass-Windows\KeePass.exe
:: Path to KPScript
set KPScript=KeePass-Windows\KPScript.exe
:SelectParent
echo The parent database is a database whose entries should be accessible to
echo any child database
setlocal enabledelayedexpansion
set N=1
for %%i in (*.kdbx) do (
    echo !N! - %%i
    set databases[!N!]=%%~ni
    set /a N+=1
)
if %N% GTR 1 (
    set /a N-=1
    set choices=
    for /l %%i in (1,1,!N!) do set choices=!choices!%%i
    choice /C !choices! /M "Which will be the parent database"
    set /a parent=!ERRORLEVEL!
) else (
    echo No possible parent database was found
    set parent=
    goto :SelectDatabaseName
)
set parent=!databases[%parent%]!
set retries=1
:Authorize
set /p parent_pw=!parent! database password: 
for /f "tokens=* USEBACKQ" %%f in (
    `%KPScript% -c:ListGroups "%parent%.kdbx" -pw:"%parent_pw%"`
) do (
    set temp=%%f
    :: Wrong password?
    if "!temp:~0,1!"=="E" (
        echo %%f
        if %retries% LSS 3 (
            set /a retries+=1
            echo Attempt !retries! of 3 
            goto :Authorize
        ) else (
            echo E: Too many attempts authorizing the parent database
            goto :Exit
        )
    )
    goto :SelectDatabaseName
)
:SelectDatabaseName
set /p new_db_name=New database name: 
:: Select Database Type
echo Personal databases are not shared through Google Drive with the whole
echo company but are stored in your personal employee Google Drive.
choice /M "Do you want to create a personal database"
if %ERRORLEVEL%==1 (
    echo Creating a personal database
    set personal=1
    set new_db="%~dp0..\%new_db_name%.kdbx"
) else (
    echo Creating a shared database
    set personal=0
    set new_db="%~dp0%new_db_name%.kdbx"
)
if exist %new_db% (
    echo The specified database already exists in:
    echo %new_db%
    echo Move or rename the existing database before creating a new one with
    echo the same name and location.
    echo 1 - Try again with another database name
    echo 2 - Create a shortcut to that database in the Desktop folder
    echo 3 - Leave
    choice /C 123 /M "How do you want to proceed"
    if !ERRORLEVEL!==1 (
        goto :SelectDatabaseName
    ) else (
        if !ERRORLEVEL!==2 (
            goto :CreateShortcut
        ) else (
            goto :Exit
        )
    )
) else (
    goto :CreateDatabase
)
:CreateDatabase
set /p pw=New database password: 
if "%pw%"=="" (
    echo You must introduce a password
    goto :CreateDatabase
)
copy ".\KeePass-Windows\EmptyDatabase.kdbx" %new_db% >nul
echo Created database in:
echo %new_db%
%KPScript% -c:ChangeMasterKey %new_db% -pw:default -newpw:"%pw%" >nul
:: Add key
if "%parent%" NEQ "" (
    set parent_url=../!parent!.kdbx
    %KPScript% -c:AddEntry %new_db% -pw:"%pw%" -GroupName:"AutoOpen" -Title:%parent% -Password:%parent_pw% -URL:%parent_url%
    %KPScript% -c:EditEntry %new_db% -pw:"%pw%" -refx-Group:"AutoOpen" -ref-Title:%parent% -set-Focus:Restore>nul
)
choice /M "Do you want to create a shortcut to the new database in the Desktop folder (Recommended)"
if !ERRORLEVEL!==1 (
    goto :CreateShortcut
) else (
    goto :Exit
)
:CreateShortcut
:: Create the .lnk file in the desktop using a temporal VBA script
set SCRIPT="%~dp0%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "%USERPROFILE%\Desktop\%new_db_name%.lnk" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%KeePass%" >> %SCRIPT%
echo oLink.Arguments = ""%new_db%"" >> %SCRIPT%
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