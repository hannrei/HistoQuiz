from typing import List, Optional, Dict
import json
import random
from .Preparation import Preparation


class PreparationRepository:
    """Manages the preparation database"""

    def __init__(self, filepath: str = 'data/preparations.json'):
        self.filepath: str = filepath
        self.preparations: List[Preparation] = self._load()
        self.shown_history: Dict[str, int] = {}  # Track how many times each prep has been shown

    def _load(self) -> List[Preparation]:
        """Load preparations from JSON file"""
        try:
            with open(self.filepath, 'r', encoding='utf-8') as f:
                data = json.load(f)
                return [Preparation(p['number'], p['name'], p['id'])
                        for p in data]
        except FileNotFoundError:
            print(f"Fehler: {self.filepath} nicht gefunden!")
            return []
        except json.JSONDecodeError:
            print(f"Fehler: Ungültiges JSON in {self.filepath}")
            return []

    def search(self, user_input: str) -> List[Preparation]:
        """Return matching preparations"""
        return [p for p in self.preparations if p.matches_input(user_input)]

    def get_random_preparation(self) -> Optional[Preparation]:
        """Get random preparation with decreased probability for already shown ones"""
        if not self.preparations:
            return None
        
        # Calculate weights: preparations shown more often get lower weight
        weights = []
        for prep in self.preparations:
            times_shown = self.shown_history.get(prep.number, 0)
            # Weight decreases exponentially with each showing
            # First time: weight = 1.0, second time: weight = 0.5, third: 0.25, etc.
            weight = 1.0 / (2 ** times_shown)
            weights.append(weight)
        
        # Use weighted random selection
        selected = random.choices(self.preparations, weights=weights, k=1)[0]
        
        # Track this selection
        self.shown_history[selected.number] = self.shown_history.get(selected.number, 0) + 1
        
        return selected
    
    def reset_history(self):
        """Reset the shown preparation history (e.g., for a new game session)"""
        self.shown_history = {}