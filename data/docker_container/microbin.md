---
layout: software
title: Microbin
parent: Docker container
nav_order: 1

presentation: |
  A secure, configurable file-sharing and URL shortening web app written in Rust.

prerequis: |
  Install Docker on your virtual machine.

installation: |
  Create a folder named `microbin` into the directory `docker`.
  ```bash
  sudo mkdir /docker/microbin
  ```
  Go to the folder created.
  ```bash
  cd /docker/microbin
  ```
  Create a file with name `docker-compose.yml`.
  ```bash
  sudo nano docker-compose.yml
  ```
  Add this content into the file.
  ```yml
  services:
    microbin:
        image: danielszabo99/microbin:latest
        container_name: microbin
        restart: always
        ports:
            - "${MICROBIN_PORT}:8080"
        volumes:
            - ./microbin-data:/app/microbin_data
        environment:
            MICROBIN_BASIC_AUTH_USERNAME: ${MICROBIN_BASIC_AUTH_USERNAME}
            MICROBIN_BASIC_AUTH_PASSWORD: ${MICROBIN_BASIC_AUTH_PASSWORD}
            MICROBIN_ADMIN_USERNAME: ${MICROBIN_ADMIN_USERNAME}
            MICROBIN_ADMIN_PASSWORD: ${MICROBIN_ADMIN_PASSWORD}
            MICROBIN_EDITABLE: ${MICROBIN_EDITABLE}
            MICROBIN_FOOTER_TEXT: ${MICROBIN_FOOTER_TEXT}
            MICROBIN_HIDE_FOOTER: ${MICROBIN_HIDE_FOOTER}
            MICROBIN_HIDE_HEADER: ${MICROBIN_HIDE_HEADER}
            MICROBIN_HIDE_LOGO: ${MICROBIN_HIDE_LOGO}
            MICROBIN_NO_LISTING: ${MICROBIN_NO_LISTING}
            MICROBIN_HIGHLIGHTSYNTAX: ${MICROBIN_HIGHLIGHTSYNTAX}
            MICROBIN_BIND: ${MICROBIN_BIND}
            MICROBIN_PRIVATE: ${MICROBIN_PRIVATE}
            MICROBIN_PURE_HTML: ${MICROBIN_PURE_HTML}
            MICROBIN_DATA_DIR: ${MICROBIN_DATA_DIR}
            MICROBIN_JSON_DB: ${MICROBIN_JSON_DB}
            MICROBIN_PUBLIC_PATH: ${MICROBIN_PUBLIC_PATH}
            MICROBIN_SHORT_PATH: ${MICROBIN_SHORT_PATH}
            MICROBIN_READONLY: ${MICROBIN_READONLY}
            MICROBIN_UPLOADER_PASSWORD: ${MICROBIN_UPLOADER_PASSWORD}
            MICROBIN_SHOW_READ_STATS: ${MICROBIN_SHOW_READ_STATS}
            MICROBIN_TITLE: ${MICROBIN_TITLE}
            MICROBIN_THREADS: ${MICROBIN_THREADS}
            MICROBIN_GC_DAYS: ${MICROBIN_GC_DAYS}
            MICROBIN_ENABLE_BURN_AFTER: ${MICROBIN_ENABLE_BURN_AFTER}
            MICROBIN_DEFAULT_BURN_AFTER: ${MICROBIN_DEFAULT_BURN_AFTER}
            MICROBIN_WIDE: ${MICROBIN_WIDE}
            MICROBIN_QR: ${MICROBIN_QR}
            MICROBIN_ETERNAL_PASTA: ${MICROBIN_ETERNAL_PASTA}
            MICROBIN_ENABLE_READONLY: ${MICROBIN_ENABLE_READONLY}
            MICROBIN_DEFAULT_EXPIRY: ${MICROBIN_DEFAULT_EXPIRY}
            MICROBIN_NO_FILE_UPLOAD: ${MICROBIN_NO_FILE_UPLOAD}
            MICROBIN_CUSTOM_CSS: ${MICROBIN_CUSTOM_CSS}
            MICROBIN_HASH_IDS: ${MICROBIN_HASH_IDS}
            MICROBIN_ENCRYPTION_CLIENT_SIDE: ${MICROBIN_ENCRYPTION_CLIENT_SIDE}
            MICROBIN_ENCRYPTION_SERVER_SIDE: ${MICROBIN_ENCRYPTION_SERVER_SIDE}
            MICROBIN_MAX_FILE_SIZE_ENCRYPTED_MB: ${MICROBIN_MAX_FILE_SIZE_ENCRYPTED_MB}
            MICROBIN_MAX_FILE_SIZE_UNENCRYPTED_MB: ${MICROBIN_MAX_FILE_SIZE_UNENCRYPTED_MB}
  ```
  Create a file with name `.env`.
  ```bash
  sudo nano .env
  ```
  Add this content into the file.
  ```env
  # Require username for HTTP Basic Authentication when
  # visiting the service. If basic auth username is set but
  # basic auth password is not, just leave the password field
  # empty when logging in. You can also just go to
  # https://username:password@yourserver.net or
  # https://username@yourserver.net if password is not set
  # instead of typing into the password
  # Default value: unset
  # export MICROBIN_BASIC_AUTH_USERNAME=

  # Require password for HTTP Basic Authentication when
  # visiting the service. Will not have any affect unless
  # basic auth username is also set. If basic auth username is
  # set but basic auth password is not, just leave the
  # password field empty when logging in. You can also just go
  # to https://username:password@yourserver.net or
  # https://username@yourserver.net if password is not set
  # instead of typing into the password prompt.
  # Default value: unset
  # export MICROBIN_BASIC_AUTH_PASSWORD=

  # Enables administrator interface at yourserver.com/admin/
  # if set, disables it if unset. If admin username is set but
  # admin password is not, just leave the password field empty
  # when logging in. 
  # Default value: admin
  export MICROBIN_ADMIN_USERNAME=admin

  # Enables administrator interface at yourserver.com/admin/
  # if set, disables it if unset. Will not have any affect
  # unless admin username is also set. If admin username is
  # set but admin password is not, just leave the password
  # field empty when logging in. 
  # Default value: m1cr0b1n
  export MICROBIN_ADMIN_PASSWORD=m1cr0b1n

  # Enables editable pastas. You will still be able to make
  # finalised pastas but there will be an extra checkbox to
  # make your new pasta editable from the pasta list or the
  # pasta view page.
  # Default value: true 
  export MICROBIN_EDITABLE=true

  # Replaces the default footer text with your own. If you
  # want to hide the footer, use the hide footer option instead.
  # Note that you can also embed HTML here, so you may want to escape 
  # '<', '>' and so on.
  # export MICROBIN_FOOTER_TEXT=

  # Hides the navigation bar on every page.
  # Default value: false 
  export MICROBIN_HIDE_HEADER=false

  # Hides the footer on every page.
  # Default value: false 
  export MICROBIN_HIDE_FOOTER=false

  # Hides the MicroBin logo from the navigation bar on every
  # page.
  # Default value: false 
  export MICROBIN_HIDE_LOGO=false

  # Disables the /pastalist endpoint, essentially making all
  # pastas private.
  # Default value: false 
  export MICROBIN_NO_LISTING=false

  # Enables syntax highlighting support. When creating a new
  # pasta, a new dropdown selector will be added where you can
  # select your pasta's syntax, or just leave it empty for no
  # highlighting.
  export MICROBIN_HIGHLIGHTSYNTAX=true

  # Sets the port for the server will be listening on.
  # Default value: 8080
  export MICROBIN_PORT=8080

  # Sets the bind address for the server will be listening on.
  # Both ipv4 and ipv6 are supported. Default value: "0.0.0.0".
  # Example value: "myserver.net", "127.0.0.1". 
  export MICROBIN_BIND="0.0.0.0"

  # Enables private pastas. Adds a new checkbox to make your
  # pasta private, which then won't show up on the pastalist
  # page. With the URL to your pasta, it will still be
  # accessible.
  # Default value: true
  export MICROBIN_PRIVATE=true

  # DEPRECATED: Will be removed soon. If you want to change styling (incl. removal), use custom CSS variable instead.
  # Disables main CSS styling, just uses a few in-line
  # stylings for the layout. With this option you will lose
  # dark-mode support. 
  export MICROBIN_PURE_HTML=false

  # Sets the name of the directory where MicroBin creates 
  # its database and stores attachments.
  # Default value: microbin_data
  export MICROBIN_DATA_DIR="microbin_data"

  # Enables storing pasta data (not attachments and files) in
  # a JSON file instead of the SQLite database. 
  # Default value: false
  export MICROBIN_JSON_DB=false

  # Add the given public path prefix to all urls. This allows
  # you to host MicroBin behind a reverse proxy on a subpath.
  # Note that MicroBin itself still expects all routes to be
  # as without this option, and thus is unsuited if you are
  # running MicroBin directly. Default value: unset. Example
  # values: https://myserver.com/ or https://192.168.0.10:8080/ 
  # export MICROBIN_PUBLIC_PATH=

  # Sets a shortened path to use when the user copies URL from
  # the application. This will also use shorter endpoints,
  # such as /p/ instead if /pasta/. Default value:
  # unset.Example value: https://b.in/ export
  # MICROBIN_SHORT_PATH=

  # The password required for uploading, if read-only mode is enabled
  # Default value: unset
  # export MICROBIN_UPLOADER_PASSWORD=

  # If set to true, authentication required for uploading
  # Default value: false
  export MICROBIN_READONLY=false

  # Enables showing read count on pasta pages.
  # Default value: false
  export MICROBIN_SHOW_READ_STATS=true

  # Adds your title of choice to the
  # navigation bar. 
  # Default value: unset
  # export MICROBIN_TITLE=

  # Number of workers MicroBin is allowed to have. Increase
  # this to the number of CPU cores you have if you want to go
  # beast mode, but for personal use one worker is enough.
  # Default value: 1.
  export MICROBIN_THREADS=1

  # Sets the garbage collector time limit. Pastas not accessed
  # for N days are removed even if they are set to never
  # expire. 
  # Default value: 90. 
  # To turn off GC: 0.
  export MICROBIN_GC_DAYS=90

  # Enables or disables the "Burn after" function
  # Default value: false
  export MICROBIN_ENABLE_BURN_AFTER=true

  # Sets the default burn after setting on the main screen.
  # Default value: 0. Available expiration options: 1, 10,
  # 100, 1000, 10000, 0 (= no limit)
  export MICROBIN_DEFAULT_BURN_AFTER=0

  # Changes the maximum width of the UI from 720 pixels to
  # 1080 pixels.
  # Default value: false
  export MICROBIN_WIDE=false

  # Enables generating QR codes for pastas. Requires
  # the public path to also be set.
  # Default value: false
  export MICROBIN_QR=true

  # Toggles "Never" expiry settings for pastas. Default
  # value: false
  export MICROBIN_ETERNAL_PASTA=false

  # Enables "Read-only" uploads. These are unlisted and
  # unencrypted, but can be viewed without password if you
  # have the URL. Editing and removing requires password.
  # Default value: true
  export MICROBIN_ENABLE_READONLY=true

  # Sets the default expiry time setting on the main screen.
  # Default value: 24hour Available expiration options: 1min,
  # 10min, 1hour, 24hour, 1week, never
  export MICROBIN_DEFAULT_EXPIRY=24hour

  # Disables and hides the file upload option in the UI.
  # Default value: false
  export MICROBIN_NO_FILE_UPLOAD=false

  # Replaced the built-in water.css stylesheet with the URL
  # you provide. Default value: unset. Example value:
  # https://myserver.net/public/mystyle.css 
  # export MICROBIN_CUSTOM_CSS=

  # Use short hash strings in the URLs instead of animal names
  # to make URLs shorter. Does not change the underlying data
  # stored, just how pastas are recalled.
  # Default value: false
  export MICROBIN_HASH_IDS=false

  # Enables server-side encryption. This will add private
  # privacy level, where the user sends plain unencrypted data
  # (still secure, because you use HTTPS, right?), but the
  # server sees everything that the user submits, therefore
  # the user does not have complete and absolute protection.
  # Default value: false
  export MICROBIN_ENCRYPTION_CLIENT_SIDE=true

  # Enables client-side encryption. This will add the secret
  # privacy level where the user's browser encrypts all data
  # with JavaScript before sending it over to MicroBin, which
  # encrypt the data once again on server side.
  # Default value: false
  export MICROBIN_ENCRYPTION_SERVER_SIDE=true

  # Limit the maximum file size users can upload without
  # encryption. Default value: 256.
  export MICROBIN_MAX_FILE_SIZE_ENCRYPTED_MB=256

  # Limit the maximum file size users can upload with
  # encryption (more strain on your server than without
  # encryption, so the limit should be lower. Secrets tend to
  # be tiny files usually anyways.) Default value: 2048.
  export MICROBIN_MAX_FILE_SIZE_UNENCRYPTED_MB=2048

  # Disables the feature that checks for available updates
  #  when opening the admin screen.
  # Default value: false
  export MICROBIN_DISABLE_UPDATE_CHECKING=false

  # Disables telemetry if set to true.
  # Telemetry includes your configuration and helps development. 
  # It does not include any sensitive data.
  # Default value: false
  export MICROBIN_DISABLE_TELEMETRY=false

  # Enables listing your server in the public MicroBin server list.
  # Default value: false
  export MICROBIN_LIST_SERVER=false
  ```
  Start the container.
  ```bash
  sudo docker compose --env-file .env up -d
  ```
  Open a web browser and go the following URI : `http://IP:8080`

configuration: |
  N/A

sauvegarde: |
  Backup the `/docker/microbin` folder.
  ```bash
  sudo rsync -aqz /docker/microbin/ user@192.168.1.2:/docker/microbin/
  ```

restauration: |
  Stop the containers on the Docker server.
  ```bash
  sudo docker stop microbin
  ```
  Copy the data from the backup server
  ```bash
  sudo scp -rp user@192.168.1.2:/docker/microbin/ /docker/microbin/
  ```
  Restart the containers.
  ```bash
  sudo docker restart microbin
  ```

mise_a_jour: |
  Remove the container.
    ```bash
    sudo docker rm -f microbin
    ```
  Remove the "**danielszabo99/microbin:latest**" image.
    ```bash
    sudo docker image rm -f danielszabo99/microbin:latest
    ```
  Restart the container.
    ```bash
    cd /docker/microbin && sudo docker compose --env-file .env up -d
    ```
---