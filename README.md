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
docker run -it --mount type=bind,source="$(pwd)/html",target=/html ubuntu_image bash
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
docker run -it --name debian_1 --mount source=html,target=/html ubuntu_image bash
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
docker run -it --name debian_2 --mount source=html,target=/html ubuntu_image bash
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
docker network apache_tomcat_mysql
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
