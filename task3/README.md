# Docker

### Installing Docker

Bash script for installing Docker on Ubuntu:

```sh
#!bin/bash
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
```

### Building Docker image from basic Ubuntu image

Creating dockerfile to build image:

```sh
FROM ubuntu:latest
ENV DEVOPS="mlopaiev"
ENV index="/var/www/html/index.nginx-debian.html"
RUN apt-get update && \
apt-get install -y nginx
COPY ./task3.sh /tmp
RUN bash /tmp/task3.sh
EXPOSE 80
STOPSIGNAL SIGQUIT
CMD tac $index | sed '3d' | tac > /tmp/test.html && mv /tmp/test.html $index && \
sed -i "14 a $MYNAME Sandbox 2021" $index && \
nginx -g 'daemon off;'
```

This way, when running *docker run*, and passing variable from host, it's updated in container and displayed on the web page:

```sh
 sudo docker build -t nginx ./
 
 sudo docker run --name test17 --env MYNAME="M.Lopayev" -d -p 80:80 nginx
```

The passed environmental variable is then seen on the web page, and is also updated when *docker run* passes another value for the variable *$MYNAME*.

![Web](./images/1.png "web page")

### Pushing to Docker Hub

Logging to Docker Hub on host: 

```sh
sudo docker login docker.io
```

Applying tag and pushing:

```sh
sudo docker tag nginx:latest zismalna/devops:latest

sudo docker push zismalna/devops:latest
```


