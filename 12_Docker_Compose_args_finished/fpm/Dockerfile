FROM php:7.4-fpm

ARG UID=1000

RUN  \
  # User.
  sed -i -e"s/^user\s=\swww-data/user = serveruser/" /usr/local/etc/php-fpm.d/www.conf && \
  sed -i -e"s/^group\s=\swww-data/group = serveruser/" /usr/local/etc/php-fpm.d/www.conf && \
  useradd -ms /bin/bash serveruser -u $UID && \
  # DB.
  docker-php-ext-install pdo_mysql && \
  # libs.
  apt-get update && \
  apt-get install -y \
  libpng-dev libfreetype6-dev libjpeg-dev git wget nano netcat zip unzip zlib1g-dev libzip-dev mariadb-client && \
  # GD.
  docker-php-ext-configure gd --with-freetype --with-jpeg && \
  docker-php-ext-install gd && \
  # Zip.
  docker-php-ext-install zip && \
  # Cache.
  docker-php-ext-configure opcache --enable-opcache && \
  docker-php-ext-install opcache && \
  # Xdebug.
  pecl install xdebug-2.9.4 && \
  docker-php-ext-enable xdebug && \
  # Install composer.
  cd ~ && curl -sS https://getcomposer.org/installer -o composer-setup.php && \
  php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
  rm -rf composer-setup.php && \
  echo "PATH=$PATH:~/.composer/vendor/bin" >> ~/.bashrc

WORKDIR /home/serveruser/code
