#!/usr/bin/env bash
set -euo pipefail
# Configura el servidor HTTPS de Infraestructura 2. Ejecutar como root/sudo en Ubuntu.
apt-get update
apt-get install -y nginx openssl
mkdir -p /etc/nginx/ssl
openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
  -keyout /etc/nginx/ssl/server.key \
  -out /etc/nginx/ssl/server.crt \
  -subj "/CN=10.6.93.130"
cat >/etc/nginx/sites-available/default <<'EOF'
server {
    listen 443 ssl default_server;
    ssl_certificate /etc/nginx/ssl/server.crt;
    ssl_certificate_key /etc/nginx/ssl/server.key;
    root /var/www/html;
    index index.html;
}
EOF
echo '<h1>Servidor Web HTTPS - 2025-0693 - Infra 2</h1>' >/var/www/html/index.html
nginx -t
systemctl enable --now nginx
