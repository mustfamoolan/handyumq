#!/bin/bash
echo "=== Starting Handyman Backend Deployment via Docker ==="

# 1. Start Docker Containers
echo "--> Building and starting Docker containers..."
docker compose up -d --build

# 2. Install Composer Dependencies inside app container
echo "--> Installing Composer dependencies..."
docker exec -it handyman_app composer install --no-interaction --prefer-dist --optimize-autoloader

# 3. Setup Environment File if missing
if [ ! -f .env ]; then
    echo "--> Copying .env.example to .env..."
    cp .env.example .env
    docker exec -it handyman_app php artisan key:generate
fi

# 4. Storage Link & Database Migrations
echo "--> Linking storage and running migrations..."
docker exec -it handyman_app php artisan storage:link
docker exec -it handyman_app php artisan migrate --force
docker exec -it handyman_app php artisan config:cache
docker exec -it handyman_app php artisan route:cache

echo "=== Deployment Completed Successfully! ==="
