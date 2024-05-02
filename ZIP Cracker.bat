@echo off

:: Set the console color to green text on black background
color 0A

:: Check if WinRAR is installed
if not exist "C:\Program Files\WinRAR\" (
    echo WinRAR Not installed!
    pause
    exit /b
)

:: Prompt for the archive full path
set /p archive="Enter Archive Full Path: "

:: Check if the archive exists
if not exist "%archive%" (
    echo Archive not found!
    pause
    exit /b
)

:: Prompt for the wordlist full path
set /p wordlist="Enter Wordlist Full Path: "

:: Check if the wordlist exists
if not exist "%wordlist%" (
    echo Wordlist not found!
    pause
    exit /b
)

:: Process each word in the wordlist
for /f "tokens=*" %%a in (%wordlist%) do (
    set "pass=%%a"
    call :attempt
)

:: Inform the user if no password was found
if %errorlevel% NEQ 0 (
    echo Shitty wordlist, no password found.
) else (
    echo Password Found: %pass%
)
pause
exit /b

:attempt
"C:\Program Files\WinRAR\WinRAR.exe" x -p%pass% "%archive%" -o"cracked" -y >nul 2>&1
echo Attempting %pass%
if /I %errorlevel% EQU 0 (
    exit /b
)
