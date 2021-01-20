FROM php:apache
LABEL description="Minimalistic public file sharing server - WWW/DAV/FTP."

COPY trashbox.conf /etc/apache2/sites-available/
COPY config.php /var/www/tinyfilemanager/
COPY start_vsftpd.sh /usr/local/bin/
COPY start_all.sh /usr/local/bin/
RUN mkdir -p /var/www/tinyfilemanager /srv/trashbox /var/run/vsftpd/empty && \
    chown www-data:www-data /srv/trashbox && \
    useradd -d /srv/trashbox -g www-data -MNo -s /usr/sbin/nologin -u 33 ftp && \
    apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    apt-get install -y --no-install-recommends wget zip libzip-dev vsftpd && \
    rm -rf /var/lib/apt/lists/* /srv/ftp && \
    docker-php-ext-install zip && \
    wget -q https://raw.githubusercontent.com/prasathmani/tinyfilemanager/master/tinyfilemanager.php -O /var/www/tinyfilemanager/tinyfilemanager.php && \
    a2enmod rewrite dav_fs ssl && \
    a2dissite 000-default && \
    a2ensite trashbox && \
    chmod +x /usr/local/bin/start_vsftpd.sh /usr/local/bin/start_all.sh
COPY vsftpd.conf /etc/

VOLUME /srv/trashbox

#ENV TZ=Europe/Warsaw
#ENV EXTERNAL_IP=1.2.3.4
#ENV MIN_PORT=21000
#ENV MAX_PORT=21010

EXPOSE 80 443
EXPOSE 21 21000-21010

ENTRYPOINT ["/usr/local/bin/start_all.sh"]
