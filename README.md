### 1. Run a simple Docker container

#### What to do:
- Create a Debian container
- New Dockerfile
  - FROM debian
- Build image
- Run image
- Run cat /etc/issue

#### Hints:
- docker build . -t [IMAGE_NAME]
- docker run -it [IMAGE_NAME] bash

<details><summary>Solution</summary>

#### New Dockerfile
```yaml
FROM debian
```

#### Build image
```bash
docker build . -t debian_image
```

#### Run image
```bash
docker run -it debian_image bash
```

#### Run inside the container now
```bash
cat /etc/issue
```

</details>

---

### 2. Create a Docker container and mount host volume

#### What to do:
- Create a Debian container (Dockerfile bluh bluh)
- Create a folder “html”
- Create inside folder an index.html file
 - With some text
- Mount host folder ./html to /html folder in container

#### Hints:
- "--mount type=bind,source="$(pwd)/html",target=/html"

<details><summary>Solution</summary>

#### New Dockerfile
```yaml
FROM debian
```

### Create folder and HTML file
```bash
mkdir html
touch html/index.html
echo "Hello SocialNerds!" >> html/index.html
```

#### Build image
```bash
docker build . -t debian_image
```

#### Run image
```bash
docker run -it --mount type=bind,source="$(pwd)/html",target=/html debian_image bash
```

#### Run inside the container now
```bash
cat /html/index.html
```

You should see "Hello SocialNerds!"

</details>

### 3. Create a Docker container with named volume

---

#### What to do:
- Create a Debian container (Dockerfile bluh bluh)
  - named debian_1
- Create a volume named “html”
- Mount volume “html” to /html folder in container
- Add a new file named “index.html” in /html folder
- Create a new Debian container named debian_2
- Mount volume “html” to /html folder in container

#### Hints:
- docker volume create [VOLUME_NAME]
- --mount source=[VOLUME_NAME],target=/html
- --name [CONTAINER_NAME]

<details><summary>Solution</summary>

#### New Dockerfile
```yaml
FROM debian
```

### Create volume
```bash
docker volume create html
```

#### Build image
```bash
docker build . -t debian_image
```

#### Run image
```bash
docker run -it --name debian_1 --mount source=html,target=/html debian_image bash
```

#### Run inside the container now
```bash
touch /html/index.html
```

#### Exit the container
```bash
exit
```

#### Run another container
```bash
docker run -it --name debian_2 --mount source=html,target=/html debian_image bash
```

#### Check file exists
```bash
ls -la /html/index.html
```

</details>

---

### 4. Create a network for all services

#### What to do:
- Run ./clearall
- Go to 4_Network folder (cd 4_Network)
- Run ./setall
- Run "docker ps" to check everything is there
- Create a network named apache_tomcat_mysql
- Connect all containers to it
- Connect mysql container with "superdb" alias

#### Hints:
- docker network connect [NETWORK_NAME] [CONTAINER_NAME]
- docker network connect --alias [ALIAS] [NETWORK_NAME] [CONTAINER_NAME]

<details><summary>Solution</summary>

#### Create network
```bash
docker network create apache_tomcat_mysql
```

#### Connect all to network
```bash
docker network connect apache_tomcat_mysql apache
docker network connect apache_tomcat_mysql tomcat
docker network connect --alias superdb apache_tomcat_mysql mysql
```

</details>

---

### 5. RUN MySQL with more environment variables

#### What to do:
- Run ./clearall
- Run a MySQL 5.7 container and pass environment variables for
  - MYSQL_ROOT_PASSWORD
  - MYSQL_DATABASE (Creates a database by default)
  - MYSQL_USER (Creates a user for the default database)
  - MYSQL_PASSWORD (Sets a password for this user)

#### Hints:
- "-e MYSQL_ROOT_PASSWORD=[MYSQL_ROOT_PASSWORD]"

<details><summary>Solution</summary>

#### Run MySQL container
```bash
docker run -d -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=my_default_database \
  -e MYSQL_USER=my_default_user \
  -e MYSQL_PASSWORD=password \
  mysql:5.7
```

</details>

---

### 6. RUN MySQL with environment variables from file

#### What to do:
- Run ./clearall
- Create a new folder and cd to this folder
- Run a MySQL 5.7 container and pass environment variables
  through an .env file for
  - MYSQL_ROOT_PASSWORD
  - MYSQL_DATABASE (Creates a database by default)
  - MYSQL_USER (Creates a user for the default database)
  - MYSQL_PASSWORD (Sets a password for this user)

#### Hints:
- "--env-file .env"

<details><summary>Solution</summary>

#### Create file and add variables
```bash
touch .env
echo "MYSQL_ROOT_PASSWORD=root\n\
MYSQL_DATABASE=my_default_database\n\
MYSQL_USER=my_default_user\n\
MYSQL_PASSWORD=password\n" \
> .env
```

#### Run MySQL container
```bash
docker run -d --env-file .env mysql:5.7
```

</details>

---

### 7. COPY, CMD

#### What to do:
- Run ./clearall
- Create a new folder and cd to this folder
- Create Dockerfile and a "start" script
- In the start script add the command "tail -f /dev/null"
- Create a Dockerfile "FROM ubuntu"
- In the Dockerfile create a user named "serveruser"
- COPY the script inside the Docker image under /home/serveruser/
- Set the owner of the start script as "serveruser"
- Make the start script the default command

#### Hints:
- Create user "RUN useradd -ms /bin/bash [USERNAME]"
- Add execute permission "RUN chmod +x [FILE]"
- Copy from host to image "COPY [HOST_SOURCE] [IMAGE_DESTINATION]"
- Script annotation "#!/bin/bash"
- Default command "CMD [COMMAND]"

