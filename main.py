#!/usr/bin/env python3
"""
HistoQuiz - Microscope Quiz Application
Starts a web-based GUI and opens it in the default browser
"""

import socketserver
import os
import webbrowser
import threading
import time
from src.Classes.PreparationRepository import PreparationRepository
from src.Classes.QuizHTTPHandler import QuizHTTPHandler


def open_browser(port, delay=1.5):
    """Open the default web browser after a short delay"""
    time.sleep(delay)
    webbrowser.open(f'http://localhost:{port}')


if __name__ == "__main__":
    # Load the repository
    repo = PreparationRepository('data/preparations.json')
    if not repo.preparations:
        print("Fehler: Keine Präparate geladen. Bitte erstelle preparations.json!")
        exit(1)
    
    # Store repository in the handler class
    QuizHTTPHandler.repo = repo
    
    # Change to the script directory to serve files correctly
    script_dir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(script_dir)
    
    # Default port
    port = 8000
    
    # Create and start the server
    try:
        with socketserver.TCPServer(("", port), QuizHTTPHandler) as httpd:
            print(f"🔬 HistoQuiz gestartet!")
            print(f"📚 {len(repo.preparations)} Präparate geladen")
            print(f"🌐 Browser wird geöffnet...")
            print(f"\n🛑 Drücke Strg+C zum Beenden\n")
            
            # Open browser in a separate thread
            browser_thread = threading.Thread(target=open_browser, args=(port,))
            browser_thread.daemon = True
            browser_thread.start()
            
            httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n\n👋 Quiz beendet. Auf Wiedersehen!")
    except OSError as e:
        if 'Address already in use' in str(e):
            print(f"❌ Port {port} ist bereits in Benutzung.")
            print(f"💡 Beende den laufenden Server oder starte den Computer neu.")
        else:
            print(f"❌ Fehler beim Starten: {e}")