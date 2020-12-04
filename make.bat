@echo off
SETLOCAL
cls
echo ******************************************************
echo * DISCLAIMER !                                       *
echo * Use at your own risk.                              *
echo * Unrelated to Azul Systems Inc or its subsidiaries  *
echo * Created for the convenience of Windows 10 users~   *
echo * (if any).                                          *
echo ******************************************************

:Entree
echo ============================
echo = Options                  =
echo = [1] Redeem trial license =
echo = [2] Make Docker Image    =
echo = [*] Exit                 =
echo ============================
set /p optcmd="Your choice :"
if %optcmd%==1 goto GetKeyInput
if %optcmd%==2 goto BuildDkImage
if "%optcmd%" == "" (goto Done)
goto Done

:GetKeyInput
echo =====================================================================
echo = Option 1 : Azul Zing trial license redemption.                    =
echo = Pre-requisite : Applied for a trial key.                          =
echo = How-to get key? : https://info.azul.com/Get-Zing-Trial-Key.html   =
echo =====================================================================
set /p answer="Do you have the trial key? [Y/N]"
if %answer%==Y goto GetTheLic
if %answer%==y goto GetTheLic
goto Entree

:GetTheLic
set /p tid="Enter trial key: "
echo Redeeming.. %tid%
PowerShell.exe -Command "Invoke-WebRequest https://trial-licenses.azul.com/redeem/%tid% -OutFile .\license"
goto Entree

:BuildDkImage
if exist .\license (goto BuildDkGetInput) else (echo No trial license found) 
goto Entree

:BuildDkGetInput
echo **************************************
echo * Option 2 : Build a docker image    *
echo * [1] Zing 8 (default)               *
echo * [2] Zing 11                        *
echo * [3] Zing 13                        *
echo **************************************
set /p zingv="What version of Zing? :"
set /a zingVer = 8
if %zingv% == 2 (set /a zingVer = 11)
if %zingv% == 3 (set /a zingVer = 13)
set /p dkimage="Image name: "
if not "%dkimage%" == "" (PowerShell.exe -Command "docker build -f ./Dockerfile.zing%zingVer% -t %dkimage% .")
goto Entree

:Done
ENDLOCAL
echo End