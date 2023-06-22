FROM node:16.15.0-alpine3.15

RUN deluser node

RUN --mount=type=cache,id=apk,sharing=locked,target=/var/cache/apk \
  ln -s /var/cache/apk /etc/apk/cache && \
  apk add --update su-exec

RUN mkdir /bitwarden; mkdir -p /home/user/.config/Bitwarden\ CLI
WORKDIR /bitwarden

COPY package.json yarn.lock ./

RUN --mount=type=cache,id=yarn,sharing=locked,target=/usr/local/share/.cache/yarn \
  YARN_CACHE_FOLDER=/usr/local/share/.cache/yarn yarn install --frozen-lockfile

COPY --from=gcr.io/google_containers/pause-amd64:3.2 /pause /pause

COPY --chmod=755 entrypoint.sh .
ENTRYPOINT ["/bitwarden/entrypoint.sh"]
