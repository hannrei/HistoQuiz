# Building HistoQuiz Executables

This document explains how to build standalone executables for HistoQuiz on Windows, Linux, and macOS.

## Prerequisites

- Docker installed on your system
- Make (usually pre-installed on Linux/macOS, available via Chocolatey/MinGW on Windows)
- For macOS builds: Access to a macOS system

## Platform Support

- **Linux**: ✅ Docker-based, works from any host
- **Windows**: ✅ Docker-based with Wine, works from x86_64/AMD64 hosts
  - ❌ Apple Silicon (M1/M2/M3): Wine doesn't work under emulation - see alternatives below
- **macOS**: ⚠️ Native only (Apple licensing restrictions)

### Building on Apple Silicon (M1/M2/M3)

Due to technical limitations with Wine under platform emulation, Windows builds cannot be completed directly on Apple Silicon Macs. Use one of these alternatives:

**Option 1: GitHub Actions (Recommended)**
- A GitHub Actions workflow is included in `.github/workflows/build-executables.yml`
- Push your code to GitHub
- The workflow automatically builds for Linux, Windows, and macOS
- Download the built executables from Actions artifacts
- Enable Actions in your repository settings if needed

**Option 2: Build on Windows**
- Use an actual Windows machine or VM
- Run `build-windows.bat`

**Option 3: Use Cloud Build**
- Use a cloud x86_64 Linux VM (AWS, GCP, Azure, etc.)
- Run `make build-windows` on that VM

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

### Build for Windows (from Apple Silicon)
Apple Silicon Macs cannot build Windows executables locally due to Wine limitations.
Run `make build-windows-arm64` to see available alternatives.

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

### Building on Linux/macOS (x86_64/AMD64)
All commands work directly:
```bash
make build-linux
make build-windows
make build-macos  # Only on macOS
```

### Building on Apple Silicon (ARM64)
Linux and macOS builds work:
```bash
make build-linux    # Works
make build-macos    # Works
```

Windows builds are not supported locally. Run `make build-windows-arm64` for alternatives.

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

**This is a known limitation.** Windows executables cannot be built locally on Apple Silicon.
Run `make build-windows-arm64` to see available alternatives (GitHub Actions, cloud build, or native Windows).

### Windows build fails with Wine errors on Apple Silicon
Wine does not work reliably under platform emulation (QEMU/Rosetta). This includes errors like:
- `virtual.c: alloc_pages_vprot: Assertion failed`
- `failed to start wineboot`

**Solution:** Windows executables cannot be built locally on Apple Silicon. Use one of these alternatives:
1. **GitHub Actions** - Automated builds on GitHub's infrastructure
2. **Cloud build** - Use an x86_64 Linux VM (AWS, Azure, GCP)
3. **Native Windows** - Build directly on a Windows machine using `build-windows.bat`

### Windows build fails with PyInstaller version error
The cdrx/pyinstaller-windows image uses an older Python version. This is expected and handled by the build process.

If you see errors about requirements.txt:
1. Use the Makefile targets (`make build-windows`)
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

## GitHub Actions (Automated Builds)

A GitHub Actions workflow is included that automatically builds executables for all platforms. This is especially useful for Apple Silicon users who cannot build Windows executables locally.

### How to Use

1. **Push your code to GitHub:**
   ```bash
   git push origin main
   ```

2. **Trigger the workflow:**
   - Automatically runs on push to `main` branch
   - Automatically runs on pull requests
   - Manually trigger from the Actions tab

3. **Download artifacts:**
   - Go to the Actions tab in your GitHub repository
   - Click on the latest workflow run
   - Download the artifacts for each platform:
     - `HistoQuiz-Linux` - Linux executable
     - `HistoQuiz-Windows` - Windows executable (.exe)
     - `HistoQuiz-macOS` - macOS executable

### Workflow File

The workflow is defined in `.github/workflows/build-executables.yml`. It:
- Builds Linux on Ubuntu runners using Docker
- Builds Windows on Ubuntu runners using Docker  
- Builds macOS on macOS runners natively
- Uploads all executables as artifacts

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
