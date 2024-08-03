
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
    set "PROCESS3_NAME=Vanguard*"

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
    pushd "%CD%"
    CD /D "%~dp0"
    CD Bin


    pause

    echo --Loading AimsharpWow bot...--
    START AimsharpWow.exe

    echo --Work finished.--

    pause

:--------------------------------------