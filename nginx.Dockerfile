FROM nginx:alpine

# Copy custom Nginx configuration directly into container
COPY nginx.conf /etc/nginx/conf.d/default.conf
