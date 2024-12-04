#!/bin/bash

# Script pour installer Wine sur Linux Mint
# Par sécurité, exécutez avec : sudo bash script.sh

echo "Mise à jour des paquets système..."
sudo apt update && sudo apt upgrade -y

echo "Ajout de l'architecture 32 bits (nécessaire pour Wine)..."
sudo dpkg --add-architecture i386

echo "Ajout du dépôt WineHQ..."
sudo mkdir -pm755 /etc/apt/keyrings
wget -qO- https://dl.winehq.org/wine-builds/winehq.key | sudo tee /etc/apt/keyrings/winehq-archive.key > /dev/null
sudo wget -qO /etc/apt/sources.list.d/winehq.sources https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources

echo "Mise à jour des dépôts..."
sudo apt update

echo "Installation de Wine stable..."
sudo apt install --install-recommends winehq-stable -y

echo "Vérification de l'installation de Wine..."
wine --version
if [ $? -ne 0 ]; then
    echo "Erreur : Wine n'a pas été installé correctement. Vérifiez les étapes précédentes."
    exit 1
fi

echo "Configuration initiale de Wine..."
winecfg

echo "Installation de Wine terminée. Vous pouvez maintenant utiliser Wine."
