#!/bin/bash

# 1. Wczytanie tożsamości komputera
if [ -f /home/uzytkownik/.magazyn/machine_info.conf ]; then
    source /home/uzytkownik/.magazyn/machine_info.conf
else
    COMPUTER_ID=$(hostname)
fi

# 2. Zbieranie danych diagnostycznych
DATE=$(date '+%Y-%m-%d %H:%M:%S')
DISK_USAGE=$(df -h / | grep / | awk '{ print $5 }' | sed 's/%//')
RAM_FREE=$(free -m | grep Mem | awk '{ print $7 }')
TEMP=$(sensors 2>/dev/null | grep -E 'Core 0|temp1' | awk '{print $2}' | sed 's/+//' || echo "N/A")

# 3. Budowanie raportu w dedykowanym folderze
mkdir -p /home/uzytkownik/.magazyn/raporty
REPORT_FILE="/home/uzytkownik/.magazyn/raporty/${COMPUTER_ID}.txt"

echo "Raport Systemowy: $COMPUTER_ID" > "$REPORT_FILE"
echo "Ostatnia aktualizacja: $DATE" >> "$REPORT_FILE"
echo "---------------------------" >> "$REPORT_FILE"
echo "Zajętość dysku: $DISK_USAGE%" >> "$REPORT_FILE"
echo "Wolny RAM: ${RAM_FREE}MB" >> "$REPORT_FILE"
echo "Temperatura CPU: $TEMP" >> "$REPORT_FILE"
echo "---------------------------" >> "$REPORT_FILE"
echo "Logi aktualizacji (5 linii):" >> "$REPORT_FILE"
tail -n 5 /var/log/unattended-upgrades/unattended-upgrades.log 2>/dev/null >> "$REPORT_FILE" || echo "Brak logów" >> "$REPORT_FILE"

# 4. Automatyczna wysyłka na GitHub
cd /home/uzytkownik/.magazyn
git add raporty/${COMPUTER_ID}.txt
git commit -m "Automatyczny raport statusu: $COMPUTER_ID ($DATE)"
git push
