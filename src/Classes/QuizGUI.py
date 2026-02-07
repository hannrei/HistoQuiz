import tkinter as tk
from tkinter import ttk, messagebox
import webbrowser
from typing import List, Optional
from .PreparationRepository import PreparationRepository
from .Preparation import Preparation


class QuizGUI:
    """Graphical User Interface for the Microscope Quiz"""

    def __init__(self, repo_file: str = 'data/preparations.json'):
        self.repo = PreparationRepository(repo_file)
        if not self.repo.preparations:
            messagebox.showerror("Fehler", "Keine Präparate geladen. Bitte erstelle preparations.json!")
            return

        self.root = tk.Tk()
        self.root.title("🔬 Mikroskop-Quiz")
        self.root.geometry("900x700")
        
        self.current_secret: Optional[Preparation] = None
        self.score = 0
        self.attempts = 0
        
        self._create_widgets()
        self._start_new_round()

    def _create_widgets(self):
        """Create all GUI widgets"""
        # Top frame with title and score
        top_frame = ttk.Frame(self.root, padding="10")
        top_frame.pack(fill=tk.X)
        
        title_label = ttk.Label(
            top_frame,
            text="🔬 Mikroskop-Quiz 🔬",
            font=("Arial", 20, "bold")
        )
        title_label.pack(side=tk.LEFT)
        
        self.score_label = ttk.Label(
            top_frame,
            text=f"Score: {self.score}/{self.attempts}",
            font=("Arial", 14)
        )
        self.score_label.pack(side=tk.RIGHT)

        # Web view frame
        web_frame = ttk.LabelFrame(self.root, text="Präparat Ansicht", padding="10")
        web_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=5)
        
        self.web_label = ttk.Label(
            web_frame,
            text="Klicke auf 'Präparat im Browser öffnen', um das Präparat zu sehen.",
            font=("Arial", 12),
            justify=tk.CENTER
        )
        self.web_label.pack(expand=True)
        
        self.open_browser_btn = ttk.Button(
            web_frame,
            text="🌐 Präparat im Browser öffnen",
            command=self._open_in_browser
        )
        self.open_browser_btn.pack(pady=10)

        # Search and selection frame
        selection_frame = ttk.LabelFrame(self.root, text="Präparat auswählen", padding="10")
        selection_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=5)
        
        # Search box
        search_frame = ttk.Frame(selection_frame)
        search_frame.pack(fill=tk.X, pady=(0, 10))
        
        ttk.Label(search_frame, text="Suche:").pack(side=tk.LEFT, padx=(0, 5))
        
        self.search_var = tk.StringVar()
        self.search_var.trace('w', self._on_search_changed)
        
        search_entry = ttk.Entry(search_frame, textvariable=self.search_var, width=40)
        search_entry.pack(side=tk.LEFT, fill=tk.X, expand=True)
        
        # Listbox with scrollbar
        list_frame = ttk.Frame(selection_frame)
        list_frame.pack(fill=tk.BOTH, expand=True)
        
        scrollbar = ttk.Scrollbar(list_frame)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        
        self.prep_listbox = tk.Listbox(
            list_frame,
            yscrollcommand=scrollbar.set,
            font=("Arial", 11),
            height=8
        )
        self.prep_listbox.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        scrollbar.config(command=self.prep_listbox.yview)
        
        # Populate listbox with all preparations
        self._update_preparation_list()

        # Control buttons
        button_frame = ttk.Frame(self.root, padding="10")
        button_frame.pack(fill=tk.X)
        
        self.submit_btn = ttk.Button(
            button_frame,
            text="✓ Antwort einreichen",
            command=self._submit_answer
        )
        self.submit_btn.pack(side=tk.LEFT, padx=5)
        
        self.new_round_btn = ttk.Button(
            button_frame,
            text="🔄 Neue Runde",
            command=self._start_new_round
        )
        self.new_round_btn.pack(side=tk.LEFT, padx=5)
        
        quit_btn = ttk.Button(
            button_frame,
            text="❌ Beenden",
            command=self.root.quit
        )
        quit_btn.pack(side=tk.RIGHT, padx=5)
        
        # Status label
        self.status_label = ttk.Label(
            self.root,
            text="Bereit zum Spielen!",
            font=("Arial", 11),
            padding="10"
        )
        self.status_label.pack(fill=tk.X)

    def _update_preparation_list(self, search_text: str = ""):
        """Update the preparation listbox based on search"""
        self.prep_listbox.delete(0, tk.END)
        
        if search_text:
            preparations = self.repo.search(search_text)
        else:
            preparations = self.repo.preparations
        
        for prep in preparations:
            self.prep_listbox.insert(tk.END, f"{prep.number}: {prep.name}")

    def _on_search_changed(self, *args):
        """Called when search text changes"""
        search_text = self.search_var.get()
        self._update_preparation_list(search_text)

    def _open_in_browser(self):
        """Open current preparation in web browser"""
        if self.current_secret:
            webbrowser.open(self.current_secret.link)
            self.status_label.config(text="Präparat im Browser geöffnet. Was ist es?")

    def _start_new_round(self):
        """Start a new quiz round"""
        self.current_secret = self.repo.get_random_preparation()
        if not self.current_secret:
            messagebox.showerror("Fehler", "Keine Präparate verfügbar!")
            return
        
        self.search_var.set("")
        self._update_preparation_list()
        self.status_label.config(
            text=f"🧬 Neue Runde gestartet! Öffne das Präparat und rate, was es ist.",
            foreground="blue"
        )
        self.web_label.config(
            text="Klicke auf 'Präparat im Browser öffnen', um das Präparat zu sehen."
        )

    def _submit_answer(self):
        """Check the selected answer"""
        if not self.current_secret:
            messagebox.showwarning("Warnung", "Keine aktive Runde!")
            return
        
        selection = self.prep_listbox.curselection()
        if not selection:
            messagebox.showwarning("Warnung", "Bitte wähle ein Präparat aus der Liste!")
            return
        
        selected_text = self.prep_listbox.get(selection[0])
        # Extract the preparation number (before the colon)
        selected_number = selected_text.split(':')[0].strip()
        
        # Find the preparation by number
        selected_prep = None
        for prep in self.repo.preparations:
            if prep.number == selected_number:
                selected_prep = prep
                break
        
        self.attempts += 1
        
        if selected_prep and selected_prep.number == self.current_secret.number:
            self.score += 1
            self.status_label.config(
                text=f"✅ RICHTIG! {self.current_secret.number}: {self.current_secret.name} 🎉",
                foreground="green"
            )
            messagebox.showinfo(
                "Richtig!",
                f"✅ RICHTIG! Es war {self.current_secret.number}: {self.current_secret.name}\n\nSehr gut! 🎉"
            )
            self._start_new_round()
        else:
            self.status_label.config(
                text=f"❌ Falsch! Es war {self.current_secret.number}: {self.current_secret.name}",
                foreground="red"
            )
            messagebox.showerror(
                "Falsch!",
                f"❌ Falsch!\n\nEs war: {self.current_secret.number}: {self.current_secret.name}\n\nVersuche es nochmal oder starte eine neue Runde!"
            )
            # Reopen the correct preparation
            webbrowser.open(self.current_secret.link)
        
        self.score_label.config(text=f"Score: {self.score}/{self.attempts}")

    def run(self):
        """Start the GUI application"""
        self.root.mainloop()
