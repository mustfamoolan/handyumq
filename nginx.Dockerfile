FROM nginx:alpine

# Copy custom Nginx configuration directly into container
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy public static files and code so Nginx try_files resolves correctly
COPY . /var/www/html
