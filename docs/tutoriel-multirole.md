# Tutoriel : Installer un serveur EDOPro (Multirole) avec des cartes custom

Ce tutoriel récapitule toutes les étapes pour monter un serveur de duel EDOPro chez soi avec Docker, et y ajouter un pack de cartes custom (ici : VAACT).

---

## 1. Prérequis

- **Docker Desktop** installé et lancé sur ton PC.
- **EDOPro (Project Ignis)** installé pour pouvoir jouer.

---

## 2. Télécharger l'image du serveur

Ouvre un terminal (tape `cmd` dans la recherche Windows) et lance :

```
docker pull dyxel/multirole:latest
```

Ça télécharge l'image officielle du serveur Multirole (très légère, quelques Mo).

---

## 3. Lancer le serveur

Toujours dans le terminal :

```
docker run -d --name multirole -p 7922:7922 -p 7911:7911 -p 34343:34343 -p 62672:62672 -p 49382:49382 -p 43632:43632 dyxel/multirole:latest
```

- `7922` = port de la liste des salons (lobby)
- `7911` = port d'hébergement des salons
- Les 4 autres ports servent aux mises à jour automatiques (scripts, cartes, banlists, core)

---

## 4. Vérifier que ça tourne

Dans **Docker Desktop** :

1. Va dans **Containers**
2. Clique sur **multirole**
3. Onglet **Logs**

Tu dois voir des lignes du type `Loading up sync/databases/...` et `Initialization finished successfully!`, sans erreur.

---

## 5. Se connecter avec EDOPro

Dans EDOPro, ajoute un serveur personnalisé avec :

- **Adresse** : `127.0.0.1`
- **Port** : `7922`

Tu peux alors créer un salon de duel.

---

## 6. Ajouter des cartes custom (exemple : VAACT)

Le serveur récupère les cartes depuis des **dépôts GitHub**. Pour ajouter un pack de cartes custom, il faut modifier le fichier de configuration du serveur.

### 6.1 Ouvrir le fichier de config

Dans Docker Desktop :

1. **Containers** → clique sur **multirole**
2. Onglet **Files**
3. Ouvre le dossier **multirole**
4. Clique sur **config.json**, puis **"Open file editor"**

### 6.2 Remplacer le contenu

Sélectionne tout (Ctrl+A), supprime, et colle ce bloc à la place (adapté pour inclure le pack VAACT) :

```json
{
	"concurrencyHint": -1,
	"lobbyListingPort": 7922,
	"lobbyMaxConnections": 4,
	"roomHostingPort": 7911,
	"repos": [
		{
			"name": "scripts",
			"remote": "https://github.com/ProjectIgnis/CardScripts",
			"path": "./sync/scripts/",
			"webhookPort": 34343,
			"webhookToken": "<change_this>"
		},
		{
			"name": "databases",
			"remote": "https://github.com/ProjectIgnis/BabelCDB",
			"path": "./sync/databases/",
			"webhookPort": 62672,
			"webhookToken": "<change_this>"
		},
		{
			"name": "banlists",
			"remote": "https://github.com/ProjectIgnis/LFLists",
			"path": "./sync/banlists/",
			"webhookPort": 49382,
			"webhookToken": "<change_this>"
		},
		{
			"name": "bin",
			"remote": "https://github.com/ProjectIgnis/bin",
			"path": "./sync/bin/",
			"webhookPort": 43632,
			"webhookToken": "<change_this>"
		},
		{
			"name": "vaact",
			"remote": "https://github.com/kevinraphael95/VAACT-Very-Accurate-Anime-Character-Tournament-",
			"path": "./sync/vaact/",
			"webhookPort": 39001,
			"webhookToken": "changeme123"
		}
	],
	"banlistProvider": {
		"observedRepos": [
			"banlists"
		],
		"fileRegex": ".*\\.lflist\\.conf"
	},
	"coreProvider": {
		"observedRepos": [
			"bin"
		],
		"fileRegex": ".*libocgcore\\.so",
		"tmpPath": "./tmp/",
		"coreType": "hornet",
		"loadPerRoom": true
	},
	"dataProvider": {
		"observedRepos": [
			"databases",
			"vaact"
		],
		"fileRegex": ".*\\.cdb"
	},
	"logHandler": {
		"serviceSinks": {
			"gitRepo": { "type": "stdout", "properties": {} },
			"multirole": { "type": "stdout", "properties": {} },
			"banlistProvider": { "type": "stdout", "properties": {} },
			"coreProvider": { "type": "stdout", "properties": {} },
			"dataProvider": { "type": "stdout", "properties": {} },
			"logHandler": { "type": "stdout", "properties": {} },
			"replayManager": { "type": "stdout", "properties": {} },
			"scriptProvider": { "type": "stdout", "properties": {} },
			"other": { "type": "stdout", "properties": {} }
		},
		"ecSinks": {
			"core": { "type": "stderr", "properties": {} },
			"official": { "type": "stderr", "properties": {} },
			"speed": { "type": "stderr", "properties": {} },
			"rush": { "type": "stderr", "properties": {} },
			"other": { "type": "stderr", "properties": {} }
		},
		"roomLogging": {
			"enabled": false,
			"path": "./room-logs/"
		}
	},
	"replayManager": {
		"save": true,
		"path": "./replays/"
	},
	"scriptProvider": {
		"observedRepos": [
			"scripts",
			"vaact"
		],
		"fileRegex": ".*\\.lua"
	}
}
```

Clique sur **Save**.

### 6.3 Redémarrer le serveur

Dans Docker Desktop, sur la ligne du conteneur **multirole** :

1. Clique sur **stop** (bouton carré)
2. Attends 2 secondes
3. Clique sur **start** (bouton triangle ▶️)

### 6.4 Vérifier que les cartes sont chargées

Retourne dans l'onglet **Logs**. Tu dois voir des lignes comme :

```
Loading up sync/vaact/VAACT S1.cdb...
Loading 1369 files...
Loaded 102 files.
```

Si tu vois ça, les cartes custom sont bien chargées sur le serveur ✅

---

## 7. Ajouter un autre pack de cartes plus tard

Pour ajouter un autre pack, répète l'étape 6 en :

1. Ajoutant un nouveau bloc dans `"repos"` avec un **nom unique**, l'**URL du dépôt GitHub**, et un **port webhook unique** (jamais utilisé par un autre repo)
2. Ajoutant ce nom dans `"observedRepos"` de `scriptProvider` (s'il y a des scripts `.lua`) et/ou `dataProvider` (s'il y a un fichier `.cdb`)
3. Sauvegardant et redémarrant le conteneur

---

## Commandes utiles à retenir

| Action | Commande / Endroit |
|---|---|
| Voir les logs | Docker Desktop → Containers → multirole → Logs |
| Éditer la config | Docker Desktop → Containers → multirole → Files → config.json |
| Redémarrer le serveur | Docker Desktop → bouton stop puis start sur la ligne multirole |
| Adresse de connexion EDOPro | `127.0.0.1` port `7922` |
