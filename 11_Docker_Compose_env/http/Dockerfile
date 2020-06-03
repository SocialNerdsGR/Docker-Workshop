FROM ubuntu:18.04

# Install libraries and apps.
RUN apt-get update && apt-get install -y --no-install-recommends apache2 ca-certificates nano curl && \
  apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && \
  a2enmod rewrite proxy proxy_http proxy_fcgi headers proxy_wstunnel ssl && \
  useradd -ms /bin/bash serveruser

# Add vhosts and enable sites.
COPY vhosts /etc/apache2/sites-available
RUN cd /etc/apache2/sites-available && a2ensite * && a2dissite default-ssl 000-default

RUN chown -R serveruser:serveruser /home/serveruser

WORKDIR /home/serveruser

CMD ["/usr/sbin/apachectl", "-DFOREGROUND"]
