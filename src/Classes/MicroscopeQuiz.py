from PreparationRepository import PreparationRepository
from QuizRound import QuizRound

class MicroscopeQuiz:
    """Main quiz application"""

    def __init__(self, repo_file: str = 'preparations.json'):
        self.repo: PreparationRepository = PreparationRepository(repo_file)
        if not self.repo.preparations:
            print("No preparations loaded. Please create preparations.json!")
            return

    def run(self) -> None:
        """Start the quiz"""
        print(f"🔬 Microscope Quiz loaded ({len(self.repo.preparations)} preparations)")
        print("Press Ctrl+C to quit\n")

        try:
            while True:
                round_game = QuizRound(self.repo)
                if not round_game.run():
                    break

                again = input("\nNew round? (y/n): ").lower()
                if again != 'y':
                    break
        except KeyboardInterrupt:
            print("\n\nGoodbye! 👋")

        print("Quiz finished. Thank you!")