checkBBOX
=========

Script de reboot de la bbox Bouygues Telecom. 

Ce script effectue un ping sur un serveur extérieur. En cas d'échec, le
script se connect sur l'interface d'administration de la bbox et demande
un redémarrage de la bbox.

## Configuration ##

1. Copier le fichier checkBBox.exemple dans ~/.config/checkBBox

2. Ajuster la configuration du fichier:
	
```
	# Identifiant du compte adminitrasteur, admin par défaut
	# LOGIN=admin

	# Mot de passe du compte administrateur
	PASSWORD=

	# Adresse ip ou hostname de la bbox à surveiller, 192.168.1.254 par défaut
	# IP_BBOX=192.168.1.254

	# HOST à pinger pour vérifier la connexion
	# HOST_TO_PING=www.google.fr
```

3. Programmer l'exécution du script en crontab

