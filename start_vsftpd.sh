#!/bin/sh

OPT=
[ -n "$EXTERNAL_IP" ] && OPT="$OPT -opasv_address=$EXTERNAL_IP"

if [ -e /etc/apache2/ssl/fullchain.pem -a -e /etc/apache2/ssl/cert.pem -a -e /etc/apache2/ssl/privkey.pem -a "$NOSSL" != "1" ]; then
    OPT="$OPT -ossl_enable=YES"
else
    OPT="$OPT -ossl_enable=NO"
fi

[ "$NOPASV" = "1" ] && OPT="$OPT -opasv_enable=NO"

[ -z "$MIN_PORT" ] && MIN_PORT=21000
[ -z "$MAX_PORT" ] && MAX_PORT=21010

exec /usr/sbin/vsftpd -opasv_min_port=$MIN_PORT -opasv_max_port=$MAX_PORT $OPT
