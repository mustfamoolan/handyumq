#!/bin/sh

# Run composer install if vendor directory is missing
if [ ! -d "vendor" ]; then
    echo "--> Vendor directory missing. Running composer install..."
    composer install --no-interaction --prefer-dist --optimize-autoloader || true
fi

# Setup .env file if missing
if [ ! -f ".env" ]; then
    echo "--> .env file missing. Copying from .env.example..."
    cp .env.example .env || true
    php artisan key:generate --force || true
fi

# Run storage link and migrations
echo "--> Setting up storage link & database migrations..."
php artisan storage:link || true
php artisan migrate --force || true

# Execute original container CMD (php-fpm)
exec "$@"
