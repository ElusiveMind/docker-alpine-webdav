FROM alpine:3.12

LABEL name="Alpine WebDAV Container"
LABEL author="Michael R. Bagnall <michael@bagnall.io>"

# Based off of:
# https://github.com/donnlee/docker-alpine-webdav

# When running this container, map host's content subdir to /var/webdav
# Eg.: docker run <...> -v /path/to/content:/var/webdav

# Our default port is 80. But if we have specified a different
# port for the sake of proxing or if port 80 is not available,
# then adjust apache's configuration file accordingly. This was
# designed around network_mode: host for our Probo stack.

ENV HOSTPORT=80

# -v : Verbose
# apache2-utils: Needed for htpasswd program.
RUN apk update && \
  apk upgrade && \
  apk --no-cache add \
  bash apache2 apache2-webdav apache2-utils \
  apr-util apr-util-dbm_db

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

CMD ["/run.sh"]
