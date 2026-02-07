.PHONY: help clean linux windows macos all

# Default target - show help
help:
	@echo "========================================"
	@echo "HistoQuiz Build System"
	@echo "========================================"
	@echo ""
	@echo "Available targets:"
	@echo "  make linux    - Build for Linux using Docker"
	@echo "  make windows  - Build for Windows using Docker"
	@echo "  make macos    - Build for macOS (native only - use build_unix.sh)"
	@echo "  make all      - Build for Linux and Windows"
	@echo "  make clean    - Clean build artifacts"
	@echo ""
	@echo "Requirements:"
	@echo "  - Docker and docker-compose for Linux/Windows builds"
	@echo "  - macOS builds must be done natively (cannot cross-compile)"
	@echo ""

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf build/ dist/ dist-docker/ __pycache__/ src/__pycache__/ src/Classes/__pycache__/
	@echo "Clean complete."

# Build for Linux using Docker
linux:
	@echo "========================================"
	@echo "Building HistoQuiz for Linux"
	@echo "Using Docker for cross-compilation"
	@echo "========================================"
	@echo ""
	@mkdir -p dist-docker/linux
	@docker-compose build build-linux
	@docker-compose run --rm build-linux
	@echo ""
	@echo "========================================"
	@echo "Build completed successfully!"
	@echo "========================================"
	@echo ""
	@echo "The executable is located at: dist-docker/linux/HistoQuiz"
	@echo ""

# Build for macOS - must be done natively
macos:
	@echo "========================================"
	@echo "Building HistoQuiz for macOS"
	@echo "========================================"
	@echo ""
	@echo "ERROR: macOS executables cannot be cross-compiled."
	@echo "Please run this build on a macOS machine using:"
	@echo "  ./build_unix.sh"
	@echo ""
	@echo "PyInstaller does not support cross-compilation to macOS"
	@echo "due to Apple's restrictions and code signing requirements."
	@echo ""
	@false

# Build for Windows using Docker (cross-compilation with Wine)
windows:
	@echo "========================================"
	@echo "Building HistoQuiz for Windows"
	@echo "Using Docker with Wine for cross-compilation"
	@echo "========================================"
	@echo ""
	@mkdir -p dist-docker/windows
	@docker-compose build build-windows
	@docker-compose run --rm build-windows
	@echo ""
	@echo "========================================"
	@echo "Build completed successfully!"
	@echo "========================================"
	@echo ""
	@echo "The executable is located at: dist-docker/windows/HistoQuiz.exe"
	@echo ""

# Build for all supported platforms via Docker
all:
	@echo "========================================"
	@echo "Building HistoQuiz for all platforms"
	@echo "========================================"
	@echo ""
	@$(MAKE) linux
	@echo ""
	@$(MAKE) windows
	@echo ""
	@echo "========================================"
	@echo "All Docker builds completed!"
	@echo "========================================"
	@echo ""
	@echo "Executables are located in:"
	@echo "  - Linux:   dist-docker/linux/HistoQuiz"
	@echo "  - Windows: dist-docker/windows/HistoQuiz.exe"
	@echo ""
	@echo "Note: For macOS, run ./build_unix.sh on a Mac"
	@echo ""
