import webbrowser
import random
from typing import List, Optional
from PreparationRepository import PreparationRepository
from Preparation import Preparation

class QuizRound:


    """Single quiz round"""


def __init__(self, repository: PreparationRepository):
    self.repo: PreparationRepository = repository
    self.secret: Optional[Preparation] = repository.get_random_preparation()


def run(self) -> bool:
    """Execute quiz round"""
    if not self.secret:
        print("No preparations available!")
        return False

    print(f"\n🧬 Round {random.randint(100, 999)} 🧬")
    webbrowser.open(self.secret.link)
    print("Examine the slide. What is it?")
    print("Enter number (B14) or name (Lung). 'quit' to exit.\n")

    while True:
        user_input = input("> ").strip()
        if user_input.lower() == 'quit':
            return False

        candidates: List[Preparation] = self.repo.search(user_input)
        if not candidates:
            print("❌ Not found. Try again!")
            continue

        candidate: Preparation = candidates[0]  # First match
        if candidate.number == self.secret.number:
            print("✅ CORRECT! Great job! 🎉")
            return True
        else:
            print(f"❌ Wrong! It was {self.secret}")
            webbrowser.open(self.secret.link)
            print("Opened for comparison. New guess?\n")
            continue
