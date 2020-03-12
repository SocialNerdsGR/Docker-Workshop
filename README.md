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

### 2. Create a Docker container with named volume

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