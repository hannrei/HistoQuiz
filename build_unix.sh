#!/bin/bash
# Build script for compiling HistoQuiz to Linux/Mac executable
# This script requires Python and pip to be installed

echo "========================================"
echo "Building HistoQuiz for Linux/Mac"
echo "========================================"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python 3 is not installed"
    echo "Please install Python 3 from your package manager or https://www.python.org/downloads/"
    exit 1
fi

echo "Python version:"
python3 --version
echo ""

# Check if pip is installed
if ! command -v pip3 &> /dev/null; then
    echo "ERROR: pip3 is not installed"
    echo "Please install pip3 from your package manager"
    exit 1
fi

echo "Installing PyInstaller..."
pip3 install pyinstaller>=6.0.0
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to install PyInstaller"
    exit 1
fi

echo ""
echo "Building executable..."
pyinstaller --clean --noconfirm HistoQuiz.spec
if [ $? -ne 0 ]; then
    echo "ERROR: Build failed"
    exit 1
fi

echo ""
echo "========================================"
echo "Build completed successfully!"
echo "========================================"
echo ""
echo "The executable is located at: dist/HistoQuiz"
echo ""
echo "You can now run ./dist/HistoQuiz without Python installed!"
echo ""

# Make the executable actually executable on Unix systems
chmod +x dist/HistoQuiz
echo "Executable permissions set."
echo ""
