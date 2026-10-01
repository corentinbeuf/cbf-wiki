---
layout: software
title: Heimdall
parent: Docker container
nav_order: 1

presentation: |
  An Application dashboard and launcher

prerequis: |
  Install Docker on your virtual machine.

installation: |
  Create a folder named `heimdall` into the directory `docker`.
  ```bash
  sudo mkdir /docker/heimdall
  ```
  Go to the folder created.
  ```bash
  cd /docker/heimdall
  ```
  Create a file with name `docker-compose.yml`.
  ```bash
  sudo nano docker-compose.yml
  ```
  Add this content into the file.
  ```yml
  services:
    heimdall:
        image: lscr.io/linuxserver/heimdall:latest
        container_name: heimdall
        environment:
        - PUID=1000
        - PGID=1000
        - TZ=Europe/Paris
        volumes:
        - ./config:/config
        ports:
        - 80:80
        - 443:443
        restart: unless-stopped
  ```
  Start the container.
  ```bash
  sudo docker compose up -d
  ```
  Open a web browser and go the following URI : `http://IP`

sauvegarde: |
  Backup the `/docker/heimdall` folder.
  ```bash
  sudo rsync -aqz /docker/heimdall/ user@192.168.1.2:/docker/heimdall/
  ```

restauration: |
  Stop the container on the Docker server.
  ```bash
  sudo docker stop heimdall
  ```
  Copy the data from the backup server
  ```bash
  sudo scp -rp user@192.168.1.2:/docker/heimdall/ /docker/heimdall/
  ```
  Restart the containers.
  ```bash
  sudo docker restart heimdall
  ```

mise_a_jour: |
  Remove the container.
    ```bash
    sudo docker rm -f heimdall
    ```
  Remove the "**lscr.io/linuxserver/heimdall:latest**" image.
    ```bash
    sudo docker image rm -f lscr.io/linuxserver/heimdall:latest
    ```
  Restart the container.
    ```bash
    cd /docker/heimdall && sudo docker compose up -d
    ```
---