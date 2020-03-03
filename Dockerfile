FROM node:8
RUN apt-get update
RUN apt-get install -y nginx
RUN mkdir -p /home/nodejs/app
WORKDIR /home/nodejs/app
COPY package.json /home/nodejs/app
RUN npm install
COPY . /home/nodejs/app
RUN node -v
CMD ["node", "index.js"]
EXPOSE 51005
EXPOSE 443
