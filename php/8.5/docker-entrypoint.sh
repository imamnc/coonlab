#!/bin/bash
set -e

# Check if the cron file exists
if [ -f /etc/crontabs/jobs ]; then
    echo "Cron file found. Adding to crontab..."
    crontab -u root /etc/crontabs/jobs

    if command -v cron >/dev/null 2>&1; then
        cron
    elif command -v crond >/dev/null 2>&1; then
        crond
    else
        echo "Cron binary not found. Skipping cron daemon startup."
    fi
else
    echo "Cron file not found. Skipping crontab setup."
fi

# Supervisor is only relevant when the PHP-FPM binary exists. The Apache-based
# PHP 8.5 image intentionally does not ship php-fpm, so the stale FPM config
# must be ignored to keep the container starting correctly.
if command -v supervisord >/dev/null 2>&1 && command -v php-fpm >/dev/null 2>&1 && compgen -G "/etc/supervisor.d/*.ini" > /dev/null; then
    echo "Supervisor .ini files found and php-fpm detected. Preparing supervisord config..."
    mkdir -p /etc/supervisor.d

    if [ ! -f /etc/supervisord.conf ]; then
        cat > /etc/supervisord.conf <<'EOF'
[unix_http_server]
file=/tmp/supervisor.sock

[supervisord]
logfile=/tmp/supervisord.log
pidfile=/tmp/supervisord.pid
nodaemon=true
silent=false

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///tmp/supervisor.sock

[include]
files = /etc/supervisor.d/*.ini
EOF
    fi

    supervisord -c /etc/supervisord.conf
else
    echo "php-fpm or Supervisor config not present. Skipping supervisord setup."
fi

# Start Apache in the foreground so the container stays alive and remains
# accessible at http://localhost:8383 from the host.
echo "Starting Apache HTTP server..."
exec apache2-foreground
