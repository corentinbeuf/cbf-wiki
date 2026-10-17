---
layout: software
title: Homer
parent: Docker container
nav_order: 1

presentation: |
  A very simple static homepage for your server.

prerequis: |
  Install Docker on your virtual machine.

installation: |
  Create a folder named `homer` into the directory `docker`.
  ```bash
  sudo mkdir /docker/homer
  ```
  Go to the folder created.
  ```bash
  cd /docker/homer
  ```
  Create a file with name `docker-compose.yml`.
  ```bash
  sudo nano docker-compose.yml
  ```
  Add this content into the file.
  ```yml
  services:
    homer:
        image: b4bz/homer
        container_name: homer
        volumes:
            - ./assets/:/www/assets
        ports:
            - 8080:8080
        user: 1000:1000 # default
        environment:
            - INIT_ASSETS=1 # default
  ```
  Start the container.
  ```bash
  sudo docker compose up -d
  ```
  When the container is created, we can see in its logs that the "assets" folder lacks permissions.
  Grant all rights to the "assets" folder.
  ```bash
  sudo chmod -R 777 assets/
  ```
  Restart the container.
  ```bash
  sudo docker compose restart
  ```
  Open a web browser and go the following URI : `http://IP:8080`

configuration: |
  Edit the "config.yml" file.
  ```bash
  sudo nano /docker/homer/assets/config.yml
  ```
  Change the content of the file to modify the webpage.
  Restart the container to apply the modification.
  ```bash
  sudo docker compose restart
  ```

sauvegarde: |
  Backup the `/docker/homer` folder.
  ```bash
  sudo rsync -aqz /docker/homer/ user@192.168.1.2:/docker/homer/
  ```

restauration: |
  Stop the container on the Docker server.
  ```bash
  sudo docker stop homer
  ```
  Copy the data from the backup server
  ```bash
  sudo scp -rp user@192.168.1.2:/docker/homer/ /docker/homer/
  ```
  Restart the containers.
  ```bash
  sudo docker restart homer
  ```

mise_a_jour: |
  Remove the container.
    ```bash
    sudo docker rm -f homer
    ```
  Remove the "**b4bz/homer**" image.
    ```bash
    sudo docker image rm -f b4bz/homer
    ```
  Restart the container.
    ```bash
    cd /docker/homer && sudo docker compose up -d
    ```
---