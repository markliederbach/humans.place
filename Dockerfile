################################
# STEP 1 build app
################################
FROM node:lts-alpine AS build

WORKDIR /app

COPY ./package*.json ./
RUN npm install
COPY . ./
RUN apk add dumb-init
RUN npm run build

################################
# STEP 1 deployment image
################################
FROM node:lts-alpine
USER node:node

WORKDIR /app

COPY --from=build /usr/bin/dumb-init /usr/bin/dumb-init
COPY --from=build /app/build .
COPY --from=build /app/package.json .
COPY --from=build /app/package-lock.json .
RUN npm ci --omit dev

EXPOSE 3000
ENTRYPOINT [ "/usr/bin/dumb-init" ]
CMD ["node","/app/index.js"]
