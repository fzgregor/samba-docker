#!/bin/sh

if [ ! -z "$VERBOSE" ]; then
    set -x
fi
set -e

filename="$1"
while IFS='' read -r line
do
    name=`echo ${line} | cut -d' ' -f1`
    uid=`echo ${line} | cut -d' ' -f2`
    pass_starts=`expr ${#name} + ${#uid} + 3`
    password=`echo ${line} | cut -b${pass_starts}-`
    echo "Creating user ${name} with uid ${uid}"
    cat /etc/passwd | grep "${name}:x:${uid}:" > /dev/null && deluser ${name} > /dev/null
    adduser -DH -u ${uid} -h / -s /sbin/nologin ${name}
    echo -e "${password}\n${password}" | smbpasswd -s -c /srv/samba/smb.conf -a ${name}
done < "$filename"

filename="$2"
while IFS='' read -r line
do
    group=`echo ${line} | cut -d' ' -f1`
    gid=`echo ${line} | cut -d' ' -f2`
    echo "Creating group ${group} with gid ${gid}"
    cat /etc/group | grep "${group}:x:${gid}" > /dev/null && delgroup ${group} > /dev/null
    addgroup -g ${gid} ${group}

    users_starts=`expr ${#group} + ${#gid} + 3`
    users=`echo ${line} | cut -b${users_starts}-`
    for user in ${users}; do
        echo "Adding user ${user} to group ${group}"
        addgroup ${user} ${group}
    done
done < "$filename"
