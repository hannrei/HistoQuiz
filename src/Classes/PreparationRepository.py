from typing import List, Optional
import json
import random
from .Preparation import Preparation


class PreparationRepository:
    """Manages the preparation database"""

    def __init__(self, filepath: str = 'data/preparations.json'):
        self.filepath: str = filepath
        self.preparations: List[Preparation] = self._load()

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
        """Get random preparation"""
        return random.choice(self.preparations) if self.preparations else None