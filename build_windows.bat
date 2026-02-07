@echo off
REM Build script for compiling HistoQuiz to Windows executable
REM This script requires Python and pip to be installed

echo ========================================
echo Building HistoQuiz for Windows
echo ========================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python from https://www.python.org/downloads/
    pause
    exit /b 1
)

echo Installing PyInstaller...
pip install pyinstaller>=6.0.0
if %errorlevel% neq 0 (
    echo ERROR: Failed to install PyInstaller
    pause
    exit /b 1
)

echo.
echo Building executable...
pyinstaller --clean --noconfirm HistoQuiz.spec
if %errorlevel% neq 0 (
    echo ERROR: Build failed
    pause
    exit /b 1
)

echo.
echo ========================================
echo Build completed successfully!
echo ========================================
echo.
echo The executable is located at: dist\HistoQuiz.exe
echo.
echo You can now run HistoQuiz.exe without Python installed!
echo.
pause
