FROM node:8
RUN mkdir -p /home/nodejs/app
WORKDIR /home/nodejs/app
COPY package.json .
RUN npm install
COPY . .
RUN npm -v
CMD ["node.js", "index.js"]
EXPOSE 51005
