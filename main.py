#!/usr/bin/env python3
"""
HistoQuiz - Microscope Quiz Application
Starts a web-based GUI and opens it in the default browser
"""

import http.server
import socketserver
import json
import os
import webbrowser
import threading
import time
from urllib.parse import urlparse
from src.Classes.PreparationRepository import PreparationRepository


class QuizHTTPHandler(http.server.SimpleHTTPRequestHandler):
    """Custom HTTP handler for the quiz application"""
    
    # Class variable to store the repository
    repo = None
    current_secret = None
    
    def do_GET(self):
        """Handle GET requests"""
        parsed_path = urlparse(self.path)
        
        # Serve the main page
        if parsed_path.path == '/' or parsed_path.path == '':
            self.serve_html()
        # API endpoint to get all preparations
        elif parsed_path.path == '/api/preparations':
            self.send_json(self.get_preparations())
        # API endpoint to start a new round
        elif parsed_path.path == '/api/new_round':
            self.send_json(self.new_round())
        else:
            # Serve static files (if any)
            super().do_GET()
    
    def serve_html(self):
        """Serve the main HTML page"""
        try:
            with open('templates/index.html', 'r', encoding='utf-8') as f:
                content = f.read()
            
            self.send_response(200)
            self.send_header('Content-type', 'text/html; charset=utf-8')
            self.end_headers()
            self.wfile.write(content.encode('utf-8'))
        except FileNotFoundError:
            self.send_error(404, "Template not found")
    
    def send_json(self, data):
        """Send JSON response"""
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps(data).encode('utf-8'))
    
    def get_preparations(self):
        """Return all preparations as JSON"""
        if not self.repo:
            return []
        
        return [
            {
                'number': prep.number,
                'name': prep.name,
                'id': prep.id,
                'link': prep.link
            }
            for prep in self.repo.preparations
        ]
    
    def new_round(self):
        """Start a new round and return the secret preparation"""
        if not self.repo:
            return {}
        
        QuizHTTPHandler.current_secret = self.repo.get_random_preparation()
        
        if not QuizHTTPHandler.current_secret:
            return {}
        
        return {
            'number': QuizHTTPHandler.current_secret.number,
            'name': QuizHTTPHandler.current_secret.name,
            'id': QuizHTTPHandler.current_secret.id,
            'link': QuizHTTPHandler.current_secret.link
        }
    
    def log_message(self, format, *args):
        """Custom log message to reduce verbosity"""
        # Only log important messages, not every request
        if '404' in str(args) or '500' in str(args):
            super().log_message(format, *args)


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
            print(f"🔬 Mikroskop-Quiz gestartet!")
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