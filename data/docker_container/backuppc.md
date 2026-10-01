---
layout: software
title: BackupPC
parent: Docker container
nav_order: 1

presentation: |
  BackupPC is a free self-hosted backup software able to backup remote hosts through various ways like rsync, smb or tar. It supports full and incremental backups, and reconstruct automatically a usable verbatim from any backup version. Started with version 4, BackupPC uses a new way to store backups by a reverse delta approach and no hardlinks.

prerequis: |
  Install Docker on your virtual machine.

installation: |
  Update sources.
  ```bash
  sudo apt-get update
  ```
  Create a folder named `backuppc` into the directory `docker`.
  ```bash
  sudo mkdir /docker/backuppc
  ```
  Go to the folder created.
  ```bash
  cd /docker/backuppc
  ```
  Create a file with name `docker-compose.yml`.
  ```bash
  sudo nano docker-compose.yml
  ```
  Add this content into the file. Change the content of the `BACKUPPC_WEB_PASSWD` var.
  ```yml
  services:
    backuppc:
        image: adferrand/backuppc
        container_name: backuppc
        ports:
            - 80:8080
        volumes:
            - ./backuppc/etc:/etc/backuppc
            - ./backuppc/home:/home/backuppc
            - ./backuppc/data:/data/backuppc
        environment:
            - BACKUPPC_WEB_USER=backuppc
            - BACKUPPC_WEB_PASSWD=debian
  ```
  Start the container.
  ```bash
  sudo docker compose up -d
  ```
  Open a web browser and go the following URI : `http://IP`

configuration: |
  Open a web browser and go on the URI.
  Connect with the account and the password define in the `docker-compose.yml` file.
  Click on the `Edit Hosts` menu to add a new client server.
  Click on the `Edit Config` menu to replicate the same configuration across all client servers.

sauvegarde: |
  Backup the `/docker/backuppc` folder.
  ```bash
  sudo rsync -aqz /docker/backuppc/ user@192.168.1.2:/docker/backuppc/
  ```

restauration: |
  Stop the container on the Docker server.
  ```bash
  sudo docker stop backuppc
  ```
  Copy the data from the backup server
  ```bash
  sudo scp -rp user@192.168.1.2:/docker/backuppc/ /docker/backuppc/
  ```
  Restart the containers.
  ```bash
  sudo docker restart rbackuppc
  ```

mise_a_jour: |
  Remove the container.
  ```bash
  sudo docker rm -f backuppc
  ```
  Remove the "**adferrand/backuppc**" image.
  ```bash
  sudo docker image rm -f adferrand/backuppc
  ```
  Restart the container.
  ```bash
  sudo docker compose up -d
  ```
---