@echo off
REM Build script for Windows (native build)
REM For cross-platform builds, use: make build-windows (requires Docker)
REM This script builds the HistoQuiz executable natively on Windows

echo Building HistoQuiz for Windows (native build)...
echo.
echo Note: For Docker-based cross-platform build, use: make build-windows
echo.

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Python is not installed or not in PATH.
    echo Please install Python 3.6 or higher from python.org
    pause
    exit /b 1
)

REM Install dependencies
echo Installing dependencies...
pip install -q -r requirements.txt pyinstaller

REM Clean previous builds
if exist build rmdir /s /q build
if exist dist rmdir /s /q dist

REM Build executable
echo.
echo Building executable...
pyinstaller --clean HistoQuiz.spec

REM Check if build was successful
if exist dist\HistoQuiz.exe (
    echo.
    echo ========================================
    echo Build successful!
    echo Executable: dist\HistoQuiz.exe
    echo ========================================
    echo.
) else (
    echo.
    echo Build failed! Check the output above for errors.
    pause
    exit /b 1
)

pause
