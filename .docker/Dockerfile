FROM node:24-alpine as builder

WORKDIR /app

COPY package*.json ./

RUN apk --no-cache --virtual build-dependencies add python3 make g++ \
    && npm install --production

COPY . .

RUN mkdir -p ./public ./data \
    && cd ./client \
    && npm install --production \
    && npm run build \
    && cd .. \
    && mv ./client/build/* ./public \
    && rm -rf ./client

FROM node:24-alpine

# npm is only needed to build; dropping it removes its bundled dependencies
# from the runtime image. su-exec lets the entrypoint drop root after chown.
RUN apk add --no-cache su-exec \
    && rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx

COPY --from=builder /app /app

WORKDIR /app

EXPOSE 5005

ENV NODE_ENV=production
ENV PASSWORD=flame_password

CMD ["sh", "-c", "chown -R node /app/data /app/public && exec su-exec node node server.js"]