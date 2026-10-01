---
layout: software
title: Caddy
parent: Docker container
nav_order: 1

presentation: |
  Caddy is a powerful, enterprise-ready, open source web server with automatic HTTPS written in Go.

prerequis: |
  Install Docker on your virtual machine.

installation: |
  Update sources.
  ```bash
  sudo apt-get update
  ```
  Create a folder named `caddy` into the directory `docker`.
  ```bash
  sudo mkdir /docker/caddy
  ```
  Go to the folder created.
  ```bash
  cd /docker/caddy
  ```
  Create a file with name `docker-compose.yml`.
  ```bash
  sudo nano docker-compose.yml
  ```
  Add this content into the file.
  ```yml
  services:
    caddy:
        image: caddy:2.11.4
        restart: unless-stopped
        container_name: caddy
        ports:
        - "80:80"
        - "443:443"
        - "443:443/udp"
        volumes:
    #      - ./Caddyfile:/etc/caddy/Caddyfile
        - ./site:/srv
        - ./data:/data
        - ./config:/config
        - ./html:/usr/share/caddy
  ```
  Start the container.
  ```bash
  sudo docker compose up -d
  ```
  Open a web browser and go the following URI : `http://IP`

configuration: |
  Create or copy your files in the `html` folder created when starting the container. The container automatically loads the added content into the folder.

sauvegarde: |
  Backup the `/docker/caddy` folder.
  ```bash
  sudo rsync -aqz /docker/caddy/ user@192.168.1.2:/docker/caddy/
  ```

restauration: |
  Stop the container on the Docker server.
  ```bash
  sudo docker stop caddy
  ```
  Copy the data from the backup server
  ```bash
  sudo scp -rp user@192.168.1.2:/docker/caddy/ /docker/caddy/
  ```
  Restart the container.
  ```bash
  sudo docker restart caddy
  ```

mise_a_jour: |
  Supprimer le conteneur en cours d'exécution.
  ```bash
  sudo docker rm -f caddy
  ```
  Supprimer l'image "**caddy:2.11.4**" présente sur le serveur.
  ```bash
  sudo docker image rm -f caddy:2.11.4
  ```
  Edit the `docker-compose.yml` file.
  ```bash
  sudo nano /docker/caddy/docker-compose.yml
  ```
  Change the images tag.
  Restart the container.
  ```bash
  cd /docker/caddy && sudo docker compose up -d
  ```
---