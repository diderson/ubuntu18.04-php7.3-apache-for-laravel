FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN   apt-get update 
RUN   apt-get install -y software-properties-common    language-pack-en-base sed
RUN LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update && apt-get install -yq --no-install-recommends \
    apt-utils \
    curl \
    # Install git
    git \
    # Install apache
    apache2 \
    # Install php 7.3
    libapache2-mod-php7.3 \
    php7.3-cli \
    php7.3-json \
    php7.3-curl \
    php7.3-fpm \
    php7.3-gd \
    php7.3-ldap \
    php7.3-mbstring \
    php7.3-mysql \
    php7.3-soap \
    php7.3-sqlite3 \
    php7.3-xml \
    php7.3-zip \
    php7.3-intl \
    php-imagick \
    php7.3-GD \
    php7.3-bcmath \
    # Install tools
    openssl \
    nano \
    graphicsmagick \
    imagemagick \
    ghostscript \
    mysql-client \
    iputils-ping \
    locales \
    sqlite3 \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set locales
RUN locale-gen en_US.UTF-8 en_GB.UTF-8 de_DE.UTF-8 es_ES.UTF-8 fr_FR.UTF-8 it_IT.UTF-8 km_KH sv_SE.UTF-8 fi_FI.UTF-8

# Configure PHP for TYPO3
# COPY typo3.ini /etc/php/7.3/mods-available/
# RUN phpenmod typo3
# Configure apache for TYPO3
# RUN a2enmod rewrite expires
# RUN echo "ServerName localhost" | tee /etc/apache2/conf-available/servername.conf
# RUN a2enconf servername
# Configure vhost for TYPO3
# COPY typo3.conf /etc/apache2/sites-available/
# RUN a2dissite 000-default
# RUN a2ensite typo3.conf

COPY 000-default.conf /etc/apache2/sites-available/
RUN a2enmod rewrite

EXPOSE 80 443

WORKDIR /var/www/html

RUN rm index.html

HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD curl -f http://localhost || exit 1

CMD apachectl -D FOREGROUND 