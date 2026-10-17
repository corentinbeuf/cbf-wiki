---
layout: software
title: Homepage
parent: Docker container
nav_order: 1

presentation: |
  A highly customizable homepage (or startpage / application dashboard) with Docker and service API integrations.

prerequis: |
  Install Docker on your virtual machine.

installation: |
  Create a folder named `homepage` into the directory `docker`.
  ```bash
  sudo mkdir /docker/homepage
  ```
  Go to the folder created.
  ```bash
  cd /docker/homepage
  ```
  Create a file with name `docker-compose.yml`.
  ```bash
  sudo nano docker-compose.yml
  ```
  Add this content into the file. Change the content of the `HOMEPAGE_ALLOWED_HOSTS` var.
  ```yml
  services:
    homepage:
        image: ghcr.io/gethomepage/homepage:latest
        container_name: homepage
        environment:
            HOMEPAGE_ALLOWED_HOSTS: 192.168.1.1:3000
        ports:
            - 3000:3000
        volumes:
            - ./config:/app/config
            - /var/run/docker.sock:/var/run/docker.sock
  ```
  Start the container.
  ```bash
  sudo docker compose up -d
  ```
  Open a web browser and go the following URI : `http://IP:3000`

configuration: |
  To change the disposition of the webpage, chnage the content of the configuration files present in the `config` folder.

sauvegarde: |
  Backup the `/docker/homepage` folder.
  ```bash
  sudo rsync -aqz /docker/homepage/ user@192.168.1.2:/docker/homepage/
  ```

restauration: |
  Stop the container on the Docker server.
  ```bash
  sudo docker stop homepage
  ```
  Copy the data from the backup server
  ```bash
  sudo scp -rp user@192.168.1.2:/docker/homepage/ /docker/homepage/
  ```
  Restart the containers.
  ```bash
  sudo docker restart homepage
  ```

mise_a_jour: |
  Remove the container.
    ```bash
    sudo docker rm -f homepage
    ```
  Remove the "**ghcr.io/gethomepage/homepage:latest**" image.
    ```bash
    sudo docker image rm -f ghcr.io/gethomepage/homepage:latest
    ```
  Restart the container.
    ```bash
    cd /docker/homepage && sudo docker compose up -d
    ```
---