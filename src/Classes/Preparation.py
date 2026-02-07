from dataclasses import dataclass


@dataclass
class Preparation:
    """Represents a single preparation/slide"""
    number: str
    name: str
    link: str

    def matches_input(self, user_input: str) -> bool:
        """Check if input matches number or name"""
        clean_input = user_input.lower().strip()
        return (clean_input in self.number.lower() or
                clean_input in self.name.lower())

    def __str__(self) -> str:
        return f"{self.number}: {self.name}"
