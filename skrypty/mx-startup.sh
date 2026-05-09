#!/bin/bash

# 1. Czekamy na sieć (ważne przy starcie systemu)
sleep 10

# 2. Wczytanie tożsamości komputera (ID)
if [ -f /home/uzytkownik/.magazyn/machine_info.conf ]; then
    source /home/uzytkownik/.magazyn/machine_info.conf
else
    COMPUTER_ID="NIEZNANY"
fi

# 3. Pobieramy i wykonujemy instrukcje GLOBALNE (dla wszystkich NGO)
curl -s https://raw.githubusercontent.com/mx-ecosystem/core-update/main/updater.sh | bash

# 4. Pobieramy i wykonujemy instrukcje DEDYKOWANE (tylko dla tego ID)
# Jeśli plik na GitHubie nie istnieje, curl po prostu nic nie wykona
if [ "$COMPUTER_ID" != "NIEZNANY" ]; then
    curl -s "https://raw.githubusercontent.com/mx-ecosystem/core-update/main/configs/${COMPUTER_ID}.sh" | bash
fi
