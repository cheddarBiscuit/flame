# The client build only produces static files, so run it on the build machine's
# own architecture instead of emulating the target platform.
FROM --platform=$BUILDPLATFORM node:24-alpine AS client-builder

WORKDIR /app/client

COPY client/package*.json ./

RUN npm ci --omit=dev

COPY client ./

RUN npm run build

FROM node:24-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN apk --no-cache --virtual build-dependencies add python3 make g++ \
    && npm install --production

COPY . .

RUN mkdir -p ./public ./data \
    && rm -rf ./client

COPY --from=client-builder /app/client/build/ ./public/

FROM node:24-alpine

# npm is only needed to build; dropping it removes its bundled dependencies
# from the runtime image. su-exec lets the entrypoint drop root after chown
# (set PUID=0 to stay root).
RUN apk add --no-cache su-exec \
    && rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx

COPY --from=builder /app /app
COPY --from=builder --chmod=755 /app/.docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

WORKDIR /app

EXPOSE 5005

ENV NODE_ENV=production
ENV PASSWORD=flame_password

CMD ["docker-entrypoint.sh"]