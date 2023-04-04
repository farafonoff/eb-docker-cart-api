FROM node:18.15.0-alpine3.17 as build

COPY . ./app/

RUN cd /app/; npm ci;npm run build;

FROM node:18.15.0-alpine3.17 as run

ENV NODE_ENV production

COPY --from=build /app/dist ./app/dist
COPY --from=build /app/package.json ./app/
COPY --from=build /app/package-lock.json ./app/

RUN cd /app/; npm ci --only=production

USER node

EXPOSE 4000

#CMD "ls" "-laR"
ENTRYPOINT ["node", "/app/dist/main"]
