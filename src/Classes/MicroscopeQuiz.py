from .PreparationRepository import PreparationRepository
from .QuizRound import QuizRound

class MicroscopeQuiz:
    """Main quiz application"""

    def __init__(self, repo_file: str = 'data/preparations.json'):
        self.repo: PreparationRepository = PreparationRepository(repo_file)
        if not self.repo.preparations:
            print("Keine Präparate geladen. Bitte erstelle preparations.json!")
            return

    def run(self) -> None:
        """Start the quiz"""
        print(f"🔬 HistoQuiz geladen ({len(self.repo.preparations)} Präparate)")
        print("Drücke Strg+C zum Beenden\n")

        try:
            while True:
                round_game = QuizRound(self.repo)
                if not round_game.run():
                    break

                again = input("\nNeue Runde? (j/n): ").lower()
                if again != 'j':
                    break
        except KeyboardInterrupt:
            print("\n\nAuf Wiedersehen! 👋")

        print("Quiz beendet. Vielen Dank!")