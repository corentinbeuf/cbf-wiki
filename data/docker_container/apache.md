---
layout: software
title: Apache (httpd)
parent: Docker container
nav_order: 1

presentation: |
  Apache is a Web server application notable for playing a key role in the initial growth of the World Wide Web.

prerequis: |
  Install Docker on your virtual machine.

installation: |
  Update sources.
  ```bash
  sudo apt-get update
  ```
  Create a folder named `apache` into the directory `docker`.
  ```bash
  sudo mkdir /docker/apache
  ```
  Go to the folder created.
  ```bash
  cd /docker/apache
  ```
  Create a file with name `docker-compose.yml`.
  ```bash
  sudo nano docker-compose.yml
  ```
  Add this content into the file. Change the content of the `ENV_DOCKER_REGISTRY_HOST` var.
  ```yml
  services:
    apache:
      image: httpd:latest
      container_name: my-apache-app
      ports:
        - '8080:80'
      volumes:
        - ./website:/usr/local/apache2/htdocs
  ```
  Start the container.
  ```bash
  sudo docker compose up -d
  ```
  Open a web browser and go the following URI : `http://IP:8080`

configuration: |
  Create or copy your files in the `website` folder created when starting the container. The container automatically loads the added content into the folder.

sauvegarde: |
  Backup the `/docker/apache` folder.
  ```bash
  sudo rsync -aqz /docker/apache/ user@192.168.1.2:/docker/apache/
  ```

restauration: |
  Stop the container on the Docker server.
  ```bash
  sudo docker stop my-apache-app
  ```
  Copy the data from the backup server
  ```bash
  sudo scp -rp user@192.168.1.2:/docker/apache/ /docker/apache/
  ```
  Restart the containers.
  ```bash
  sudo docker restart my-apache-app
  ```

mise_a_jour: |
  Remove the container.
  ```bash
  sudo docker rm -f my-apache-app
  ```
  Remove the `httpd` image.
  ```bash
  sudo docker image rm -f httpd
  ```
  Pull th new version of the `httpd` image.
  ```bash
  sudo docker pull httpd:latest
  ```
  Restart the container.
  ```bash
  cd /docker/apache && sudo docker compose up -d
  ```
---