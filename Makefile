.PHONY: help build-linux build-windows build-macos build-all clean docker-build docker-shell

# Default target
help:
	@echo "HistoQuiz Build System"
	@echo "======================"
	@echo ""
	@echo "Available targets:"
	@echo "  make build-linux    - Build Linux executable (works from any host via Docker)"
	@echo "  make build-windows  - Build Windows executable (best on Windows, or via CI/CD)"
	@echo "  make build-macos    - Build macOS executable (requires macOS host)"
	@echo "  make build-all      - Build for all platforms"
	@echo "  make clean          - Remove build artifacts"
	@echo "  make docker-build   - Build Docker image"
	@echo "  make docker-shell   - Open shell in Docker container"
	@echo ""
	@echo "Note: Windows builds work best natively on Windows or via GitHub Actions."
	@echo "      Linux builds work from any host using Docker."
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

# Build for Windows - different approach based on OS
build-windows:
	@echo "Building Windows executable..."
	@if command -v python3 > /dev/null 2>&1; then \
		echo "Building with local Python..."; \
		pip3 install -q -r requirements.txt pyinstaller 2>/dev/null || pip3 install --user -q -r requirements.txt pyinstaller; \
		pyinstaller --clean HistoQuiz.spec; \
		if [ -f "dist/HistoQuiz.exe" ]; then \
			echo "Windows executable built: dist/HistoQuiz.exe"; \
		elif [ -f "dist/HistoQuiz" ]; then \
			echo "Note: Built on non-Windows system. Executable is: dist/HistoQuiz"; \
		fi; \
	else \
		echo "Error: Python 3 not found."; \
		echo ""; \
		echo "To build Windows executables:"; \
		echo "  1. On Windows: Install Python 3 and run 'make build-windows'"; \
		echo "  2. Use GitHub Actions for automated multi-platform builds"; \
		echo "  3. Build manually: pip install pyinstaller && pyinstaller HistoQuiz.spec"; \
		exit 1; \
	fi

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
