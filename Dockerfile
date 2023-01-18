# Install deps
FROM node:19.4.0 AS deps
RUN apt-get update && apt-get install -y --no-install-recommends dumb-init
ARG NPM_TOKEN
WORKDIR /usr/src/app
COPY . /usr/src/app/
RUN yarn --prefer-offline \
    --frozen-lockfile \
    --non-interactive \
    --production=false


# Build stage
FROM node:19.4.0 AS build
WORKDIR /usr/src/app
COPY --from=deps /usr/src/app /usr/src/app
RUN yarn build


# Production
FROM node:19.4.0-alpine

ENV NODE_ENV production
COPY --from=deps /usr/bin/dumb-init /usr/bin/dumb-init
USER node
WORKDIR /usr/src/app
COPY --chown=node:node --from=deps /usr/src/app/node_modules /usr/src/app/node_modules
COPY --chown=node:node --from=build /usr/src/app/dist /usr/src/app/dist
COPY --chown=node:node . /usr/src/app
CMD ["node", "./dist/index.js"]
