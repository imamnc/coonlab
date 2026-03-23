# Use the official PHP image with Alpine as the base image
FROM php:8.0.3-fpm-alpine

# Install OS packages
RUN apk add --no-cache --virtual .build-deps gcc g++ autoconf libc-dev \
    && apk add --no-cache bash git nano supervisor zlib zlib-dev libzip-dev libpng-dev libjpeg-turbo-dev freetype-dev libwebp-dev curl curl-dev unzip postgresql-dev mariadb-client mariadb-connector-c-dev icu-dev \
    && apk del .build-deps

# Install PHP Extensions
RUN docker-php-ext-configure zip \
    && docker-php-ext-install zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd \
    && docker-php-ext-install curl \
    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-install pgsql \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install intl \
    && apk del --no-cache mariadb-client icu-dev

# Run to reduce image size
RUN rm -rf /var/cache/apk/*

# Switch to bash
SHELL ["/bin/bash", "-c"]

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Download and install Node.js (Musl build) manually
ENV NODE_VERSION="20.6.1"
RUN curl -fsSL https://unofficial-builds.nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64-musl.tar.xz -o node.tar.xz \
    && mkdir -p /usr/local/lib/nodejs \
    && tar -xJf node.tar.xz -C /usr/local/lib/nodejs --strip-components=1 \
    && rm node.tar.xz \
    && ln -s /usr/local/lib/nodejs/bin/node /usr/bin/node \
    && ln -s /usr/local/lib/nodejs/bin/npm /usr/bin/npm \
    && ln -s /usr/local/lib/nodejs/bin/npx /usr/bin/npx

# Verify installations
RUN php --version && composer --version && node --version && npm --version

# Change WORKDIR
WORKDIR /var/www/html

# Shange default php-fpm
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

# Copy the entrypoint script into the container
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Make the script executable
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Set the entrypoint script as the container's entrypoint
CMD ["/usr/local/bin/docker-entrypoint.sh"]