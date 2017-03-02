FROM armhf/alpine:3.5

RUN apk add --no-cache samba

COPY setting-up-users-and-groups.sh docker-entrypoint.sh /

# port for samba over NetBIOS over TCP
EXPOSE 139

# port for samba over TCP
EXPOSE 445

VOLUME /srv/samba

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD smbd -FS -s /srv/samba/smb.conf
