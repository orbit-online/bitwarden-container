#!/usr/bin/env bash

bw() {
  set -eo pipefail
  shopt -s inherit_errexit
  local pkgroot
  pkgroot=$(upkg root "${BASH_SOURCE[0]}")
  PATH="$pkgroot/.upkg/.bin:$PATH"
  # shellcheck source=.upkg/orbit-online/records.sh/records.sh
  source "$pkgroot/.upkg/orbit-online/records.sh/records.sh"

  checkdeps jq docker

  local version image use_tty='' user_uid
  version=$(image-version "$(jq -re '.version // empty' "$pkgroot/upkg.json" 2>/dev/null || git -C "$pkgroot" symbolic-ref HEAD)")
  image="secoya/bitwarden-cli:$version"
  user_uid=$(id -u)

  start_bw() {
    [[ $(docker images -q "$image" 2>/dev/null) != "" ]] || info "Pulling %s" "$image"
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
