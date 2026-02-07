# Multi-platform build environment for HistoQuiz
FROM python:3.11-slim

# Install dependencies for PyInstaller
RUN apt-get update && apt-get install -y \
    binutils \
    gcc \
    g++ \
    make \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements and install PyInstaller
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt pyinstaller

# Copy the application
COPY . .

# Default command
CMD ["/bin/bash"]
