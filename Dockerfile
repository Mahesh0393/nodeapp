FROM node:8
RUN apt-get update
RUN apt-get install -y nginx && service nginx restart
RUN mkdir -p /home/nodejs/app
RUN mkdir -p /etc/ssl
COPY default /etc/nginx/sites-available/
COPY ./ssl/fullchain.pem /etc/ssl
COPY ./ssl/privkey.pem /etc/ssl
WORKDIR /home/nodejs/app
COPY package.json /home/nodejs/app
RUN npm install
COPY . /home/nodejs/app
RUN node -v
RUN service nginx restart && service nginx status
CMD ["node", "index.js"]
EXPOSE 51005
EXPOSE 80
EXPOSE 443
