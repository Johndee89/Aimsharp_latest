@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    set "PROCESS1_NAME=Battle.net*"
    set "PROCESS2_NAME=Wow*"
    set "PROCESS3_NAME=vgc*"

    echo Checking for Battle.net...
    tasklist /NH /FI "IMAGENAME eq %PROCESS1_NAME%" | find /I "Battle.net" >nul
    if errorlevel 1 (
        echo Battle.net is not running.
    ) else (
        echo Found Battle.net. Terminating process...
        for /f "tokens=2" %%i in ('tasklist /NH /FI "IMAGENAME eq %PROCESS1_NAME%"') do taskkill /F /IM "%%i" /T
    )

    echo Checking for World of Warcraft...
    tasklist /NH /FI "IMAGENAME eq %PROCESS2_NAME%" | find /I "WoW" >nul
    if errorlevel 1 (
        echo World of Warcraft is not running.
    ) else (
        echo Found World of Warcraft. Terminating process...
        for /f "tokens=2" %%i in ('tasklist /NH /FI "IMAGENAME eq %PROCESS2_NAME%"') do taskkill /F /IM "%%i" /T
    )

    echo Checking for Vanguard...
    tasklist /NH /FI "IMAGENAME eq %PROCESS3_NAME%" | find /I "Vanguard" >nul
    if errorlevel 1 (
        echo Vanguard is not running.
    ) else (
        echo Found Vanguard. Terminating process...
        for /f "tokens=2" %%i in ('tasklist /NH /FI "IMAGENAME eq %PROCESS3_NAME%"') do taskkill /F /IM "%%i" /T
    )

    REM Check if the Riot Vanguard service is running
    sc query vgc | findstr /I /C:"RUNNING"
    IF %ERRORLEVEL% EQU 0 (
        REM Stop the Riot Vanguard service
        echo Stopping Riot Vanguard service...
        net stop vgc
        echo Riot Vanguard service stopped.
    ) ELSE (
        echo Riot Vanguard service is not running.
    )

    REM Check if the vgk.sys driver is running
    sc query vgk | findstr /I /C:"RUNNING"
    IF %ERRORLEVEL% EQU 0 (
        REM Stop the vgk.sys driver
        echo Stopping vgk.sys driver...
        net stop vgk
        echo vgk.sys driver stopped.
    ) ELSE (
        echo vgk.sys driver is not running.
    )

    REM Check for running vgc processes and kill them
    for /f "tokens=5" %%a in ('sc queryex vgc ^| find "PID"') do (
        echo Killing vgc process with PID %%a...
        taskkill /F /PID %%a
        echo vgc process killed.
    )

    REM Check for running vgk.sys processes and kill them
    for /f "tokens=5" %%a in ('sc queryex vgk ^| find "PID"') do (
        echo Killing vgk.sys process with PID %%a...
        taskkill /F /PID %%a
        echo vgk.sys process killed.
    )

    pushd "%CD%"
    CD /D "%~dp0"
    CD Bin

    pause

    echo --Loading AimsharpWow bot...--
    START AimsharpWow.exe

    echo --Work finished.--

    pause
:--------------------------------------
