# nodeapp

Use the following command to download the modified code:
git clone https://github.com/Mahesh0393/nodeapp.git


#Build application docker image

To build a docker image created a Dockerfile in the root directory of the application code base:

FROM node:8
RUN apt-get update
RUN apt-get install -y nginx
COPY ssl.sh /etc/nginx/conf.d
RUN cd /etc/nginx/conf.d && chmod +x ssl.sh && ./ssl.sh
RUN service nginx restart
RUN mkdir -p /home/nodejs/app
WORKDIR /home/nodejs/app
COPY package.json /home/nodejs/app
RUN npm install
COPY . /home/nodejs/app
RUN node -v
CMD ["node", "index.js"]
EXPOSE 51005
EXPOSE 443


Create a compose file called ‘docker-compose.yml’ to run multiple container in one go :
version: "2"
services:
  web:
    container_name: docker-node-mongo
    build: .
    ports:
    - "51005:51005"
    - "8181:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    links:
      - mongo
      - mysqlhost
  mongo:
    container_name: mongo
    image: mongo
    volumes:
      - datavolume-mongo:/data/db
    ports:
      - "27017:27017"
  mysqlhost:
    container_name: mysqlhost
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: backend_demo
      MYSQL_USER: root
      MYSQL_PASSWORD: password
    volumes:
      - datavolume-mysql:/var/lib/mysql
    ports:
       - "3306:3306"
volumes:
  datavolume-mysql:
  datavolume-mongo:  

This defines three docker containers:
web which represents our application docker
mongo which represents the persistence layer docker
mysql also represents the persistence layer docker

By default, “web” service can reach “mongo” service by using the service’s name.

To run the three dockers using the compose file execute the command:

$ docker-compose up -d --build


Open a browser on http://server_ip:51005/ to see our application:

From there we can See our running application

Let’s validate that the user has been persistent in our MongoDB & mysql docker that is part of the composed work:

$ docker ps
CONTAINER ID     IMAGE          COMMAND                  CREATED             STATUS              PORTS                                             NAMES
dcea78b6c5f1     nodeapp_web  "docker-entrypoint.s…"   15 minutes ago      Up 15 minutes      0.0.0.0:51005->51005/tcp,                 docker-node-mongo
                                                                                               0.0.0.0:8181->443/tcp
69bd3575ee0d        mongo       "docker-entrypoint.s…"   15 minutes ago      Up 15 minutes     0.0.0.0:27017->27017/tcp                         mongo
ed9a8fc0bad8        mysql:5.7   "docker-entrypoint.s…"   15 minutes ago      Up 15 minutes     0.0.0.0:3306->3306/tcp, 33060/tcp                mysqlhost

$ docker exec -it 69bd3575ee0d /bin/bash
$ mongo
MongoDB shell version v4.2.3
connecting to: mongodb://127.0.0.1:27017/?compressors=disabled&gssapiServiceName=mongodb
Implicit session: session { "id" : UUID("bb84cd05-a2df-462c-95b0-e58fcc4fa01f") }
MongoDB server version: 4.2.3
Welcome to the MongoDB shell.
For interactive help, type "help".
For more comprehensive documentation, see
        http://docs.mongodb.org/
---

> use backend_demo
switched to db backend_demo
> db.users.save({id: "50", user_id: "2564", first_name: "Mahesh", last_name: "Karale"})
WriteResult({ "nInserted" : 1 })
>

#Persist data in a dedicated volume
In our current setup, we will lose our user data when we delete the mongo container or rebuild it. This is because MongoDB storage is part of the mongo container.
If we want to ensure that the data surpass the lifetime of the mongo container, we should use a named volume to store our mongo files.
The named volume will remain after the container is deleted and can be attached to other docker containers:
mongo:
    container_name: mongo
    image: mongo
    volumes:
      - datavolume-mongo:/data/db
    ports:
      - "27017:27017"
  mysqlhost:
    container_name: mysqlhost
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: backend_demo
      MYSQL_USER: root
      MYSQL_PASSWORD: password
    volumes:
      - datavolume-mysql:/var/lib/mysql
    ports:
       - "3306:3306"
volumes:
  datavolume-mysql:
  datavolume-mongo:  

The only addition is the volumes section that defines a named volume call datavolume-mysql & datavolume-mongo and in mysql & mongo service we added the volumes. That field maps the created ddatavolume-mysql & datavolume-mongo into '/var/lib/mysql' & ‘/data/db’ folder where the mysql & mongo storage file resides.
Summary
That is it. We have a build a simple application that persists data in MongoDB and MYSQL. We were able to Dockerize that application and use docker-compose to lunch all the application, MongoDB and MYSQL in a single command. Lastly, we used volumes to ensure the persisted data remains after the MongoDB and MYSQL container are destroyed. 

We can close all dockers with:
$docker-compose stop