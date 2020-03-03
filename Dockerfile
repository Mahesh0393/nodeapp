FROM node:8
RUN mkdir -p /home/nodejs/app
WORKDIR /home/nodejs/app
COPY package.json .
RUN npm install
COPY . .
CMD [“npm”, “start”]
EXPOSE 51005
