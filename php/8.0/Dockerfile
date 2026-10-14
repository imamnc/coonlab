# Use the official PHP image with Apache as the base image
FROM php:8.0-apache

# Install OS dependencies
RUN . /etc/os-release \
    && if [ "$VERSION_CODENAME" = "bullseye" ]; then \
    sed -i 's#http://deb.debian.org/debian-security#http://archive.debian.org/debian-security#' /etc/apt/sources.list; \
    if ls /etc/apt/sources.list.d/*.sources >/dev/null 2>&1; then \
    sed -i 's#http://deb.debian.org/debian-security#http://archive.debian.org/debian-security#' /etc/apt/sources.list.d/*.sources; \
    fi; \
    fi \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    git \
    nano \
    cron \
    supervisor \
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
    gnupg \
    && rm -rf /var/lib/apt/lists/*

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
# Install Redis extension via PECL
# ---------------------------------------------------
RUN pecl install redis \
    && docker-php-ext-enable redis

# ---------------------------------------------------
# Install Composer globally
# ---------------------------------------------------
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configure Apache to serve the shared project root like XAMPP
RUN a2enmod rewrite \
    && echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf \
    && a2enconf servername

COPY apache-default.conf /etc/apache2/sites-available/000-default.conf
COPY php.ini /usr/local/etc/php/conf.d/zz-devcore.ini
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html
EXPOSE 80

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]

# Verify installations
RUN composer --version \
    && node -v \
    && npm -v
