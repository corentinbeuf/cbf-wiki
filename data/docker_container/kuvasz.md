---
layout: software
title: Kuvasz
parent: Docker container
nav_order: 1

presentation: |
  Kuvasz (pronounce as [ˈkuvɒs]) is an open-source uptime and SSL monitoring service, with multiple notification channels, status pages, IAC support via YAML, Prometheus integration, a complete REST API and many more!

prerequis: |
  Install Docker on your virtual machine.

installation: |
  Create a folder named `kuvasz` into the directory `docker`.
  ```bash
  sudo mkdir /docker/kuvasz
  ```
  Go to the folder created.
  ```bash
  cd /docker/kuvasz
  ```
  Create a file with name `docker-compose.yml`.
  ```bash
  sudo nano docker-compose.yml
  ```
  Add this content into the file. Change the content of the `POSTGRES_PASSWORD`, `DATABASE_PASSWORD`, `ADMIN_USER`, `ADMIN_PASSWORD` and `ADMIN_API_KEY` vars.
  ```yml
  sservices:
    kuvasz-db:
        image: postgres:17-alpine
        container_name: kuvaszdb
        environment:
            POSTGRES_USER: postgres
            POSTGRES_PASSWORD: postgres 
            TZ: 'Europe/Paris' 
        ports:
            - "5432:5432"
        volumes:
            - ./pgdata:/var/lib/postgresql/data 
        
    kuvasz:
        image: kuvaszmonitoring/kuvasz:latest
        container_name: kuvasz
        mem_limit: 384M # optional 
        ports:
            - "4080:8080"
        environment:
            TZ: 'Europe/Paris' 
            DATABASE_HOST: kuvaszdb 
            DATABASE_USER: postgres 
            DATABASE_PASSWORD: postgres 
            ADMIN_USER: YourSuperSecretUsername
            ADMIN_PASSWORD: YourSuperSecretPassword
            ADMIN_API_KEY: ThisShouldBeVeryVerySecureToo
        volumes:
            - ./kuvasz.yml:/config/kuvasz.yml 
        depends_on:
            - kuvasz-db
  ```
  Create a file with name `kuvasz.yml`.
  ```bash
  sudo nano kuvasz.yml
  ```
  Add this content into the file. Change the content of the `smtp-config.host`, `smtp-config.username`, `smtp-config.password`, `from-address` and `to-address` vars.
  ```yml
  smtp-config.host: 'smtp.example.com'
  smtp-config.port: 587
  smtp-config.username: admin@example.com
  smtp-config.password: password
  smtp-config.transport-strategy: SMTP_TLS

  integrations:
    email:
      - name: email_implicitly_enabled
        from-address: admin@example.com
        to-address: it@example.com
  ```
  Start the container.
  ```bash
  sudo docker compose up -d
  ```
  Open a web browser and go the following URI : `http://IP:4080`

configuration: |
  Log in with the credentials entered in the file "docker-compose.yml" then click on "Sign In".
  Click on "New monitor".
  Fill in the following fields: `Name`, `URL`, enable `SSL certificate check` and set the validity period of the certificate and check the email notifications.
  Click on "Save".

sauvegarde: |
  Backup the `/docker/kuvasz` folder.
  ```bash
  sudo rsync -aqz /docker/kuvasz/ user@192.168.1.2:/docker/kuvasz/
  ```

restauration: |
  Stop the containers on the Docker server.
  ```bash
  sudo docker stop kuvasz kuvaszdb
  ```
  Copy the data from the backup server
  ```bash
  sudo scp -rp user@192.168.1.2:/docker/kuvasz/ /docker/kuvasz/
  ```
  Restart the containers.
  ```bash
  sudo docker restart kuvasz kuvaszdb
  ```

mise_a_jour: |
  Remove the container.
    ```bash
    sudo docker rm -f kuvasz kuvaszdb
    ```
  Remove the "**jkuvaszmonitoring/kuvasz:latest**" image.
    ```bash
    sudo docker image rm -f jkuvaszmonitoring/kuvasz:latest
    ```
  Restart the container.
    ```bash
    cd /docker/kuvasz && sudo docker compose up -d
    ```
---