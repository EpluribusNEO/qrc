@echo off
:: uninstall.bat
:: qrc uninstaller
:: Removes qrc from system and user PATH

setlocal

:: Settings
set "APP_NAME=qrc"
set "TARGET_DIR=%USERPROFILE%\qrc"
set "EXE_PATH=%TARGET_DIR%\qrc.exe"

echo.
echo [INFO] Uninstalling %APP_NAME%...
echo.

:: Remove directory
if exist "%TARGET_DIR%" (
    echo [ACTION] Removing directory: %TARGET_DIR%
    rmdir /s /q "%TARGET_DIR%"
    if %errorlevel% equ 0 (
        echo [OK] Directory removed
    ) else (
        echo [ERROR] Failed to remove directory
        pause
        exit /b 1
    )
) else (
    echo [INFO] Directory not found: %TARGET_DIR%
)

:: Update PATH
echo.
echo [INFO] Updating user PATH variable...

set "PATH_UPDATED=false"
set "NEW_PATH="

for %%i in ("%PATH:;=";"%") do (
    set "item=%%~i"
    if /i "!item!"=="%TARGET_DIR%" (
        set "PATH_UPDATED=true"
    ) else (
        if defined NEW_PATH (
            set "NEW_PATH=!NEW_PATH!;!item!"
        ) else (
            set "NEW_PATH=!item!"
        )
    )
)

if "%PATH_UPDATED%"=="true" (
    echo [ACTION] Removing path from PATH...
    setx PATH "%NEW_PATH%" >nul
    if %errorlevel% equ 0 (
        echo [OK] Path removed from environment
    ) else (
        echo [WARN] PATH updated. Restart terminal to apply.
    )
) else (
    echo [INFO] Path not found in PATH - nothing to remove
)

:: Done
echo.
echo [CLEAN] Uninstallation completed.
echo [TIP] Close and reopen terminal to apply changes.
echo.
pause