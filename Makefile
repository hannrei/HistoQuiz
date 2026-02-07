.PHONY: help build-linux build-windows build-windows-arm64 build-macos build-all clean docker-build docker-shell

# Default target
help:
	@echo "HistoQuiz Build System"
	@echo "======================"
	@echo ""
	@echo "Available targets:"
	@echo "  make build-linux        - Build Linux executable (works from any host via Docker)"
	@echo "  make build-windows      - Build Windows executable (x86_64 hosts via Docker)"
	@echo "  make build-windows-arm64 - Build Windows executable (Apple Silicon via Docker)"
	@echo "  make build-macos        - Build macOS executable (requires macOS host)"
	@echo "  make build-all          - Build for all platforms"
	@echo "  make clean              - Remove build artifacts"
	@echo "  make docker-build       - Build Docker image"
	@echo "  make docker-shell       - Open shell in Docker container"
	@echo ""
	@echo "Note: Linux and Windows builds use Docker."
	@echo "      On Apple Silicon (M1/M2/M3), use build-windows-arm64."
	@echo "      macOS builds require macOS due to Apple licensing."
	@echo ""

# Docker image name
DOCKER_IMAGE = histoquiz-builder

# Build Docker image
docker-build:
	@echo "Building Docker image..."
	docker build -t $(DOCKER_IMAGE) .

# Build for Linux using Docker
build-linux: docker-build
	@echo "Building Linux executable..."
	@mkdir -p dist
	docker run --rm -v "$$(pwd)/dist:/app/dist" $(DOCKER_IMAGE) \
		pyinstaller --clean HistoQuiz.spec
	@echo "Linux executable built: dist/HistoQuiz"

# Build for Windows using Docker with Wine
build-windows:
	@echo "Building Windows executable..."
	@echo "Building Docker image for Windows (this may take a few minutes on first run)..."
	docker build -f Dockerfile.windows -t $(DOCKER_IMAGE)-windows . || \
		(echo ""; \
		 echo "ERROR: Docker build failed."; \
		 echo ""; \
		 echo "This may be due to platform compatibility issues."; \
		 echo ""; \
		 echo "If you're on Apple Silicon (M1/M2/M3), try:"; \
		 echo "  make build-windows-arm64"; \
		 echo ""; \
		 echo "Or build natively on Windows using: build-windows.bat"; \
		 exit 1)
	@mkdir -p dist
	@echo "Running Windows build in Docker..."
	docker run --rm -v "$$(pwd):/src" $(DOCKER_IMAGE)-windows
	@echo "Windows executable built: dist/HistoQuiz.exe"

# Build for Windows on ARM64 (Apple Silicon)
build-windows-arm64:
	@echo "Building Windows executable for ARM64 hosts (Apple Silicon)..."
	@echo "Building Docker image with platform emulation..."
	docker build --platform linux/amd64 -f Dockerfile.windows -t $(DOCKER_IMAGE)-windows .
	@mkdir -p dist
	@echo "Running Windows build in Docker..."
	docker run --platform linux/amd64 --rm -v "$$(pwd):/src" $(DOCKER_IMAGE)-windows
	@echo "Windows executable built: dist/HistoQuiz.exe"

# Build for macOS
build-macos:
	@echo "Building macOS executable..."
	@if [ "$$(uname)" = "Darwin" ]; then \
		echo "Running on macOS, building natively..."; \
		pip3 install -q -r requirements.txt pyinstaller 2>/dev/null || pip3 install --user -q -r requirements.txt pyinstaller; \
		pyinstaller --clean HistoQuiz.spec; \
		echo "macOS executable built: dist/HistoQuiz"; \
	else \
		echo "Error: macOS executables must be built on macOS due to Apple restrictions."; \
		echo "Cross-compilation for macOS is not officially supported."; \
		echo ""; \
		echo "To build macOS executables:"; \
		echo "  1. Run 'make build-macos' on a macOS system"; \
		echo "  2. Use GitHub Actions with macOS runners for automated builds"; \
		exit 1; \
	fi

# Build for all platforms (will fail for platforms not available)
build-all:
	@echo "Building for all available platforms..."
	@$(MAKE) build-linux || echo "Linux build failed"
	@$(MAKE) build-windows || echo "Windows build failed or unavailable"
	@$(MAKE) build-macos || echo "macOS build failed or unavailable"
	@echo ""
	@echo "Build process complete. Check dist/ for built executables."

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -rf build dist *.spec.backup
	@echo "Clean complete."

# Open a shell in the Docker container for debugging
docker-shell: docker-build
	docker run --rm -it -v "$$(pwd):/app" $(DOCKER_IMAGE) /bin/bash
