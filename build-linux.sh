#!/bin/bash
# Build script for Linux
# This script builds the HistoQuiz executable for Linux

set -e

echo "Building HistoQuiz for Linux..."
echo ""

# Check if we can use Docker
if command -v docker &> /dev/null; then
    echo "Using Docker for build (recommended)..."
    echo ""
    
    # Build Docker image
    echo "Building Docker image..."
    docker build -t histoquiz-builder .
    
    # Build executable
    echo ""
    echo "Building executable..."
    mkdir -p dist
    docker run --rm -v "$(pwd)/dist:/app/dist" histoquiz-builder \
        pyinstaller --clean HistoQuiz.spec
    
    echo ""
    echo "========================================"
    echo "Build successful!"
    echo "Executable: dist/HistoQuiz"
    echo "========================================"
    
elif command -v python3 &> /dev/null; then
    echo "Docker not found. Building with local Python..."
    echo ""
    
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
    
else
    echo "Error: Neither Docker nor Python 3 found."
    echo "Please install Docker or Python 3 to build the executable."
    exit 1
fi

echo ""
echo "To run: ./dist/HistoQuiz"
