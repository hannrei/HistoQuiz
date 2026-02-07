# HistoQuiz 🔬

An interactive quiz tool for learning histological preparations (microscope slides).

## What is this?

HistoQuiz is a fun and educational quiz application that helps you learn about microscope slides. It shows you a random microscope preparation and you have to identify which one it is. The program runs in your web browser - no complicated setup required!

## What You Need

Before you start, you need to have **Python** installed on your computer. Python is a free programming language that this application uses to run.

### Step 1: Install Python

#### For Windows Users:
1. Go to [python.org/downloads](https://www.python.org/downloads/)
2. Click the big yellow button that says "Download Python"
3. Once downloaded, **double-click** the installer file
4. **IMPORTANT**: Check the box that says "Add Python to PATH" at the bottom of the first screen
5. Click "Install Now"
6. Wait for the installation to complete (this may take a few minutes)
7. Click "Close" when finished

#### For Mac Users:
1. Go to [python.org/downloads](https://www.python.org/downloads/)
2. Click the big yellow button that says "Download Python"
3. Once downloaded, **double-click** the .pkg file
4. Follow the installation wizard (click "Continue" and "Install")
5. You may need to enter your Mac password
6. Wait for installation to complete
7. Click "Close" when finished

#### For Linux Users:
Python is usually already installed! Open a terminal and type:
```bash
python3 --version
```
If you see a version number (like "Python 3.9.5"), you're all set! If not, install Python using your package manager:
- Ubuntu/Debian: `sudo apt install python3`
- Fedora: `sudo dnf install python3`

### Step 2: Download HistoQuiz

1. Go to the HistoQuiz page on GitHub
2. Click the green "Code" button
3. Click "Download ZIP"
4. Once downloaded, find the ZIP file (usually in your Downloads folder)
5. **Right-click** the ZIP file and choose "Extract All" (Windows) or "Unarchive" (Mac)
6. Remember where you extracted it!

## How to Run HistoQuiz

### For Windows Users:

1. Open the **File Explorer**
2. Navigate to where you extracted HistoQuiz
3. Click on the address bar at the top (where it shows the folder path)
4. Type `cmd` and press **Enter** - this opens a Command Prompt in that folder
5. Type the following command and press **Enter**:
   ```
   python main.py
   ```
6. Your web browser should automatically open with the quiz!

**Alternative method (easier):**
1. Find the `main.py` file in File Explorer
2. Right-click on it
3. Choose "Open with" → "Python"

### For Mac Users:

1. Open **Finder** and navigate to where you extracted HistoQuiz
2. Right-click (or Control-click) on the HistoQuiz folder
3. Choose "New Terminal at Folder" (or "Services" → "New Terminal at Folder")
4. In the terminal window that opens, type:
   ```bash
   python3 main.py
   ```
5. Press **Enter**
6. Your web browser should automatically open with the quiz!

### For Linux Users:

1. Open a **Terminal**
2. Navigate to the HistoQuiz folder using the `cd` command:
   ```bash
   cd /path/to/HistoQuiz
   ```
   (Replace `/path/to/HistoQuiz` with the actual path to your folder)
3. Type the following command:
   ```bash
   python3 main.py
   ```
4. Press **Enter**
5. Your web browser should automatically open with the quiz!

## How to Play

Once the program starts, here's what you'll see:

1. **A web page opens automatically** in your browser
2. You'll see a microscope preparation ID (like "B9")
3. Click **"Open Preparation in Browser"** to view the microscope slide
4. Look at the list of preparations below
5. Use the search box to find preparations by name (type to filter)
6. **Click on the preparation** you think matches (it will turn blue)
7. Click **"Submit Answer"** to check if you're correct
8. You'll see if you got it right (green) or wrong (red)
9. Your score is shown at the top
10. The next preparation appears automatically - keep playing!

## What If Something Goes Wrong?

### The browser doesn't open automatically
- Don't worry! Open your web browser manually and go to: `http://localhost:8000`

### I see "Port 8000 is already in use"
- This means the program is already running
- **On Windows**: Press `Ctrl + C` in the Command Prompt window to stop it, then try again
- **On Mac/Linux**: Press `Ctrl + C` in the Terminal to stop it, then try again
- Or restart your computer and try again

### I see "Error: No preparations loaded"
- Make sure the file `data/preparations.json` exists in the HistoQuiz folder
- This file contains the quiz questions

### Python is not recognized (Windows)
- You need to install Python (see Step 1 above)
- Make sure you checked "Add Python to PATH" during installation
- If you forgot, uninstall Python and install it again with that box checked

### Command not found: python3 (Mac/Linux)
- Try using `python` instead of `python3`
- If that doesn't work, you need to install Python (see Step 1 above)

## How to Stop the Program

When you're done playing:
- Go to the Command Prompt (Windows) or Terminal (Mac/Linux) window
- Press **Ctrl + C** on your keyboard
- You'll see "Quiz ended. Goodbye!"
- You can now close the window

## Adding Your Own Preparations

If you want to add more microscope preparations to the quiz:

1. Open the file `data/preparations.json` with a text editor (like Notepad on Windows or TextEdit on Mac)
2. Add your preparations following this format:
   ```json
   [
     {"number": "B9", "name": "Thymus", "id": "1074"},
     {"number": "B10", "name": "Liver", "id": "1075"}
   ]
   ```
3. Save the file
4. Restart HistoQuiz

**Note**: Each preparation needs three things:
- `number`: The identification number
- `name`: The name of the preparation  
- `id`: The ID used to view it in the microscope browser

## Technical Information (for developers)

**Requirements:**
- Python 3.6 or higher
- No additional packages needed (uses only Python standard libraries)

**Project Structure:**
```
HistoQuiz/
├── main.py                      # Main entry point
├── data/
│   └── preparations.json        # Preparation database
├── src/
│   └── Classes/
│       ├── QuizHTTPHandler.py          # Web server
│       ├── QuizRound.py                # Quiz round logic
│       ├── Preparation.py              # Preparation data model
│       └── PreparationRepository.py    # Preparation management
└── templates/
    └── index.html               # Web interface
```

## License

See LICENSE file for details.

---

**Need Help?** If you're still having trouble, ask a friend who knows about computers or create an issue on GitHub.
