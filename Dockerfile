FROM node:8
RUN apt-get install nginx
RUN openssl req -newkey rsa:2048 -nodes -keyout /etc/nginx/conf.d/localhost.key -x509 -days 365 -out /etc/nginx/conf.d/localhost.crt
RUN mkdir -p /home/nodejs/app
WORKDIR /home/nodejs/app
COPY package.json /home/nodejs/app
RUN npm install
COPY . /home/nodejs/app
RUN node -v
CMD ["node", "index.js"]
EXPOSE 51005
EXPOSE 443
