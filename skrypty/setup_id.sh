#!/bin/bash

# ==========================================================
# Zorin-X: Skrypt Pierwszego Uruchomienia (Setup ID & Resize)
# ==========================================================

echo "Uruchamianie procedury konfiguracji wstepnej..."

# 1. Rozszerzanie partycji (zabezpieczenie miejsca na dysku)
# ----------------------------------------------------------
ROOT_PART=$(findmnt -n -o SOURCE /)
DISK=$(echo "$ROOT_PART" | sed 's/[0-9]*$//' | sed 's/p$//')
PART_NUM=$(echo "$ROOT_PART" | grep -o '[0-9]*$')

echo "Rozszerzanie partycji $PART_NUM na dysku $DISK..."
sudo growpart "$DISK" "$PART_NUM"
sudo resize2fs "$ROOT_PART"

# 2. Konfiguracja tozsamosci (ID Komputera)
# ----------------------------------------------------------
echo "----------------------------------------------------"
echo "KONFIGURACJA TOZSAMOSCI KOMPUTERA"
echo "----------------------------------------------------"
# Wyswietlamy prosbe o ID (np. GDY-NGO-01)
read -p "Podaj unikalne ID dla tego stanowiska: " USER_ID

if [ -n "$USER_ID" ]; then
    # Zmiana nazwy komputera (hostname)
    echo "$USER_ID" | sudo tee /etc/hostname
    
    # Aktualizacja pliku hosts (zapobiega bledom sudo przy zmianie nazwy)
    sudo sed -i "s/127.0.1.1.*/127.0.1.1\t$USER_ID/g" /etc/hosts
    
    # Zapisanie ID do pliku w Magazynie dla potrzeb synchronizacji z GitHub
    mkdir -p /home/uzytkownik/.magazyn
    echo "COMPUTER_ID=$USER_ID" > /home/uzytkownik/.magazyn/machine_info.conf
    
    echo "Sukces: ID ustawione na: $USER_ID"
else
    echo "OSTRZEZENIE: Nie podano ID. Pozostawiono domyslna nazwe."
fi

# 3. Finalizacja i sprzatanie
# ----------------------------------------------------------
echo "Finalizowanie ustawien..."

# Wylaczamy usluge, aby skrypt nie uruchamial sie ponownie przy nastepnym starcie
sudo systemctl disable expand-root.service

echo "Konfiguracja zakonczona. Zalecany restart komputera."
