#!/bin/bash

# Check if the cron file exists
if [ -f /etc/crontabs/jobs ]; then
    echo "Cron file found. Adding to crontab..."
    crontab -u root /etc/crontabs/jobs
    crond
else
    echo "Cron file not found. Skipping crontab setup."
fi

# Check if there are any .ini files in /etc/supervisor.d/
if compgen -G "/etc/supervisor.d/*.ini" > /dev/null; then
    echo "Supervisor .ini files found. Starting supervisord..."
    supervisord -c /etc/supervisord.conf
else
    echo "No Supervisor .ini files found in /etc/supervisor.d/. Skipping supervisord setup."
fi

# Prevent container exit after execution finish
tail -f /dev/null
