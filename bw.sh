#!/usr/bin/env bash

bw() {
  set -eo pipefail
  shopt -s inherit_errexit
  local pkgroot
  pkgroot=$(upkg root "${BASH_SOURCE[0]}")
  PATH="$pkgroot/.upkg/.bin:$PATH"

  checkdeps jq

  local version image use_tty='' user_uid
  version=$(jq -r '.version // "latest" | sub("^v"; "")' "$pkgroot/upkg.json")
  image="secoya/bitwarden-cli:$version"
  user_uid=$(id -u)

  start_bw() {
    docker run --quiet --name bitwarden --detach --rm -e HOME -e "USER_UID=$user_uid" \
      -v"/tmp:/tmp" -v"${HOME}:${HOME}:rw" \
      "$image" >/dev/null
  }

  [[ -t 0 && -t 1 ]] && use_tty="-t"
  if [[ -z "$(docker ps -aq --filter "name=^bitwarden\$")" ]]; then
    start_bw
  elif [[ $(docker inspect bitwarden | jq -r '.[0].Config.Image') != "$image" ]]; then
    docker stop bitwarden >/dev/null
    start_bw
  fi
  exec docker exec $use_tty -i -e BW_SESSION bitwarden /sbin/su-exec "$user_uid:$user_uid" /bitwarden/node_modules/.bin/bw "$@"
}

bw "$@"
