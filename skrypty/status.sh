#!/bin/bash

# Dane identyfikacyjne
HOST=$(hostname)
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# 1. Sprawdzenie dysku (jeśli > 85%, to alarm)
DISK_USAGE=$(df -h / | grep / | awk '{ print $5 }' | sed 's/%//')

# 2. Sprawdzenie RAM
RAM_FREE=$(free -m | grep Mem | awk '{ print $7 }')

# 3. Sprawdzenie temperatury (jeśli dostępna)
TEMP=$(sensors 2>/dev/null | grep -E 'Core 0|temp1' | awk '{print $2}' | sed 's/+//' || echo "N/A")

# Budowanie raportu
REPORT="Raport Systemowy: $HOST
Data: $DATE
---------------------------
Zajętość dysku: $DISK_USAGE%
Wolny RAM: ${RAM_FREE}MB
Temperatura CPU: $TEMP
---------------------------
Logi unattended-upgrades (ostatnie 5 linii):
$(tail -n 5 /var/log/unattended-upgrades/unattended-upgrades.log 2>/dev/null || echo "Brak logów")"

# Wysyłka na maila (wymaga zainstalowanego 'mailutils' lub podobnego)
echo "$REPORT" | mail -s "Status MX Eco-System: $HOST" biuro.mxecosystem@gmail.com
