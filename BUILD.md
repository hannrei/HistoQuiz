# Building HistoQuiz Executables

This document explains how to build standalone executables for HistoQuiz on Windows, Linux, and macOS.

## Prerequisites

- Docker installed on your system
- Make (usually pre-installed on Linux/macOS, available via Chocolatey/MinGW on Windows)
- For macOS builds: Access to a macOS system

## Platform Support

- **Linux**: ✅ Docker-based, works from any host
- **Windows**: ✅ Docker-based with Wine, works from x86_64/AMD64 hosts
  - ⚠️ Apple Silicon (M1/M2/M3): Use `make build-windows-arm64` (slower due to emulation)
  - Alternative: Build natively on Windows using `build-windows.bat`
- **macOS**: ⚠️ Native only (Apple licensing restrictions)

## Quick Start

### Build for Linux (from any host)
```bash
make build-linux
```
The executable will be in `dist/HistoQuiz`.

### Build for Windows (from x86_64/AMD64 host)
```bash
make build-windows
```
The executable will be in `dist/HistoQuiz.exe`.

### Build for Windows (from Apple Silicon - M1/M2/M3)
```bash
make build-windows-arm64
```
The executable will be in `dist/HistoQuiz.exe`.
**Note:** This uses platform emulation and will be slower on first run.

### Build for macOS (requires macOS)
```bash
make build-macos
```
The executable will be in `dist/HistoQuiz`.

### Build for all platforms
```bash
make build-all
```
Note: macOS build will fail if not run on macOS.

## How It Works

### Linux Build
- Uses Docker with Python 3.11 base image
- Runs PyInstaller inside container
- Outputs Linux ELF executable
- **Works from any host OS via Docker**

### Windows Build
- Uses Docker with Wine (Windows emulator)
- Runs Python for Windows and PyInstaller through Wine
- Outputs Windows PE executable (.exe)
- **Works from any host OS via Docker**

### macOS Build
- Must run natively on macOS (Apple restrictions)
- Uses local PyInstaller installation
- Outputs macOS Mach-O executable
- **Only works on macOS hosts**

## Quick Start Commands

### Simple Build Scripts (No Make Required)

**Windows:**
```cmd
build-windows.bat
```

**Linux:**
```bash
./build-linux.sh
```

**macOS:**
```bash
./build-macos.sh
```

These scripts automatically detect and use Docker when available (Linux), or fall back to local Python installation.

## Platform-Specific Notes

### Building on Linux/macOS
All commands work directly:
```bash
make build-linux
make build-windows
make build-macos  # Only on macOS
```

### Building on Windows
You need Make installed. Options:
1. **WSL2** (Recommended): Use Windows Subsystem for Linux
2. **Git Bash**: Comes with Git for Windows
3. **Chocolatey**: `choco install make`

Then run the same commands:
```bash
make build-linux
make build-windows
```

## Troubleshooting

### Docker not found
Install Docker Desktop from https://www.docker.com/products/docker-desktop

### Permission denied
On Linux, add your user to the docker group:
```bash
sudo usermod -aG docker $USER
```
Then log out and back in.

### Build too slow
The first build takes longer as Docker downloads images. Subsequent builds are faster.

### Windows build fails with "no match for platform in manifest"
This error occurs on Apple Silicon (ARM64) Macs because the Docker image doesn't support ARM64 natively.

**Solution:** Use the ARM64-specific target:
```bash
make build-windows-arm64
```
This will use platform emulation (slower but works).

### Windows build fails with PyInstaller version error
The cdrx/pyinstaller-windows image uses an older Python version. This is expected and handled by the build process.

If you see errors about requirements.txt:
1. Use the Makefile targets (`make build-windows` or `make build-windows-arm64`)
2. Or build natively on Windows using `build-windows.bat`

### macOS build on non-macOS
This is not supported due to Apple's license restrictions. Options:
1. Use a macOS machine
2. Use GitHub Actions with macOS runners
3. Use a macOS virtual machine (requires macOS host)

## Cleaning Up

Remove all build artifacts:
```bash
make clean
```

## Advanced Usage

### Docker Shell
Open an interactive shell in the build container:
```bash
make docker-shell
```

### Manual Build
If Make is not available:
```bash
# Linux (with Docker - recommended)
docker build -t histoquiz-builder .
docker run --rm -v "$(pwd)/dist:/app/dist" histoquiz-builder pyinstaller --clean HistoQuiz.spec

# Windows (with Docker - cross-platform)
docker build -f Dockerfile.windows -t histoquiz-builder-windows .
docker run --rm -v "$(pwd)/dist:/app/dist" histoquiz-builder-windows

# Linux (without Docker)
pip3 install -r requirements.txt pyinstaller
pyinstaller --clean HistoQuiz.spec

# Windows (without Docker, native only)
pip install -r requirements.txt pyinstaller
pyinstaller --clean HistoQuiz.spec

# macOS (Terminal, native only)
pip3 install -r requirements.txt pyinstaller
pyinstaller --clean HistoQuiz.spec
```

## CI/CD Integration

For automated builds, see `.github/workflows/build.yml` for a complete CI/CD pipeline that builds for all platforms.
