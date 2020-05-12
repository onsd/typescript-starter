# The instructions for the first stage
FROM node:12-alpine as builder-1

ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}

COPY package*.json ./
RUN npm install

# The instructions for second stage
FROM node:12-alpine as builder-2

WORKDIR /usr/src/app
COPY --from=builder-1 node_modules node_modules

COPY . .

RUN npm run build

# Run builded code 
FROM node:12-alpine
WORKDIR /usr/src/app
COPY --from=builder-2  /usr/src/app/dist dist
EXPOSE 3000
CMD [ "node", "dist/server.js" ]