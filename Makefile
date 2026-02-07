.PHONY: help build-linux build-windows build-macos build-all clean docker-build docker-shell

# Default target
help:
	@echo "HistoQuiz Build System"
	@echo "======================"
	@echo ""
	@echo "Available targets:"
	@echo "  make build-linux    - Build Linux executable (works from any host via Docker)"
	@echo "  make build-windows  - Build Windows executable (requires Docker with Wine)"
	@echo "  make build-macos    - Build macOS executable (requires macOS host or OSXCross)"
	@echo "  make build-all      - Build for all platforms"
	@echo "  make clean          - Remove build artifacts"
	@echo "  make docker-build   - Build Docker image"
	@echo "  make docker-shell   - Open shell in Docker container"
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
		pyinstaller --clean --onefile HistoQuiz.spec
	@echo "Linux executable built: dist/HistoQuiz"

# Build for Windows using Docker with Wine
build-windows: docker-build
	@echo "Building Windows executable..."
	@echo "Note: This requires Wine installed in Docker. Building Windows-specific image..."
	docker build -f Dockerfile.windows -t $(DOCKER_IMAGE)-windows .
	@mkdir -p dist
	docker run --rm -v "$$(pwd)/dist:/app/dist" $(DOCKER_IMAGE)-windows \
		pyinstaller --clean --onefile HistoQuiz.spec
	@echo "Windows executable built: dist/HistoQuiz.exe"

# Build for macOS
build-macos:
	@echo "Building macOS executable..."
	@if [ "$$(uname)" = "Darwin" ]; then \
		echo "Running on macOS, building natively..."; \
		pip install -r requirements.txt pyinstaller; \
		pyinstaller --clean --onefile HistoQuiz.spec; \
		echo "macOS executable built: dist/HistoQuiz"; \
	else \
		echo "Error: macOS executables must be built on macOS due to Apple restrictions."; \
		echo "Cross-compilation for macOS is not officially supported."; \
		echo "Please run 'make build-macos' on a macOS system."; \
		exit 1; \
	fi

# Build for all platforms
build-all: build-linux build-windows build-macos

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -rf build dist *.spec.backup
	@echo "Clean complete."

# Open a shell in the Docker container for debugging
docker-shell: docker-build
	docker run --rm -it -v "$$(pwd):/app" $(DOCKER_IMAGE) /bin/bash
