#!/bin/bash
set -e

# Update system
apt-get update
apt-get install -y nginx

# Configure Nginx as reverse proxy
cat > /etc/nginx/sites-available/default << 'NGINX_CONF'
upstream app_servers {
    server 10.0.2.4:8080;
    server 10.0.2.5:8080;
}

server {
    listen 80 default_server;
    listen [::]:80 default_server;

    location / {
        proxy_pass http://app_servers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /health {
        return 200 "Web Server OK";
        add_header Content-Type text/plain;
    }
}
NGINX_CONF

# Start and enable Nginx
systemctl restart nginx
systemctl enable nginx

echo "Web server setup completed" > /tmp/web-setup.log