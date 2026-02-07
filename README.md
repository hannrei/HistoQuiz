# HistoQuiz 🔬

Ein interaktives Quiz-Tool zum Lernen histologischer Präparate.

## Features

- **Web-GUI**: Moderne grafische Benutzeroberfläche mit:
  - Eingebetteter Präparat-Ansicht im Browser
  - Durchsuchbare Liste aller Präparate
  - Echtzeit-Filterung während der Eingabe
  - Score-Tracking
  - Visuelles Feedback bei richtigen/falschen Antworten
  - Automatisches Öffnen im Standard-Browser

## Installation

Keine zusätzlichen Abhängigkeiten erforderlich! Das Programm nutzt nur Python Standard-Bibliotheken.

**Voraussetzungen:**
- Python 3.6 oder höher

## Verwendung

### Starten

```bash
python3 main.py
```

Das Programm startet automatisch einen lokalen Web-Server und öffnet die Benutzeroberfläche in deinem Standard-Browser.

## Präparate-Daten

Die Präparate werden in `data/preparations.json` gespeichert. Format:

```json
[
  {
    "number": "B9",
    "name": "Thymus",
    "id": "1074"
  }
]
```

## Projekt-Struktur

```
HistoQuiz/
├── main.py              # Haupteinstiegspunkt (startet Web-GUI)
├── data/
│   └── preparations.json # Präparate-Datenbank
├── src/
│   └── Classes/
│       ├── MicroscopeQuiz.py       # Quiz-Logik (für CLI)
│       ├── QuizRound.py            # Einzelne Quiz-Runde
│       ├── Preparation.py          # Präparat-Datenmodell
│       └── PreparationRepository.py # Präparate-Verwaltung
└── templates/
    └── index.html       # Web-GUI Frontend
```

## Spielanleitung

1. Starte mit `python3 main.py`
2. Das Quiz öffnet sich automatisch in deinem Browser
3. Das Quiz startet automatisch mit einem zufälligen Präparat
4. Klicke auf "Präparat im Browser öffnen", um das Präparat zu betrachten
5. Suche nach dem richtigen Präparat in der Liste oder nutze die Suchfunktion
6. Klicke auf das Präparat, um es auszuwählen (wird blau markiert)
7. Klicke auf "Antwort einreichen", um deine Auswahl zu überprüfen
8. Bei richtiger Antwort startet automatisch eine neue Runde

## Lizenz

Siehe LICENSE-Datei für Details.
