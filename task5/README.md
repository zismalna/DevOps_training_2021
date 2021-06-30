
# Jenkins

### Setting up Jenkins in Docker

```sh
docker ps
```

![Jenkins](./images/dockerps.png "Docker container with Jenkins")

### Jenkins agents

Jenkins agents are set up on separate Amazon instances as Docker containers:

![agent1](./images/agent1.png "agent1")

![agent2](./images/agent2.png "agent2")

![agents](./images/agents.png "agents")

### Freestyle project

Displays current time:

![Date](./images/date.png "Current time")

### Pipeline #1

A Jenkins pipeline that performs *docker ps -a* on a host that runs Jenkins agent in Docker.

```sh
pipeline {
    agent {
        node {
            label 'ubuntu1'
        }
        } 
    stages {
        stage('Test') {
            steps {
                sh '''cd /home/jenkins
                ssh-keyscan -H 172.17.0.1 >> ~/.ssh/known_hosts
                ssh -i ./instance1.pem -t ubuntu@172.17.0.1 docker ps -a'''
            }
            }
        }
    }
```

Result:

![docker ps -a](./images/psa.png "Query docker host")

### Building docker image from my Github

After adding credentials in Jenkins Credentials Manager:

The pipeline:

```sh
pipeline {
    agent {
        node {
            label 'ubuntu1'
        }
        } 
    stages {
        stage('Get code') {
            steps {
                // Get some code from a GitHub repository
                git branch: 'main', credentialsId: 'github-repo', url: 'https://github.com/zismalna/DevOps_training_2021/'
                }
        }
        stage('Build') {
            steps {
                sh '''ssh-keyscan -H 172.17.0.1 >> ~/.ssh/known_hosts
                scp -i ~/instance1.pem ./task3/Dockerfile ubuntu@172.17.0.1:/home/ubuntu 
                ssh -i ~/instance1.pem -t ubuntu@172.17.0.1 build -t nginx /home/ubuntu/'''
                }
            }
        }
    }
```

Result:

```sh

Started by user Michael Lopaiev
Running in Durability level: MAX_SURVIVABILITY
[Pipeline] Start of Pipeline
[Pipeline] node
Running on agent1 in /home/jenkins/workspace/Git
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Get code)
[Pipeline] git
The recommended git tool is: NONE
using credential github-repo
Fetching changes from the remote Git repository
Checking out Revision 1290aea894929f64210c3d288ce5374be2908e1e (refs/remotes/origin/main)
Commit message: "Committig modified Dockerfile from task3"
 > git rev-parse --resolve-git-dir /home/jenkins/workspace/Git/.git # timeout=10
 > git config remote.origin.url https://github.com/zismalna/DevOps_training_2021/ # timeout=10
Fetching upstream changes from https://github.com/zismalna/DevOps_training_2021/
 > git --version # timeout=10
 > git --version # 'git version 2.20.1'
using GIT_ASKPASS to set credentials 
 > git fetch --tags --force --progress -- https://github.com/zismalna/DevOps_training_2021/ +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 1290aea894929f64210c3d288ce5374be2908e1e # timeout=10
 > git branch -a -v --no-abbrev # timeout=10
 > git branch -D main # timeout=10
 > git checkout -b main 1290aea894929f64210c3d288ce5374be2908e1e # timeout=10
 > git rev-list --no-walk 1290aea894929f64210c3d288ce5374be2908e1e # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Build)
[Pipeline] sh
+ ssh-keyscan -H 172.17.0.1
# 172.17.0.1:22 SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.2
# 172.17.0.1:22 SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.2
# 172.17.0.1:22 SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.2
+ scp -i /home/jenkins/instance1.pem ./task5/Dockerfile ubuntu@172.17.0.1:/home/ubuntu
+ ssh -i /home/jenkins/instance1.pem -t ubuntu@172.17.0.1 docker build -t nginx1 /home/ubuntu/
Pseudo-terminal will not be allocated because stdin is not a terminal.
Sending build context to Docker daemon  22.53kB

Step 1/7 : FROM ubuntu:latest
 ---> 9873176a8ff5
Step 2/7 : ENV DEVOPS="mlopaiev"
 ---> Using cache
 ---> 8f1063f6f1db
Step 3/7 : ENV index="/var/www/html/index.nginx-debian.html"
 ---> Using cache
 ---> 31b161b12f88
Step 4/7 : RUN apt-get update && apt-get install -y nginx
 ---> Using cache
 ---> c1e473efd52a
Step 5/7 : EXPOSE 80
 ---> Using cache
 ---> 8fb62e1d3384
Step 6/7 : STOPSIGNAL SIGQUIT
 ---> Using cache
 ---> ccb7c9b14b6a
Step 7/7 : CMD tac $index | sed '3d' | tac > /tmp/test.html && mv /tmp/test.html $index && sed -i "14 a $MYNAME Sandbox 2021" $index && nginx -g 'daemon off;'
 ---> Using cache
 ---> 422e361e56e2
Successfully built 422e361e56e2
Successfully tagged nginx1:latest
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```

Resulting docker image:

![Result](./images/nginx1.png "Built docker image")

