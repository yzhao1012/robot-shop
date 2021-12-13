FROM node:14

ENV INSTANA_AUTO_PROFILE true

EXPOSE 8080

WORKDIR /opt/server

COPY package.json /opt/server/

RUN npm install

COPY server.js /opt/server/
COPY server.crt /tmp/ssl_keys/
COPY server.key /tmp/ssl_keys/

CMD ["node", "server.js"]