<details><summary>Solution</summary>

#### Dockerfile
```Dockerfile
FROM ubuntu

RUN useradd -ms /bin/bash serveruser

COPY ./start /home/serveruser/start
RUN chmod +x /home/serveruser/start
RUN chown serveruser:serveruser /home/serveruser/start

CMD ["/home/serveruser/start"]
```

#### Start script
```bash
#!/bin/bash

tail -f /dev/null
```

#### Build image
```bash
docker build . -t ubuntu_image
```

#### RUN image
```bash
docker run -d ubuntu_image
```
</details>

---

### 8. ARG

#### What to do:
- Run ./clearall
- Create a Dockerfile "FROM ubuntu"
- In the Dockerfile create a user named "serveruser"
- Build the image UID=512 for "serveruser"

#### Hints:
- Create user "RUN useradd -ms /bin/bash -u [UID] [USERNAME]"
- Dockerfile syntax "ARG [ARGUMENT]"
- Command "--build-arg UID=[UID]"

<details><summary>Solution</summary>

#### Dockerfile
```Dockerfile
FROM ubuntu

ARG UID

RUN useradd -ms /bin/bash -u $UID serveruser
```

#### Build image
```bash
docker build . --build-arg UID=512 -t ubuntu_image
```

</details>

---

### 9. docker-entrypoint

#### What to do:
- Run ./clearall
- cd to 9_Docker_Entrypoint folder
- When docker-entrypoint.sh runs, create a new folder /home/serveruser/code
- This new folder must be owned by user "serveruser"
- The name of the folder must pass as env variable E.g. "CODE_FOLDER"

#### Hints:
- Create folder: "mkdir /home/serveruser/[FOLDER_NAME]"
- Change ownsership "chown -R [USERNAME]:[GROUP] /home/serveruser/[FOLDER_NAME]"

<details><summary>Solution</summary>

#### docker-entrypoint.sh
```bash
###
mkdir /home/serveruser/$CODE_FOLDER
chown -R serveruser:serveruser /home/serveruser/$CODE_FOLDER
###
```

#### Build image
```bash
docker build . -t ubuntu_image
```

#### Run image
```bash
docker run -d --name ubuntu_container -e UID=512 -e CODE_FOLDER=code ubuntu_image
```

</details>

---

### 10. Docker Compose

#### What to do:
- Run ./clearall
- cd to 10_Docker_Compose folder
- Add a new service named app_http_2
- Add to the same network as app_http
- No exposed ports
- Same command
- Same volume

#### Hints:
- What hints? It is just copy paste :)
- Build images: docker-compose build
- Run images: docker-compose up -d
- Stop and Remove: docker-compose down

<details><summary>Solution</summary>

#### docker-compose.yml
```bash
http_2:
  image: ubuntu:18.04
  command: ["tail", "-f", "/dev/null"]
  container_name: app_http_2
  volumes:
    - ./data:/data
  networks:
    app_network:
```

</details>

---

### 11. Docker Compose env

#### What to do:
- Run ./clearall
- cd to 11_Docker_Compose_env folder
- Pass an environment variable to fpm service named APP_DEBUG
- The value of the variable should be "TRUE"

#### Hints:
- Don't forget to add the variable in the .env file

<details><summary>Solution</summary>

#### docker-compose.yml
```bash
environment:
  APP_DEBUG: ${APP_DEBUG}
```

#### .env
```bash
###
APP_DEBUG=TRUE
###
```

</details>

---

### 12. Docker Compose args

#### What to do:
- Run ./clearall
- cd to 12_Docker_Compose_args folder
- Pass an argument to fpm service named UID
- The value of the variable should be the user id of your user on your machine

#### Hints:
- Type "id" to get user id
- Google "docker compose arguments"

<details><summary>Solution</summary>

#### docker-compose.yml
```bash
fpm:
  build:
    context: ./fpm
    args:
      UID: ${UID}
  container_name: fpm
  .....
```

#### .env
```bash
UID=1234
```

</details>

---

### 13. Docker Compose networks

#### What to do:
- Run ./clearall
- cd to 13_Docker_Compose_networks folder
- Set a network for http and fpm named app_public_network
- Set a network for fpm and db named app_private_network

<details><summary>Solution</summary>

#### docker-compose.yml
```bash
version: '3.8'

services:
  http:
    build:
      context: ./http
      args:
        UID: ${UID}
    container_name: http
    restart: always
    volumes:
      - ./code:/home/serveruser/code
    ports:
      - 8080:80
    networks:
      app_public_network:
  fpm:
    build:
      context: ./fpm
      args:
        UID: ${UID}
    container_name: fpm
    restart: always
    volumes:
      - ./code:/home/serveruser/code
    networks:
      app_private_network:
      app_private_network:
  db:
    build:
      context: ./db
    container_name: db
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - dbdata:/var/lib/mysql
    networks:
      app_private_network:

networks:
  app_public_network:
  app_private_network:

volumes:
  dbdata:
```

</details>

---

### 14. Docker Compose override

#### What to do:
- Run ./clearall
- cd to 14_Docker_Compose_override folder
- Create a new file docker-compose-dev.yml
- Add to docker-compose-dev.yml only the db service configuration
- Remove the db service configuration from docker-compose.yml

<details><summary>Solution</summary>

#### docker-compose-dev.yml
```bash
version: '3.8'

services:
  db:
    build:
      context: ./db
    container_name: db
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - dbdata:/var/lib/mysql
    networks:
      app_network:

volumes:
  dbdata:
```

</details>

---
