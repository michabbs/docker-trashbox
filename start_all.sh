#!/bin/sh
#
if [ ! -z "$1" ]; then
    exec "$@"
else
    [ "$NOSSL" = "1" ] && touch /nossl
    [ "$NODAV" = "1" ] && touch /nodav

    [ "$NOFTP" = "1" ] || /usr/local/bin/start_vsftpd.sh &
    exec /usr/local/bin/apache2-foreground
fi
