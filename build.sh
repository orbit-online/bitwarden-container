#!/usr/bin/env bash

bitwarden_cli_build() {
  set -eo pipefail
  shopt -s inherit_errexit
  local pkgroot
  pkgroot=$(upkg root "${BASH_SOURCE[0]}")

  local version
  version=$(jq -r '.version' <"$pkgroot/package.json")
  DOCKER_BUILDKIT=1 docker build --tag "secoya/bitwarden-cli:$version" "$pkgroot"
}

bitwarden_cli_build "$@"
