#!/usr/bin/env bash
#
# Contabo VPS ilk kurulum scripti (tek seferlik).
# Ubuntu/Debian tabanlı bir sunucuda root veya sudo yetkisiyle çalıştırın:
#
#   bash server-setup.sh
#
set -euo pipefail

APP_DIR="/var/www/web"
NODE_MAJOR="20"

echo "==> Sistem paketleri güncelleniyor"
sudo apt-get update -y

echo "==> Node.js ${NODE_MAJOR}.x kuruluyor"
if ! command -v node >/dev/null 2>&1; then
  curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | sudo -E bash -
  sudo apt-get install -y nodejs
fi

echo "==> Nginx ve git kuruluyor"
sudo apt-get install -y nginx git

echo "==> PM2 global kuruluyor"
sudo npm install -g pm2

echo "==> Uygulama dizini hazırlanıyor: ${APP_DIR}"
sudo mkdir -p "${APP_DIR}"
sudo chown -R "$USER":"$USER" "${APP_DIR}"

echo "==> Repo klonlanıyor (varsa atlanır)"
if [ ! -d "${APP_DIR}/.git" ]; then
  # GITHUB_REPO değişkenini kendi repo URL'nizle çağırın:
  #   GITHUB_REPO=https://github.com/ArslnMustafa/Web.git bash server-setup.sh
  git clone "${GITHUB_REPO:-https://github.com/ArslnMustafa/Web.git}" "${APP_DIR}"
fi

cd "${APP_DIR}"
echo "==> Bağımlılıklar kuruluyor ve build alınıyor"
npm ci
npm run build

echo "==> PM2 ile başlatılıyor"
pm2 start ecosystem.config.js
pm2 save
sudo env PATH="$PATH" pm2 startup systemd -u "$USER" --hp "$HOME" || true

echo "==> Nginx yapılandırılıyor"
sudo cp deploy/nginx.conf /etc/nginx/sites-available/web
sudo ln -sf /etc/nginx/sites-available/web /etc/nginx/sites-enabled/web
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx

echo "==> Kurulum tamamlandı. Site http://<VPS-IP> adresinde yayında."
