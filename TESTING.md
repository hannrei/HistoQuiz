# Testing the Docker Build System

This document provides instructions for testing the Docker-based cross-compilation system.

## Prerequisites for Testing

1. Docker Desktop or Docker Engine installed
2. docker-compose installed (usually bundled with Docker Desktop)
3. At least 2GB of free disk space for Docker images
4. Internet connection for downloading base images

## Manual Testing Steps

### Test 1: Build All Platforms

```bash
# Navigate to project directory
cd /path/to/HistoQuiz

# Run the unified build script
./build_all.sh
```

**Expected Output:**
- Docker images are built successfully
- Executables are created in:
  - `dist-docker/linux/HistoQuiz`
  - `dist-docker/windows/HistoQuiz.exe`
- No error messages during build

**Validation:**
```bash
# Check if executables exist
ls -lh dist-docker/linux/HistoQuiz
ls -lh dist-docker/windows/HistoQuiz.exe

# Check executable permissions (Linux)
test -x dist-docker/linux/HistoQuiz && echo "✅ Linux executable has correct permissions"
```

### Test 2: Build Linux Only

```bash
# Build Linux executable
docker-compose build build-linux
docker-compose run --rm build-linux
```

**Expected Output:**
- Linux executable in `dist-docker/linux/HistoQuiz`
- Build completes in 1-3 minutes (depending on system)

### Test 3: Build Windows Only

```bash
# Build Windows executable
docker-compose build build-windows
docker-compose run --rm build-windows
```

**Expected Output:**
- Windows executable in `dist-docker/windows/HistoQuiz.exe`
- Build completes in 3-5 minutes (Wine takes longer)

### Test 4: Run the Executables

#### Linux Executable

On a Linux system:
```bash
cd dist-docker/linux
./HistoQuiz
```

Expected: Application starts, web browser opens to http://localhost:8000

#### Windows Executable

On a Windows system:
```cmd
cd dist-docker\windows
HistoQuiz.exe
```

Expected: Application starts, web browser opens to http://localhost:8000

Can also test on Linux using Wine:
```bash
wine dist-docker/windows/HistoQuiz.exe
```

### Test 5: Clean Build

Test that builds work after cleaning:
```bash
# Remove previous builds
rm -rf dist-docker

# Rebuild
./build_all.sh
```

Expected: Fresh build succeeds without errors

### Test 6: GitHub Actions Workflow (Optional)

If you have maintainer access:

1. Create a test tag:
   ```bash
   git tag -a v0.0.1-test -m "Test release"
   git push origin v0.0.1-test
   ```

2. Check GitHub Actions tab for the workflow run

3. Verify artifacts are uploaded and release is created

4. Clean up:
   ```bash
   git tag -d v0.0.1-test
   git push origin :refs/tags/v0.0.1-test
   # Delete the release from GitHub UI
   ```

## Troubleshooting Common Issues

### Issue: Docker not found
**Solution:** Install Docker Desktop from https://www.docker.com/get-started

### Issue: docker-compose not found
**Solution:** Install docker-compose or use `docker compose` (v2 syntax)

### Issue: Permission denied on Linux
**Solution:** Add user to docker group:
```bash
sudo usermod -aG docker $USER
newgrp docker
```

### Issue: Build fails with "no space left on device"
**Solution:** Clean up Docker:
```bash
docker system prune -a
```

### Issue: Windows build is very slow
**Expected:** Wine-based builds take 3-5x longer than Linux builds. This is normal.

### Issue: Executable doesn't run
**Check:**
- On Linux: Executable must have execute permissions
- On Windows: May need to allow through Windows Defender
- Data files: Make sure `data/` and `templates/` are bundled

## Performance Benchmarks (Approximate)

| Platform | Build Time | Image Size | Output Size |
|----------|-----------|------------|-------------|
| Linux    | 1-3 min   | ~500 MB    | ~15 MB      |
| Windows  | 3-7 min   | ~1.5 GB    | ~20 MB      |

*Times vary based on system performance and network speed*

## Verification Checklist

- [ ] `./build_all.sh` completes without errors
- [ ] Linux executable is created and has correct permissions
- [ ] Windows .exe is created
- [ ] Both executables can be run on their respective platforms
- [ ] Application functionality works (can start quiz, select answers)
- [ ] Data files and templates are properly bundled
- [ ] GitHub Actions workflow syntax is valid
- [ ] Documentation is clear and accurate

## Next Steps After Testing

1. If all tests pass, the feature is ready to merge
2. Consider creating pre-built releases for users
3. Update project release process to use Docker builds
4. Monitor GitHub Actions runs for any issues
