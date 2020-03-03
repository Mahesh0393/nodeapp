FROM node:8
RUN mkdir -p /home/nodejs/app
WORKDIR /home/nodejs/app
COPY package.json /home/nodejs/app
RUN npm install
COPY . /home/nodejs/app
RUN npm -v
RUN apt install node
CMD ["node.js", "index.js"]
EXPOSE 51005
