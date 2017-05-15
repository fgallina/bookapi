FROM bookapi-dependencies

WORKDIR /usr/src/app
COPY knexfile.js .
COPY migrations migrations
COPY api api

EXPOSE 3000
CMD [ "node", "api/index.js" ]
