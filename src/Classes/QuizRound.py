import webbrowser
import random
from typing import List, Optional
from .PreparationRepository import PreparationRepository
from .Preparation import Preparation

class QuizRound:
    """Single quiz round"""

    def __init__(self, repository: PreparationRepository):
        self.repo: PreparationRepository = repository
        self.secret: Optional[Preparation] = repository.get_random_preparation()

    def run(self) -> bool:
        """Execute quiz round"""
        if not self.secret:
            print("Keine Präparate verfügbar!")
            return False

        print(f"\n🧬 Runde {random.randint(100, 999)} 🧬")
        webbrowser.open(self.secret.link)
        print("Untersuche das Präparat. Was ist es?")
        print("Gib die Nummer (B14) oder den Namen (Lunge) ein. 'quit' zum Beenden.\n")

        while True:
            user_input = input("> ").strip()
            if user_input.lower() == 'quit':
                return False

            candidates: List[Preparation] = self.repo.search(user_input)
            if not candidates:
                print("❌ Nicht gefunden. Versuche es nochmal!")
                continue

            candidate: Preparation = candidates[0]  # First match
            if candidate.number == self.secret.number:
                print("✅ RICHTIG! Sehr gut! 🎉")
                return True
            else:
                print(f"❌ Falsch! Es war {self.secret}")
                webbrowser.open(self.secret.link)
                print("Zur Vergleichsansicht geöffnet. Neuer Versuch?\n")
                continue
