---
layout: software
title: Home Assistant
parent: Docker container
nav_order: 1

presentation: |
  Open source home automation that puts local control and privacy first.

prerequis: |
  Install Docker on your virtual machine.

installation: |
  Create a folder named `homeassistant` into the directory `docker`.
  ```bash
  sudo mkdir /docker/homeassistant
  ```
  Go to the folder created.
  ```bash
  cd /docker/homeassistant
  ```
  Create a file with name `docker-compose.yml`.
  ```bash
  sudo nano docker-compose.yml
  ```
  Add this content into the file.
  ```yml
  services:
    homeassistant:
        container_name: homeassistant
        image: "ghcr.io/home-assistant/home-assistant:stable"
        volumes:
        - ./config:/config
        - /etc/localtime:/etc/localtime:ro
        - /run/dbus:/run/dbus:ro
        restart: unless-stopped
        privileged: true
        network_mode: host
  ```
  Start the container.
  ```bash
  sudo docker compose up -d
  ```
  Open a web browser and go the following URI : `http://IP:8123`

configuration: |
  Go to the webpage.
  Click on "Create my connected home".
  Create a user and then click on "Create an account".
  Enter the location of your house then click on "Next".
  Click on "Finish".

  Add equipments:

  - Click on the "Settings" button in the left menu.
  - Click on "Devices and services".
  - Click on the button "Add an integration".
  - Search for your equipment and click on it.
  - Provide the requested information to finalize the integration of the equipment.

  Creating rooms/floors:

  - Click on the "Settings" button in the left menu.
  - Click on "Parts, labels and zones".
  - Click on the button "Create a floor" or "Create a room".

sauvegarde: |
  Backup the `/docker/homeassistant` folder.
  ```bash
  sudo rsync -aqz /docker/homeassistant/ user@192.168.1.2:/docker/homeassistant/
  ```

restauration: |
  Stop the container on the Docker server.
  ```bash
  sudo docker stop homeassistant
  ```
  Copy the data from the backup server
  ```bash
  sudo scp -rp user@192.168.1.2:/docker/homeassistant/ /docker/homeassistant/
  ```
  Restart the containers.
  ```bash
  sudo docker restart homeassistant
  ```

mise_a_jour: |
  Remove the container.
    ```bash
    sudo docker rm -f homeassistant
    ```
  Remove the "**ghcr.io/home-assistant/home-assistant:stable**" image.
    ```bash
    sudo docker image rm -f ghcr.io/home-assistant/home-assistant:stable
    ```
  Restart the container.
    ```bash
    cd /docker/homeassistant && sudo docker compose up -d
    ```
---