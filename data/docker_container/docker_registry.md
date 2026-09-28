---
layout: software
title: Docker Registry
parent: Docker container
nav_order: 1

presentation: |
  Docker Regsitry  is a service for storing and distributing Docker images.

prerequis: |
  Install Docker on your virtual machine.

installation: |
  Update sources.
  ```bash
  sudo apt-get update
  ```
  Install the `apache2-utils` package
  ```bash
  sudo apt-get install apache2-utils -y
  ```
  Create a folder naming `registry` into the directory `docker`.
  ```bash
  sudo mkdir /docker/registry
  ```
  Go to the folder created.
  ```bash
  cd /docker/registry
  ```
  Create a file with name `docker-compose.yml`.
  ```bash
  sudo nano docker-compose.yml
  ```
  Add this content into the file. Change the content of the `ENV_DOCKER_REGISTRY_HOST` var.
  ```yml
  services:
    registry:
      image: registry:3.1.2
      container_name: registry
      ports:
        - 5000:5000
      environment:
        REGISTRY_AUTH: htpasswd
        REGISTRY_AUTH_HTPASSWD_REALM: Registry Realm
        REGISTRY_AUTH_HTPASSWD_PATH: /auth/registry.password
      volumes:
        - ./registry-data:/var/lib/registry
        - ./auth:/auth
      networks:
        - docker-registry
      restart: always
    registry-ui:
      image: konradkleine/docker-registry-frontend:v2
      container_name: registry-ui
      environment:
        ENV_DOCKER_REGISTRY_HOST: 192.168.1.1
        ENV_DOCKER_REGISTRY_PORT: 5000
      ports:
        - 8080:80
      networks:
        - docker-registry
      restart: always
  networks:
    docker-registry:
  ```
  Create a folder naming `auth`
  ```bash
  sudo mkdir auth
  ```
  Go to the folder `auth`.
  ```bash
  cd auth/
  ```
  Create an user.
  ```bash
  sudo htpasswd -Bc registry.password nom_utilisateur
  ```
  Start the container.
  ```bash
  cd .. && sudo docker compose up -d
  ```
  Open a web browser and go the following uri : `http://IP:8080`

configuration: |
  Connect to the registry:

  - Connect to the server over SSH.
  - Create the file `/etc/docker/daemon.json`.

```bash
    sudo nano /etc/docker/daemon.json
```

  - Add the following content to the file.

```json
    { "insecure-registries": ["192.168.1.1:5000"] }
```

  - Restart the `docker` service.

```bash
    sudo systemctl restart docker
```

  - Connect to the registry.

```bash
    sudo docker login 192.168.1.1:5000
```

  To create and push a Docker image:

  - Download a base image.

```bash
    sudo docker pull alpine
```

  - Add a tag to your image.

```bash
    sudo docker tag alpine 192.168.1.1:5000/my-alpine
```

  - Push the image to the registry.

```bash
    sudo docker push 192.168.1.1:5000/my-alpine
```

  To pull an image:

  - Download the image.

```bash
    sudo docker pull 192.168.1.1:5000/my-alpine
```

sauvegarde: |
  Backup the `/docker/registry` folder.
  ```bash
  sudo rsync -aqz /docker/registry user@192.168.1.2:/docker/registry/container/
  ```
  Backup the `/etc/docker` folder.
  ```bash
  sudo rsync -aqz /etc/docker/ user@192.168.1.2:/docker/registry/config/
  ```

restauration: |
  Stop the registry container on the Docker server.
  ```bash
  sudo docker stop registry registry-ui
  ```
  Copy the data from the bacup server
  ```bash
  sudo scp -rp user@192.168.1.2:/docker/registry/container /docker/registry/
  ```
  Restart the containers.
  ```bash
  sudo docker restart registry registry-ui
  ```

mise_a_jour: |
  Remove the container.
  ```bash
  sudo docker rm -f registry registry-ui
  ```
  Remove the registry images.
  ```bash
  sudo docker image rm -f registry:3.1.2 konradkleine/docker-registry-frontend:v2
  ```
  Edit the `docker-compose.yml` file.
  ```bash
  sudo nano /docker/registry/docker-compose.yml
  ```
  Change the images tag.
  Restart the containers.
  ```bash
  cd /docker/registry && sudo docker compose up -d
  ```
---