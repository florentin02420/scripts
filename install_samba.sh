#!/bin/bash

# Ce script automatise l'installation de Samba, la création d'un dossier partagé,
# l'attribution des droits à ce dossier, et la création d'un utilisateur pour l'accès Samba.

# --- 1. Mise à jour du système et installation de Samba ---
echo "Mise à jour des paquets..."
sudo apt update && sudo apt upgrade -y

echo "Installation de Samba..."
sudo apt install samba samba-common samba-common-bin samba-client -y

# --- 2. Création du dossier partagé ---
# On crée un dossier partagé (par exemple /srv/samba/partage)
PARTAGE="/srv/samba/partage"
echo "Création du dossier partagé $PARTAGE..."
sudo mkdir -p $PARTAGE

# --- 3. Attribution des droits au dossier partagé ---
# On donne les permissions complètes au dossier partagé (chmod 777)
echo "Attribution des droits 777 au dossier..."
sudo chmod 777 $PARTAGE

# --- 4. Configuration de Samba pour le partage ---
# Ajout d'une section de partage dans le fichier de configuration de Samba (/etc/samba/smb.conf)
echo "Configuration de Samba pour partager le dossier..."
echo -e "\n[partage]\n  path = $PARTAGE\n  browseable = yes\n  writable = yes\n  guest ok = yes\n" | sudo tee -a /etc/samba/smb.conf

# --- 5. Création de l'utilisateur Samba ---
# Demander le nom de l'utilisateur
read -p "Entrez le nom de l'utilisateur Samba à créer: " NOM_UTILISATEUR

# Création de l'utilisateur avec un mot de passe
echo "Création de l'utilisateur $NOM_UTILISATEUR..."
sudo useradd $NOM_UTILISATEUR
sudo smbpasswd -a $NOM_UTILISATEUR

# --- 6. Redémarrer le service Samba ---
echo "Redémarrage du service Samba..."
sudo systemctl restart smbd

# --- 7. Vérification du partage ---
echo "Vérification des partages Samba..."
sudo smbclient -L localhost -U $NOM_UTILISATEUR

echo "L'installation et la configuration de Samba sont terminées !"
