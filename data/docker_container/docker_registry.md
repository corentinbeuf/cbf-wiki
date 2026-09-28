---
layout: software
title: Docker Registry
parent: Docker container
nav_order: 1

presentation: |
  Docker Registry est un service de stockage et de distribution d'images Docker.

installation: |
  ```bash
  docker run -d -p 5000:5000 --name registry registry:2
  ```

configuration: |
  Le fichier de configuration se trouve dans `/etc/docker/registry/config.yml`.

sauvegarde: |
  Sauvegarder le volume `/var/lib/registry`.

restauration: |
  Restaurer le volume puis redémarrer le conteneur.

mise_a_jour: |
  ```bash
  docker pull registry:2
  docker compose up -d
  ```
---