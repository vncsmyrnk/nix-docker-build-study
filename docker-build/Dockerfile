# Use a minimal, lightweight base image
FROM nginx:alpine

# Copy our custom Nginx configuration into the image, overwriting the default.
# The official image has a robust default config in nginx.conf; best practice is
# to add our specific server config to the conf.d directory.
COPY sample-project/nginx.conf /etc/nginx/nginx.conf

# Copy our website content into the image.
# The official image serves files from /usr/share/nginx/html by default.
COPY sample-project/index.html /var/www/index.html
