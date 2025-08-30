@echo off
:: install.bat
:: qrc installer - Command-line QR code generator

setlocal

set "APP_NAME=qrc"
set "TARGET_DIR=%USERPROFILE%\qrc"
set "EXE_PATH=%TARGET_DIR%\qrc.exe"

echo.
echo [INFO] Installing %APP_NAME%...
echo.

:: Create directory
if not exist "%TARGET_DIR%" (
    mkdir "%TARGET_DIR%"
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to create directory: %TARGET_DIR%
        pause
        exit /b 1
    )
    echo [OK] Directory created: %TARGET_DIR%
) else (
    echo [INFO] Directory already exists: %TARGET_DIR%
)

:: Copy executable
copy /Y "qrc.exe" "%EXE_PATH%" >nul
if %errorlevel% equ 0 (
    echo [OK] %APP_NAME%.exe copied to: %TARGET_DIR%
) else (
    echo [ERROR] Failed to copy qrc.exe
    pause
    exit /b 1
)

:: Add to user PATH using PowerShell (safe method)
echo.
echo [ACTION] Adding path to user environment...

:: Use PowerShell to safely update user PATH
for /f "delims=" %%i in ('powershell -Command "if (($env:PATH -split ';') -notcontains '%TARGET_DIR%') { echo 'add' }"') do set "should_add=%%i"

if "%should_add%"=="add" (
    powershell -Command "[Environment]::SetEnvironmentVariable('PATH', \"$env:PATH;%TARGET_DIR%\", 'User')" >nul
    echo [OK] Path added to user PATH
) else (
    echo [INFO] Path already in user PATH
)

:: Done
echo.
echo [SUCCESS] Installation completed!
echo.
echo You can now use:
echo   qrc -v          - show version
echo   qrc -i "text" -t - show QR in terminal
echo   qrc file.txt -o - save QR as PNG
echo.
echo [TIP] Open a new terminal window for changes to take effect.
echo.
pause