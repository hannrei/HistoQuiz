#!/bin/bash
# Build script for macOS
# This script builds the HistoQuiz executable for macOS

set -e

echo "Building HistoQuiz for macOS..."
echo ""

# Check if running on macOS
if [ "$(uname)" != "Darwin" ]; then
    echo "Error: This script must run on macOS."
    echo "macOS executables can only be built on macOS due to Apple licensing."
    exit 1
fi

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed."
    echo "Please install Python 3 from python.org or use Homebrew:"
    echo "  brew install python3"
    exit 1
fi

# Install dependencies
echo "Installing dependencies..."
pip3 install -q -r requirements.txt pyinstaller 2>/dev/null || \
    pip3 install --user -q -r requirements.txt pyinstaller

# Clean previous builds
rm -rf build dist

# Build executable
echo ""
echo "Building executable..."
pyinstaller --clean HistoQuiz.spec

echo ""
echo "========================================"
echo "Build successful!"
echo "Executable: dist/HistoQuiz"
echo "========================================"
echo ""
echo "To run: ./dist/HistoQuiz"
