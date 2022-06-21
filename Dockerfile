FROM alpine:3.12

# When running this container, map host's content subdir to /var/webdav
# Eg.: docker run <...> -v /path/to/content:/var/webdav

# -v : Verbose
# apache2-utils: Needed for htpasswd program.
RUN apk -v --no-cache add \
  bash apache2 apache2-webdav apache2-utils apr-util apr-util-dbm_db

# Create a subdir for webdav lockdb file.
RUN mkdir -p /var/lib/dav \
  && chown apache:apache /var/lib/dav \
  && chmod 755 /var/lib/dav

# Create a subdir to hold the daemon's pid:
RUN mkdir -p /run/apache2

ADD httpd.conf /etc/apache2/httpd.conf
ADD dav.conf /etc/apache2/conf.d/
ADD run.sh /
RUN chmod 750 /run.sh

EXPOSE 8114

CMD ["/run.sh"]

