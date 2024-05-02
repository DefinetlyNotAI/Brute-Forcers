@echo off

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

:: Determine the total number of passwords in the wordlist efficiently
for /f "tokens=*" %%a in ('type "%wordlist%" ^| find /v /c ""') do (
    set /a "totalPasswords=%%a"
)

:: Initialize variables
set /a "tried=0"
set /a "found=0"
set /a "updateFrequency=10"

:: Process each word in the wordlist
for /f "tokens=*" %%a in ('type "%wordlist%"') do (
    set "pass=%%a"
    call :attempt
    set /a "tried+=1"
    if %tried% mod %updateFrequency% equ 0 (
        echo Progress: [%%%tried%%]%%totalPasswords% | findstr /C:"100%" >nul && (
            echo Password Found: %pass%
            pause
            exit /b
        )
    )
)

:: Inform the user if no password was found
if %errorlevel% NEQ 0 (
    echo Shitty wordlist, no password found.
)
pause
exit /b

:attempt
"C:\Program Files\WinRAR\WinRAR.exe" x -p%pass% "%archive%" -o"cracked" -y >nul 2>&1
echo Attempting %pass%
if /I %errorlevel% EQU 0 (
    set /a "found+=1"
    echo Password Found: %pass%
    exit /b
)
