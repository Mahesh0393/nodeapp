FROM node:8
RUN mkdir -p /home/nodejs/app
WORKDIR /home/nodejs/app
COPY package.json .
RUN npm install
COPY . .
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
RUN npm -v
CMD [“npm”, “start”]
EXPOSE 51005
