export default function Home() {
  return (
    <main
      style={{
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
        minHeight: "100vh",
        textAlign: "center",
        padding: "2rem",
      }}
    >
      <section
        style={{
          background: "var(--card)",
          border: "1px solid rgba(255,255,255,0.08)",
          borderRadius: 20,
          padding: "3rem 2.5rem",
          maxWidth: 640,
          boxShadow: "0 20px 60px rgba(0,0,0,0.35)",
        }}
      >
        <p
          style={{
            color: "var(--accent)",
            fontWeight: 600,
            letterSpacing: 1,
            textTransform: "uppercase",
            fontSize: 13,
          }}
        >
          Next.js · Contabo VPS
        </p>
        <h1 style={{ fontSize: "2.6rem", margin: "0.8rem 0 1rem" }}>
          Web Uygulaması Çalışıyor 🚀
        </h1>
        <p style={{ color: "var(--muted)", fontSize: "1.05rem", lineHeight: 1.6 }}>
          Bu site GitHub&apos;a her push yapıldığında GitHub Actions üzerinden
          Contabo VPS sunucusuna otomatik olarak dağıtılır. Nginx üzerinden
          servis edilir ve PM2 ile ayakta tutulur.
        </p>
        <a
          href="/api/health"
          style={{
            display: "inline-block",
            marginTop: "1.8rem",
            background: "var(--accent)",
            color: "#fff",
            padding: "0.75rem 1.5rem",
            borderRadius: 12,
            textDecoration: "none",
            fontWeight: 600,
          }}
        >
          Sağlık Kontrolü
        </a>
      </section>
    </main>
  );
}
