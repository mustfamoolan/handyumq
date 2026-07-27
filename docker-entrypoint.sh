#!/bin/sh

cd /var/www/html

# Setup .env file if missing
if [ ! -f ".env" ]; then
    echo "--> .env file missing. Copying from .env.example..."
    cp .env.example .env || true
    php artisan key:generate --force || true
fi

# Wait for MySQL database container to finish booting
echo "--> Waiting for MySQL database..."
for i in $(seq 1 15); do
    if php -r "try { new PDO('mysql:host=db;port=3306;dbname=handyman_service', 'handyman', 'handyman_pass'); exit(0); } catch (Exception \$e) { exit(1); }"; then
        echo "--> MySQL is ready!"
        break
    fi
    echo "--> Waiting for MySQL container to finish initializing ($i/15)..."
    sleep 2
done

# Run storage link and migrations
echo "--> Setting up storage link & database migrations..."
php artisan storage:link || true
php artisan migrate --force || true

# Execute original container CMD (php-fpm)
exec "$@"
