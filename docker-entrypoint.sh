#!/bin/sh

if [ ! -z "$VERBOSE" ]; then
    set -x
fi

/setting-up-users-and-groups.sh /srv/samba/users /srv/samba/groups

exec "$@"
