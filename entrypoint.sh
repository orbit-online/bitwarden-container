#!/usr/bin/env sh
adduser -DHh "$HOME" -s /bin/sh -u "$USER_UID" user 1> /dev/null 2>&1
exec /pause
