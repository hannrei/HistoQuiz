# Docker Build System for HistoQuiz

This document describes the Docker-based cross-compilation system for building HistoQuiz executables for multiple platforms.

## Overview

The Docker build system allows you to compile HistoQuiz for Windows and Linux from any platform that supports Docker, without needing to install Python or platform-specific dependencies.

## Prerequisites

- [Docker Desktop](https://www.docker.com/get-started) or Docker Engine
- docker-compose (usually included with Docker Desktop)

## Quick Start

To build for all supported platforms:

```bash
./build_all.sh
```

This will create executables in:
- `dist-docker/linux/HistoQuiz` - Linux executable
- `dist-docker/windows/HistoQuiz.exe` - Windows executable

## Platform-Specific Builds

### Linux Only

```bash
docker-compose build build-linux
docker-compose run --rm build-linux
```

The executable will be in `dist-docker/linux/HistoQuiz`.

### Windows Only

```bash
docker-compose build build-windows
docker-compose run --rm build-windows
```

The executable will be in `dist-docker/windows/HistoQuiz.exe`.

## How It Works

### Linux Build

The Linux build uses a standard Python Docker image:
- Base: `python:3.11-slim`
- Installs PyInstaller
- Compiles the application using the HistoQuiz.spec file
- Outputs a standalone Linux executable

### Windows Build

The Windows build uses Wine to cross-compile:
- Base: `tobix/pywine:3.11` (Python + Wine environment)
- Installs PyInstaller via Wine's pip
- Compiles the application for Windows using PyInstaller
- Outputs a standalone Windows .exe file

### macOS Build

macOS executables cannot be cross-compiled due to Apple's licensing restrictions and technical limitations. To build for macOS:
1. Use a macOS machine
2. Run `./build_unix.sh`

## Troubleshooting

### Docker not found
Make sure Docker is installed and running. On Linux, you may need to add your user to the docker group:
```bash
sudo usermod -aG docker $USER
```

### Build fails
Try cleaning Docker's build cache:
```bash
docker-compose build --no-cache
```

### Permission issues
On Linux, if you get permission errors, make sure the build scripts are executable:
```bash
chmod +x build_all.sh
```

## Architecture

```
HistoQuiz/
├── Dockerfile.linux          # Linux build configuration
├── Dockerfile.windows        # Windows build configuration
├── docker-compose.yml        # Orchestrates builds
├── build_all.sh             # Unified build script
├── build_unix.sh            # Native Unix build script
├── build_windows.bat        # Native Windows build script
└── HistoQuiz.spec           # PyInstaller configuration
```

## Benefits

1. **Cross-platform builds**: Build for Windows and Linux from any OS
2. **No Python installation needed**: Docker containers have everything
3. **Reproducible builds**: Same Docker images = same results
4. **Clean environment**: No conflicts with local Python installations
5. **Easy CI/CD**: Can be easily integrated into GitHub Actions or other CI systems

## Future Improvements

- Add automated testing of built executables
- Integrate with GitHub Actions for automatic releases
- Add support for ARM architectures (e.g., Apple Silicon, Raspberry Pi)
