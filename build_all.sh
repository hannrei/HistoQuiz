#!/bin/bash
# Universal build script for all platforms using Docker
# This script builds HistoQuiz for Linux and Windows using Docker containers

set -e  # Exit on error

echo "========================================"
echo "Building HistoQuiz for all platforms"
echo "Using Docker for cross-compilation"
echo "========================================"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ ERROR: Docker is not installed"
    echo "Please install Docker from https://www.docker.com/get-started"
    exit 1
fi

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ ERROR: docker-compose is not installed"
    echo "Please install docker-compose from https://docs.docker.com/compose/install/"
    exit 1
fi

echo "✅ Docker found: $(docker --version)"
echo "✅ Docker Compose found: $(docker-compose --version)"
echo ""

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf dist-docker
mkdir -p dist-docker/linux
mkdir -p dist-docker/windows
echo ""

# Build for all platforms
echo "🔨 Building for Linux..."
docker-compose build build-linux
docker-compose run --rm build-linux
echo ""

echo "🔨 Building for Windows..."
docker-compose build build-windows
docker-compose run --rm build-windows
echo ""

echo "========================================"
echo "✅ Build completed successfully!"
echo "========================================"
echo ""
echo "📦 Executables are located in:"
echo "  - Linux:   dist-docker/linux/HistoQuiz"
echo "  - Windows: dist-docker/windows/HistoQuiz.exe"
echo ""
echo "ℹ️  Note: macOS executables cannot be cross-compiled due to Apple's licensing restrictions."
echo "   To build for macOS, run './build_unix.sh' on a macOS machine."
echo ""
