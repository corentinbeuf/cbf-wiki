---
layout: software
title: DashLit
parent: Docker container
nav_order: 1

presentation: |
  A fast, modern, self-hosted home for links, tools, and service status

prerequis: |
  Install Docker on your virtual machine.

installation: |
  Update sources.
  ```bash
  sudo apt-get update
  ```
  Create a folder named `dashlit` into the directory `docker`.
  ```bash
  sudo mkdir /docker/dashlit
  ```
  Go to the folder created.
  ```bash
  cd /docker/dashlit
  ```
  Create a file with name `docker-compose.yml`.
  ```bash
  sudo nano docker-compose.yml
  ```
  Add this content into the file. Change the content of the `ORIGIN` and `PASSWORD` vars.
  ```yml
  services:
  app:
    container_name: dashlit
    image: ghcr.io/codewec/dashlit:latest
    restart: unless-stopped
    environment:
      ORIGIN: 'http://192.168.1.1:3024'
      PASSWORD: 'password'
    ports:
      - '3024:3000'
    volumes:
      - ./data:/app/data
  ```
  Start the container.
  ```bash
  sudo docker compose up -d
  ```
  Open a web browser and go the following URI : `http://IP:3024`

configuration: |
  Se connecter sur la page web avec le mot de passe renseigner dans le fichier "**docker-compose.yml**".
  Cliquer sur "**Add group**" puis renseigner un titre et une description. Cliquer sur le bouton "**Save**".
  Cliquer sur "**Add item**" puis renseigner les champs suivants :
    - Titre
    - Description
    - L'URL d'accès et comment l'ouvrir
    - Si l'URL doit être afficher ou non
    - L'icône de l'application
  Cliquer sur "**Save**".
  Log in to the web page with the password entered in the `docker-compose.yml` file.
  Click on `Add group` then enter a title and description. Click on the `Save` button.
  Click on `Add item`then fill in the following fields: Title, Description, The access URL and how to open it, Whether the URL should be displayed or not, The app icon
  Click on `Save`.

  Steps to repeat for each application and/or group to create/add!

sauvegarde: |
  Backup the `/docker/dashlit` folder.
  ```bash
  sudo rsync -aqz /docker/dashlit/ user@192.168.1.2:/docker/dashlit/
  ```

restauration: |
  Stop the container on the Docker server.
  ```bash
  sudo docker stop dashlit
  ```
  Copy the data from the backup server
  ```bash
  sudo scp -rp user@192.168.1.2:/docker/dashlit/ /docker/dashlit/
  ```
  Restart the containers.
  ```bash
  sudo docker restart dashlit
  ```

mise_a_jour: |
  Remove the container.
  ```bash
  sudo docker rm -f dashlit
  ```
  Remove the `ghcr.io/codewec/dashlit:latest` image.
  ```bash
  sudo docker image rm -f ghcr.io/codewec/dashlit:latest
  ```
  Restart the container.
  ```bash
  cd /docker/dashlit && sudo docker compose up -d
  ```
---