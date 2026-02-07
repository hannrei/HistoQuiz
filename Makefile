.PHONY: help clean linux windows macos all

# Default target - show help
help:
	@echo "========================================"
	@echo "HistoQuiz Build System"
	@echo "========================================"
	@echo ""
	@echo "Available targets:"
	@echo "  make linux    - Build for Linux using Docker"
	@echo "  make macos    - Build for macOS using Docker"
	@echo "  make windows  - Build for Windows using Docker"
	@echo "  make all      - Build for all platforms"
	@echo "  make clean    - Clean build artifacts"
	@echo ""
	@echo "Requirements:"
	@echo "  - Docker"
	@echo "  - docker-compose"
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

# Build for macOS using Docker
macos:
	@echo "========================================"
	@echo "Building HistoQuiz for macOS"
	@echo "Using Docker for cross-compilation"
	@echo "========================================"
	@echo ""
	@echo "Note: True macOS cross-compilation has limitations."
	@echo "This builds a Linux-compatible binary that may need testing on macOS."
	@echo ""
	@mkdir -p dist-docker/macos
	@docker-compose build build-macos
	@docker-compose run --rm build-macos
	@echo ""
	@echo "========================================"
	@echo "Build completed successfully!"
	@echo "========================================"
	@echo ""
	@echo "The executable is located at: dist-docker/macos/HistoQuiz"
	@echo ""

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

# Build for all platforms
all:
	@echo "========================================"
	@echo "Building HistoQuiz for all platforms"
	@echo "========================================"
	@echo ""
	@$(MAKE) linux
	@echo ""
	@$(MAKE) macos
	@echo ""
	@$(MAKE) windows
	@echo ""
	@echo "========================================"
	@echo "All builds completed!"
	@echo "========================================"
	@echo ""
	@echo "Executables are located in:"
	@echo "  - Linux:   dist-docker/linux/HistoQuiz"
	@echo "  - macOS:   dist-docker/macos/HistoQuiz"
	@echo "  - Windows: dist-docker/windows/HistoQuiz.exe"
	@echo ""
