# Use the official PHP image with Apache as the base image
# Use Debian 12 (bookworm) because Microsoft SQL Server ODBC packages are
# officially supported on this distro and the Debian 13 repo metadata is not
# currently valid in this build environment.
FROM php:8.5-apache-bookworm

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
    unixodbc \
    unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------
# Install Microsoft SQL Server ODBC driver
# ---------------------------------------------------
RUN set -eux; \
    . /etc/os-release; \
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg; \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" > /etc/apt/sources.list.d/microsoft-prod.list; \
    apt-get update; \
    ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql18; \
    rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------
# Install Node.js (v24 LTS), npm, and pnpm
# ---------------------------------------------------
ENV NODE_VERSION="v24.0.0"
ENV PATH="/usr/local/lib/nodejs/bin:/usr/local/bin:${PATH}"
RUN curl -fsSL https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.xz -o node.tar.xz \
    && mkdir -p /usr/local/lib/nodejs \
    && tar -xJf node.tar.xz -C /usr/local/lib/nodejs --strip-components=1 \
    && rm node.tar.xz \
    && ln -s /usr/local/lib/nodejs/bin/node /usr/bin/node \
    && ln -s /usr/local/lib/nodejs/bin/npm /usr/bin/npm \
    && ln -s /usr/local/lib/nodejs/bin/npx /usr/bin/npx \
    && npm install -g pnpm@latest \
    && ln -sf /usr/local/lib/nodejs/bin/pnpm /usr/local/bin/pnpm

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
    && docker-php-ext-install pcntl \
    && pecl install sqlsrv pdo_sqlsrv \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv

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
    && npm -v \
    && pnpm -v
