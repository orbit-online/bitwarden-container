#!/usr/bin/env bash

set -eo pipefail
shopt -s inherit_errexit

bw() {
  local use_tty=''
  [[ -t 0 && -t 1 ]] && use_tty="-t"
  export USER_UID
  USER_UID=$(id -u)
  if [[ -z "$(docker ps -aq --filter "name=^bitwarden\$")" ]]; then
    docker run --quiet --name bitwarden --detach --rm -e HOME -e USER_UID \
      -v"/tmp:/tmp" -v"${HOME}:${HOME}:rw" \
      secoya/bitwarden-cli:1.22.1-2
  fi
  exec docker exec $use_tty -i -e BW_SESSION bitwarden /sbin/su-exec "$USER_UID:$USER_UID" /bitwarden/node_modules/.bin/bw "$@"
}

bw "$@"
