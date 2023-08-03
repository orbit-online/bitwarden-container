FROM node:20.4.0-alpine3.18

RUN deluser node

RUN apk add --no-cache --update su-exec

RUN mkdir /bitwarden; mkdir -p /home/user/.config/Bitwarden\ CLI
WORKDIR /bitwarden

COPY package.json yarn.lock /bitwarden
RUN yarn install --frozen-lockfile

COPY --from=gcr.io/google_containers/pause-amd64:3.2 /pause /pause

COPY --chmod=755 entrypoint.sh .
ENTRYPOINT ["/bitwarden/entrypoint.sh"]
