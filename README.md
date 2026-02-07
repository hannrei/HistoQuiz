# HistoQuiz 🔬

Ein interaktives Quiz-Tool zum Lernen histologischer Präparate.

## Features

- **CLI-Version**: Klassische Kommandozeilen-Interface
- **Web-GUI**: Moderne grafische Benutzeroberfläche mit:
  - Eingebetteter Präparat-Ansicht im Browser
  - Durchsuchbare Liste aller Präparate
  - Echtzeit-Filterung während der Eingabe
  - Score-Tracking
  - Visuelles Feedback bei richtigen/falschen Antworten

## Installation

Keine zusätzlichen Abhängigkeiten erforderlich! Das Programm nutzt nur Python Standard-Bibliotheken.

**Voraussetzungen:**
- Python 3.6 oder höher

## Verwendung

### Web-GUI starten (empfohlen)

```bash
python3 gui_server.py
```

Dann öffne deinen Browser und navigiere zu: `http://localhost:8000`

**Optional:** Einen anderen Port verwenden:
```bash
python3 gui_server.py 8080
```

### CLI-Version starten

```bash
python3 main.py
```

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
├── main.py              # CLI-Einstiegspunkt
├── gui_server.py        # Web-GUI Server
├── data/
│   └── preparations.json # Präparate-Datenbank
├── src/
│   └── Classes/
│       ├── MicroscopeQuiz.py       # CLI Quiz-Logik
│       ├── QuizRound.py            # Einzelne Quiz-Runde
│       ├── Preparation.py          # Präparat-Datenmodell
│       └── PreparationRepository.py # Präparate-Verwaltung
└── templates/
    └── index.html       # Web-GUI Frontend
```

## Spielanleitung

### Web-GUI
1. Starte den Server mit `python3 gui_server.py`
2. Öffne `http://localhost:8000` in deinem Browser
3. Das Quiz startet automatisch mit einem zufälligen Präparat
4. Klicke auf "Präparat im Browser öffnen", um das Präparat zu betrachten
5. Suche nach dem richtigen Präparat in der Liste oder nutze die Suchfunktion
6. Klicke auf das Präparat, um es auszuwählen (wird blau markiert)
7. Klicke auf "Antwort einreichen", um deine Auswahl zu überprüfen
8. Bei richtiger Antwort startet automatisch eine neue Runde

### CLI
1. Starte mit `python3 main.py`
2. Das Präparat wird automatisch im Browser geöffnet
3. Gib die Nummer (z.B. "B9") oder den Namen (z.B. "Thymus") ein
4. Drücke Enter zum Überprüfen
5. Gib 'quit' ein zum Beenden

## Lizenz

Siehe LICENSE-Datei für Details.
