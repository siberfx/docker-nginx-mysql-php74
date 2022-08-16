FROM php:7.4-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid

RUN apt update && apt install -y \
    software-properties-common \
    unzip \
    zip \
    git \
    wget \
    curl \
    libpq-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev

ADD ./docker/php/default.ini /usr/local/etc/php/conf.d/php.ini

RUN apt clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql mbstring exif bcmath gd \
    && docker-php-ext-configure mysqli \
    && docker-php-ext-install pdo_mysql pdo

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Set working directory
WORKDIR /var/www

USER $user
