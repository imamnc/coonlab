# Use the official PHP image as the base image
FROM php:8.3-fpm

# Install OS dependencies
RUN apt update && apt install -y \
    git \
    nano \
    zlib1g-dev \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libwebp-dev \
    libcurl4-openssl-dev \
    unzip \
    curl \
    pkg-config \
    libssl-dev \
    re2c \
    default-mysql-client \
    libpq-dev \
    ca-certificates \
    gnupg

# ---------------------------------------------------
# Install Node.js (v20 LTS) & npm
# ---------------------------------------------------
ENV NODE_VERSION="v20.6.1"
RUN curl -fsSL https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.xz -o node.tar.xz \
    && mkdir -p /usr/local/lib/nodejs \
    && tar -xJf node.tar.xz -C /usr/local/lib/nodejs --strip-components=1 \
    && rm node.tar.xz \
    && ln -s /usr/local/lib/nodejs/bin/node /usr/bin/node \
    && ln -s /usr/local/lib/nodejs/bin/npm /usr/bin/npm \
    && ln -s /usr/local/lib/nodejs/bin/npx /usr/bin/npx


# ---------------------------------------------------
# Install PHP extensions
# ---------------------------------------------------
RUN docker-php-ext-configure zip \
    && docker-php-ext-install zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd \
    && docker-php-ext-install curl \
    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-install pgsql \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pcntl

# ---------------------------------------------------
# Install Swoole extension via PECL
# ---------------------------------------------------
RUN pecl install swoole \
    && docker-php-ext-enable swoole

# ---------------------------------------------------
# Install Redis extension via PECL
# ---------------------------------------------------
RUN pecl install redis \
    && docker-php-ext-enable redis

# ---------------------------------------------------
# Install Composer globally
# ---------------------------------------------------
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Verify installations
RUN composer --version \
    && node -v \
    && npm -v
