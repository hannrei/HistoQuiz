.PHONY: help clean linux windows macos all

# Default target - show help
help:
	@echo "========================================"
	@echo "HistoQuiz Build System"
	@echo "========================================"
	@echo ""
	@echo "Available targets:"
	@echo "  make linux    - Build for Linux"
	@echo "  make macos    - Build for macOS"
	@echo "  make windows  - Build for Windows"
	@echo "  make all      - Build for current platform"
	@echo "  make clean    - Clean build artifacts"
	@echo ""
	@echo "Requirements:"
	@echo "  - Python 3.6 or higher"
	@echo "  - pip (Python package manager)"
	@echo ""

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf build/ dist/ __pycache__/ src/__pycache__/ src/Classes/__pycache__/
	@echo "Clean complete."

# Build for Linux
linux:
	@echo "========================================"
	@echo "Building HistoQuiz for Linux"
	@echo "========================================"
	@echo ""
	@if ! command -v python3 > /dev/null 2>&1; then \
		echo "ERROR: Python 3 is not installed"; \
		echo "Please install Python 3 from your package manager or https://www.python.org/downloads/"; \
		exit 1; \
	fi
	@echo "Python version: $$(python3 --version)"
	@echo ""
	@echo "Installing/upgrading PyInstaller..."
	@pip3 install --upgrade pyinstaller>=6.0.0
	@echo ""
	@echo "Building executable..."
	@pyinstaller --clean --noconfirm HistoQuiz.spec
	@chmod +x dist/HistoQuiz
	@echo ""
	@echo "========================================"
	@echo "Build completed successfully!"
	@echo "========================================"
	@echo ""
	@echo "The executable is located at: dist/HistoQuiz"
	@echo ""

# Build for macOS
macos:
	@echo "========================================"
	@echo "Building HistoQuiz for macOS"
	@echo "========================================"
	@echo ""
	@if ! command -v python3 > /dev/null 2>&1; then \
		echo "ERROR: Python 3 is not installed"; \
		echo "Please install Python 3 from https://www.python.org/downloads/"; \
		exit 1; \
	fi
	@echo "Python version: $$(python3 --version)"
	@echo ""
	@echo "Installing/upgrading PyInstaller..."
	@pip3 install --upgrade pyinstaller>=6.0.0
	@echo ""
	@echo "Building executable..."
	@pyinstaller --clean --noconfirm HistoQuiz.spec
	@chmod +x dist/HistoQuiz
	@echo ""
	@echo "========================================"
	@echo "Build completed successfully!"
	@echo "========================================"
	@echo ""
	@echo "The executable is located at: dist/HistoQuiz"
	@echo ""

# Build for Windows (must be run on Windows with cmd.exe or PowerShell)
windows:
	@echo "========================================"
	@echo "Building HistoQuiz for Windows"
	@echo "========================================"
	@echo ""
	@echo "Note: This target should be run on Windows"
	@echo "If on Windows, use: build_windows.bat"
	@echo ""
	@if command -v python > /dev/null 2>&1; then \
		echo "Installing/upgrading PyInstaller..."; \
		pip install --upgrade pyinstaller>=6.0.0; \
		echo ""; \
		echo "Building executable..."; \
		pyinstaller --clean --noconfirm HistoQuiz.spec; \
		echo ""; \
		echo "========================================"; \
		echo "Build completed successfully!"; \
		echo "========================================"; \
		echo ""; \
		echo "The executable is located at: dist\\HistoQuiz.exe"; \
	else \
		echo "ERROR: Python is not installed or not in PATH"; \
		echo "Please install Python from https://www.python.org/downloads/"; \
		exit 1; \
	fi

# Build for current platform (auto-detect)
all:
	@if [ "$$(uname)" = "Darwin" ]; then \
		$(MAKE) macos; \
	elif [ "$$(uname)" = "Linux" ]; then \
		$(MAKE) linux; \
	else \
		echo "Windows detected or unknown OS. Please use 'make windows' or 'build_windows.bat'"; \
		exit 1; \
	fi
