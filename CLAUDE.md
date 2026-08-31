# CLAUDE.md

Bu dosya, bu depoda çalışan Claude Code (ve diğer AI asistanları) için rehberdir.

## Proje Özeti

Next.js (App Router, TypeScript) ile yazılmış bir web uygulaması. Üretim ortamı
olarak **Contabo VPS** kullanılır. Dağıtım, `main` dalına push yapıldığında
**GitHub Actions** üzerinden SSH ile otomatik gerçekleşir. Sunucuda uygulama
**PM2** ile ayakta tutulur ve **Nginx** reverse proxy üzerinden servis edilir.

## Teknoloji Yığını

- **Framework:** Next.js 14 (App Router)
- **Dil:** TypeScript / React 18
- **Süreç yöneticisi (VPS):** PM2
- **Web sunucusu (VPS):** Nginx (reverse proxy, port 80/443 → 3000)
- **CI/CD:** GitHub Actions (`.github/workflows/deploy.yml`)
- **Mimari Tercihler:** Modüler yapıya sadık kal, gereksiz kütüphane ekleme. Bana açıklama yapma, bir sorun olursa kısaca bahset.  

## Dizin Yapısı

```
app/                 Next.js App Router sayfaları ve API route'ları
  layout.tsx         Kök layout
  page.tsx           Ana sayfa
  globals.css        Global stiller
  api/health/route.ts  Sağlık kontrolü endpoint'i (/api/health)
public/              Statik dosyalar
deploy/
  nginx.conf         VPS için Nginx yapılandırması
  server-setup.sh    VPS tek seferlik kurulum scripti
ecosystem.config.js  PM2 yapılandırması
.github/workflows/deploy.yml  Build + SSH deploy pipeline'ı
```

## Sık Kullanılan Komutlar

```bash
npm install      # Bağımlılıkları kur
npm run dev      # Geliştirme sunucusu (http://localhost:3000)
npm run build    # Üretim derlemesi
npm start        # Üretim modunda çalıştır
npm run lint     # ESLint
```

## Dağıtım (Deployment)

### İlk kurulum (VPS'te bir kez)

```bash
GITHUB_REPO=https://github.com/ArslnMustafa/Web.git bash deploy/server-setup.sh
```

Bu script Node.js 20, Nginx, PM2 kurar; repoyu `/var/www/web` içine klonlar,
build alır, PM2 ile başlatır ve Nginx'i yapılandırır.

### Otomatik dağıtım

`main` dalına her push, `.github/workflows/deploy.yml` iş akışını tetikler:
1. Bağımlılıkları kurar, lint ve build çalıştırır.
2. Başarılıysa SSH ile VPS'e bağlanır, repoyu günceller, build alır ve PM2'yi
   yeniden yükler (`pm2 reload`).

### Gerekli GitHub Secrets

Repo → Settings → Secrets and variables → Actions altında tanımlanmalı:

| Secret | Açıklama |
|--------|----------|
| `VPS_HOST` | Contabo VPS IP adresi veya alan adı |
| `VPS_USER` | SSH kullanıcı adı (ör. `root` veya `deploy`) |
| `VPS_SSH_KEY` | VPS'e erişim için özel SSH anahtarı (private key) |
| `VPS_PORT` | SSH portu (genelde `22`) |

## Kurallar / Konvansiyonlar

- Üretim dağıtımı yalnızca `main` dalından yapılır; deneysel çalışma için ayrı
  dal açın.
- Uygulama VPS'te **3000** portunda çalışır; dışarıya Nginx üzerinden 80/443
  ile açılır. Bu portları değiştirirseniz hem `ecosystem.config.js` hem
  `deploy/nginx.conf` güncellenmeli.
- Gizli anahtarları (SSH key, .env) asla depoya commit'lemeyin.
- Değişiklikten sonra push etmeden önce `npm run build` ve `npm run lint`
  yerelde çalıştırılmalı.
