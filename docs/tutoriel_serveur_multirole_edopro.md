# Tutoriel : Créer son serveur privé EDOPro en local avec Mot de Passe

Ce guide rapide explique comment héberger ton propre serveur EDOPro sur ton PC Windows avec **Docker**, intégrer tes cartes personnalisées (`.cdb`, `script`, `pics`), et sécuriser l'accès avec un **mot de passe**.

---

## 📋 Prérequis
* [Docker Desktop pour Windows](https://www.docker.com/products/docker-desktop/) installé et lancé.
* Vos fichiers personnalisés (base `.cdb`, scripts `.lua`, images des cartes).

---

## 🛠️ Étape 1 : Préparation du serveur

1. Télécharge et extrais le projet [Multirole (ZIP)](https://github.com/DyXel/Multirole).
2. Ouvre le dossier extrait.
3. Copie/colle ton fichier `.cdb`, ainsi que tes dossiers `script` et `pics`, à l'intérieur du dossier **`expansions/`**.

---

## 🔐 Étape 2 : Configuration du mot de passe

Crée ou modifie le fichier **`config.json`** situé à la racine du dossier `Multirole` avec le contenu suivant :

```json
{
  "server_name": "Mon Serveur EDOPro Custom",
  "port": 7911,
  "room_passwords_enabled": true,
  "require_server_password": true,
  "server_password": "TON_MOT_DE_PASSE_ICI"
}
```

> ⚠️ Remplace `"TON_MOT_DE_PASSE_ICI"` par le mot de passe de ton choix.

---

## 🚀 Étape 3 : Lancement du serveur

1. Lance **Docker Desktop** sur ton PC.
2. Ouvre une invite de commandes (`cmd`) dans le dossier `Multirole`.
3. Exécute la commande suivante :

```cmd
docker-compose up -d --build
```

Le serveur tourne maintenant en arrière-plan sur ton PC !

---

## 🎮 Étape 4 : Connexion dans EDOPro

Dans le menu **Multijoueur** > **Ajouter un serveur custom** :

| Joueur | Adresse IP / Hôte | Port | Mot de passe |
| :--- | :--- | :--- | :--- |
| **Toi (Hôte)** | `127.0.0.1` | `7911` | `TON_MOT_DE_PASSE_ICI` |
| **Ton pote** | *Ton IP publique* (ou lien *Playit.gg*) | `7911` | `TON_MOT_DE_PASSE_ICI` |

---

### 💡 Pour arrêter le serveur :
Dans le même terminal, tape :
```cmd
docker-compose down
```





***


Ouvre un terminal et tape juste ça, une ligne à la fois :

1. Télécharge l'image :

docker pull dyxel/multirole:latest

2. Une fois terminé, lance le serveur :

docker run -d --name multirole -p 7922:7922 -p 7911:7911 -p 34343:34343 -p 62672:62672 -p 49382:49382 -p 43632:43632 dyxel/multirole:latest

3. Vérifie que ça tourne bien :

docker logs -f multirole

Colle-moi ce qui s'affiche si tu vois une erreur, sinon connecte-toi dans EDOPro sur 127.0.0.1 port 7922.
