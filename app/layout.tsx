import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "DevOps 2026 | Syeda Gulzar Bano — 36-Week Engineering Track",
  description:
    "A production-grade, autonomous 36-week DevOps engineering curriculum tracking progress across Linux, Git, Docker, Kubernetes, Terraform, CI/CD, Monitoring, and SRE.",
  keywords: ["DevOps", "Kubernetes", "Terraform", "Docker", "CI/CD", "Azure", "SRE"],
  authors: [{ name: "Syeda Gulzar Bano", url: "https://github.com/Syedabanog-1" }],
  openGraph: {
    title: "DevOps 2026 | 36-Week Job-Ready Engineering Track",
    description: "Full-stack DevOps curriculum covering Linux → Kubernetes → SRE",
    type: "website",
  },
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" suppressHydrationWarning>
      <head>
        {/* ── Anti-FOUC: set data-theme before first paint ── */}
        <script
          dangerouslySetInnerHTML={{
            __html: `
(function(){
  try{
    var s = localStorage.getItem('theme');
    var t = s === 'dark' || s === 'light'
      ? s
      : window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
    document.documentElement.setAttribute('data-theme', t);
  }catch(e){}
})();
`,
          }}
        />
      </head>
      <body>{children}</body>
    </html>
  );
}
