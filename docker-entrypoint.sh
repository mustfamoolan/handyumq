#!/bin/sh

cd /var/www/html

# Setup .env file if missing or incomplete
if [ ! -f ".env" ]; then
    echo "--> .env file missing. Copying from .env.example..."
    cp .env.example .env || true
fi

# Ensure APP_KEY is set in .env
if ! grep -q "APP_KEY=base64" .env 2>/dev/null; then
    echo "--> Generating APP_KEY..."
    php artisan key:generate --force || true
fi

php artisan config:clear || true
php artisan cache:clear || true

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
