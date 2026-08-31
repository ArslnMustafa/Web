# Web

Next.js ile geliştirilmiş, Contabo VPS üzerinde çalışan web uygulaması.
`main` dalına her push, GitHub Actions ile VPS'e otomatik olarak dağıtılır.

## Hızlı Başlangıç

```bash
npm install
npm run dev
# http://localhost:3000
```

## Üretim

```bash
npm run build
npm start
```

## Dağıtım

- **CI/CD:** `.github/workflows/deploy.yml` — build + lint, ardından SSH ile deploy.
- **VPS kurulumu:** `deploy/server-setup.sh` (bir kez çalıştırılır).
- **Nginx:** `deploy/nginx.conf`
- **PM2:** `ecosystem.config.js`

Ayrıntılar ve gerekli GitHub Secrets için [`CLAUDE.md`](./CLAUDE.md) dosyasına bakın.
