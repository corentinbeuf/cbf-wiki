---
layout: software
title: Nextcloud
parent: Docker container
nav_order: 1

presentation: |
  Nextcloud is a modular workspace platform designed to provide teams and businesses with a comprehensive environment for digital collaboration.

prerequis: |
  Install Docker on your virtual machine.

installation: |
  Create a folder named `nextcloud` into the directory `docker`.
  ```bash
  sudo mkdir /docker/nextcloud
  ```
  Go to the folder created.
  ```bash
  cd /docker/nextcloud
  ```
  Create a file with name `docker-compose.yml`.
  ```bash
  sudo nano docker-compose.yml
  ```
  Add this content into the file. Change the content of the `ENV_DOCKER_REGISTRY_HOST` var.
  ```yml
  services:
    nextcloud_db:
        image: mariadb:10.5
        container_name: nextcloud_db
        restart: always
        command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
        volumes:
            - /docker/nextcloud/db:/var/lib/mysql
        environment:
            - MYSQL_ROOT_PASSWORD=password
            - MYSQL_DATABASE=nextcloud
            - MYSQL_USER=nextcloud
            - MYSQL_PASSWORD=nextcloud

    nextcloud_redis:
        image: redis:latest
        container_name: nextcloud_redis
        restart: always

    nextcloud_app:
        image: nextcloud
        container_name: nextcloud_app
        restart: always
        ports:
            - 22080:80
        links:
            - nextcloud_db
            - nextcloud_redis
        volumes:
            - /docker/nextcloud/data:/var/www/html
        environment:
            - MYSQL_HOST=nextcloud_db
            - MYSQL_DATABASE=nextcloud
            - MYSQL_USER=nextcloud
            - MYSQL_PASSWORD=nextcloud

    nextcloud_cron:
        image: nextcloud
        container_name: nextcloud_cron
        restart: always
        links:
            - nextcloud_db
            - nextcloud_redis
        volumes:
            - /docker/nextcloud/data:/var/www/html
        environment:
            - MYSQL_HOST=nextcloud_db
            - MYSQL_DATABASE=nextcloud
            - MYSQL_USER=nextcloud
            - MYSQL_PASSWORD=nextcloud
        entrypoint: /cron.sh
  ```
  Start the container.
  ```bash
  sudo docker compose up -d
  ```
  Open a web browser and go the following URI : `http://IP:22080`

configuration: |
  Open a web browser and go on the URI.
  Create an account and click on `Install`
  Select the apps you want to install and click on `Install recommended apps`. Otherwise, click on "**Ignore**".

sauvegarde: |
  Backup the `/docker/nextcloud` folder.
  ```bash
  sudo rsync -aqz /docker/registry/ user@192.168.1.2:/docker/nextcloud/
  ```

restauration: |
  Stop the registry container on the Docker server.
  ```bash
  sudo docker stop nextcloud_db nextcloud_redis nextcloud_app nextcloud_cron
  ```
  Copy the data from the backup server
  ```bash
  sudo scp -rp user@192.168.1.2:/docker/registry/container/ /docker/nextcloud/
  ```
  Restart the containers.
  ```bash
  sudo docker restart nextcloud_db nextcloud_redis nextcloud_app nextcloud_cron
  ```

mise_a_jour: |
  Remove the containers.
  ```bash
  sudo docker rm -f nextcloud_app nextcloud_cron
  ```
  Remove the Nextcloud image.
  ```bash
  sudo docker image rm -f nextcloud
  ```
  Edit the `docker-compose.yml` file.
  ```bash
  sudo nano /docker/nextcloud/docker-compose.yml
  ```
  Change the images tag.
  Restart the containers.
  ```bash
  cd /docker/nextcloud && sudo docker compose up -d
  ```
---