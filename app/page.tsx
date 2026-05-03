import { phases, totalWeeks, completedWeeks, completionPct, activeWeeks } from "./data";
import type { Week, Phase } from "./data";
import ThemeToggle from "./ThemeToggle";

/* ── SVG Progress Ring ──────────────────────────────────────────────────────── */
function ProgressRing({ pct, size = 140, stroke = 8, color = "#3b82f6" }: {
  pct: number; size?: number; stroke?: number; color?: string;
}) {
  const r = (size - stroke) / 2;
  const circ = 2 * Math.PI * r;
  const offset = circ - (pct / 100) * circ;
  return (
    <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`} className="drop-shadow-lg">
      <circle className="ring-track" cx={size/2} cy={size/2} r={r} fill="none" strokeWidth={stroke}/>
      <circle
        className="ring-fill"
        cx={size/2} cy={size/2} r={r} fill="none"
        stroke={color} strokeWidth={stroke}
        strokeDasharray={circ}
        strokeDashoffset={offset}
        strokeLinecap="round"
        style={{ transform: "rotate(-90deg)", transformOrigin: "center" }}
      />
    </svg>
  );
}

/* ── Week Row Component ─────────────────────────────────────────────────────── */
function WeekRow({ w }: { w: Week }) {
  return (
    <div className={`week-row ${w.status}`}>
      <div className="flex items-center justify-center pt-0.5">
        <span className="mono text-xs font-bold" style={{
          color: w.status === 'done' ? 'var(--green)' : w.status === 'active' ? 'var(--blue)' : 'var(--text-ghost)'
        }}>
          {String(w.week).padStart(2,'0')}
        </span>
      </div>
      <div className="min-w-0">
        <p className="text-sm font-semibold leading-snug truncate mb-0.5" style={{
          color: w.status === 'pending' ? 'var(--text-ghost)' : 'var(--text)'
        }}>
          {w.topic}
        </p>
        <p className="text-xs truncate" style={{ color: 'var(--text-ghost)', fontSize: '10px' }}>
          <span style={{ color: 'var(--text-label)', fontWeight: 600 }}>LAB</span>{' '}
          <span style={{ color: 'var(--text-dim)' }}>{w.lab}</span>
        </p>
        <p className="text-xs truncate mt-0.5" style={{ color: 'var(--text-ghost)', fontSize: '10px' }}>
          <span style={{ color: 'var(--purple)', opacity: 0.75, fontWeight: 600 }}>INCIDENT</span>{' '}
          <span style={{ color: 'var(--text-dim)' }}>{w.incident}</span>
        </p>
      </div>
      <div className="pt-0.5 flex-shrink-0">
        <div className={`dot dot-${w.status}`} />
      </div>
    </div>
  );
}

/* ── Phase Card ─────────────────────────────────────────────────────────────── */
function PhaseCard({ phase }: { phase: Phase }) {
  const done = phase.weeks.filter(w => w.status === 'done').length;
  const total = phase.weeks.length;
  const pct = Math.round((done / total) * 100);

  return (
    <div className={`glass gradient-border phase-card phase-${phase.id}-accent lift`} style={{ padding: 0 }}>
      {/* Card Header */}
      <div style={{ padding: '20px 20px 16px' }}>
        <div className="flex items-start gap-3 mb-4">
          <div className="phase-icon-ring">{phase.icon}</div>
          <div className="flex-1 min-w-0">
            <span className="phase-badge">Phase {String(phase.id).padStart(2,'0')}</span>
            <h3 className="text-sm font-bold mt-0.5 leading-snug">{phase.name}</h3>
          </div>
        </div>
        {/* Phase progress bar */}
        <div className="flex items-center gap-3 mb-1">
          <div className="pbar flex-1">
            <div className="pbar-fill" style={{
              width: `${pct}%`,
              background: `var(--pa, #3b82f6)`
            }} />
          </div>
          <span className="mono text-xs font-bold" style={{ color: 'var(--pa)', minWidth: '2.5rem', textAlign: 'right' }}>
            {pct}%
          </span>
        </div>
        <p className="text-xs" style={{ color: 'var(--text-dim)', fontFamily: 'JetBrains Mono, monospace' }}>
          {done}/{total} weeks complete
        </p>
      </div>

      {/* Divider */}
      <div className="sep mx-4" />

      {/* Weeks */}
      <div style={{ padding: '8px 8px 12px' }}>
        {phase.weeks.map(w => <WeekRow key={w.week} w={w} />)}
      </div>
    </div>
  );
}

/* ── Main Page ──────────────────────────────────────────────────────────────── */
export default function Dashboard() {
  const pendingWeeks = totalWeeks - completedWeeks - activeWeeks;
  const githubUrl = "https://github.com/Syedabanog-1/DevOps-2026";
  const now = new Date();
  const dateStr = now.toLocaleDateString('en-US',{ weekday:'long', year:'numeric', month:'long', day:'numeric' });

  return (
    <>
      {/* ── Background ── */}
      <div className="bg-canvas" aria-hidden>
        <div className="bg-grid" />
        <div className="bg-orb orb-1" /><div className="bg-orb orb-2" /><div className="bg-orb orb-3" />
      </div>

      {/* ── Topbar ── */}
      <nav className="topbar">
        <div style={{ maxWidth: 1400, margin: '0 auto', padding: '0 24px', height: 56,
          display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <div className="flex items-center gap-3">
            <div className="dot dot-active" />
            <span className="mono text-xs" style={{ color: 'var(--text-dim)' }}>DEVOPS_2026</span>
            <span style={{ color: 'var(--border-hover)' }}>|</span>
            <span className="mono text-xs" style={{ color: 'var(--text-label)' }}>track@syedabanog-1</span>
          </div>
          <div className="flex items-center gap-4">
            <span className="mono text-xs" style={{ color: 'var(--text-label)' }}>{dateStr}</span>
            <a href={githubUrl} target="_blank" rel="noreferrer"
              className="pill pill-active" style={{ textDecoration:'none', padding: '4px 12px' }}>
              <span className="dot dot-active" style={{width:5,height:5}} /> GITHUB
            </a>
            <ThemeToggle />
          </div>
        </div>
      </nav>

      {/* ── Main Content ── */}
      <main style={{ position:'relative', zIndex:1, paddingTop: 56 }}>
        <div style={{ maxWidth: 1400, margin: '0 auto', padding: '60px 24px 100px' }}>

          {/* ── HERO ── */}
          <section style={{ marginBottom: 72 }}>
            {/* Label */}
            <div className="afu" style={{ marginBottom: 20 }}>
              <span className="pill pill-active" style={{ padding: '5px 14px', fontSize: 11 }}>
                <span className="dot dot-active" /> 36-Week Job-Ready DevOps Engineering Track
              </span>
            </div>

            {/* Name */}
            <h1 className="afu d1 shimmer-text"
              style={{ fontSize: 'clamp(3rem,8vw,6.5rem)', fontWeight: 900, letterSpacing: '-0.04em',
                lineHeight: 1.0, marginBottom: 20 }}>
              Syeda Gulzar Bano
            </h1>

            <p className="afu d2" style={{ fontSize: 18, color: 'var(--text-dim)', maxWidth: 640,
              lineHeight: 1.7, marginBottom: 40, fontWeight: 400 }}>
              Autonomous DevOps Architect — mastering Linux, Kubernetes, Terraform, CI/CD, and SRE.
              Every week: theory, hands-on lab, live incident simulation, formal RCA.
            </p>

            {/* CTA Row */}
            <div className="afu d3 flex items-center gap-4 flex-wrap" style={{ marginBottom: 0 }}>
              <a href={githubUrl} target="_blank" rel="noreferrer"
                className="glass lift"
                style={{ padding: '12px 24px', borderRadius: 12, textDecoration: 'none',
                  display: 'inline-flex', alignItems: 'center', gap: 10, fontWeight: 700, fontSize: 14 }}>
                <svg style={{width:18,height:18}} fill="currentColor" viewBox="0 0 24 24">
                  <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0 0 24 12c0-6.63-5.37-12-12-12z"/>
                </svg>
                View Repository
              </a>
              <div className="terminal" style={{ padding: '8px 16px', borderRadius: 10, display:'inline-flex', alignItems:'center', gap:6 }}>
                <span className="term-green">$</span>
                <span className="term-dim">wsl bash</span>
                <span className="term-blue"> Week-09/lab-day2-python.sh</span>
                <span className="cursor" />
              </div>
            </div>
          </section>

          {/* ── STATS ROW ── */}
          <section style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit,minmax(200px,1fr))', gap: 16, marginBottom: 64 }}>
            {/* Overall Progress Ring Card */}
            <div className="glass gradient-border stat-card sa-blue afu d2 lift"
              style={{ gridColumn: 'span 1', display: 'flex', alignItems: 'center', gap: 20 }}>
              <div style={{ position: 'relative', flexShrink: 0 }}>
                <ProgressRing pct={completionPct} size={100} stroke={7} color="#3b82f6" />
                <div style={{ position: 'absolute', inset: 0, display:'flex', flexDirection:'column',
                  alignItems:'center', justifyContent:'center' }}>
                  <span style={{ fontSize: 22, fontWeight: 900, lineHeight: 1 }}>{completionPct}%</span>
                </div>
              </div>
              <div>
                <p className="mono" style={{ color: '#475569', fontSize: 10, textTransform:'uppercase', letterSpacing:'.08em', marginBottom: 4 }}>Overall</p>
                <h3 style={{ fontSize: 26, fontWeight: 800 }}>{completedWeeks}<span style={{ fontSize:14, fontWeight:400, color:'#475569' }}>/{totalWeeks} wks</span></h3>
                <p style={{ fontSize: 11, color: '#334155', marginTop: 4 }}>Phases 1 & 2 complete</p>
              </div>
            </div>

            <div className="glass gradient-border stat-card sa-green afu d3 lift">
              <p className="mono" style={{ color:'var(--text-dim)', fontSize:10, textTransform:'uppercase', letterSpacing:'.08em', marginBottom:8 }}>Completed</p>
              <h3 style={{ fontSize: 42, fontWeight: 900, color: 'var(--green)', lineHeight: 1, marginBottom: 4 }}>{completedWeeks}</h3>
              <p style={{ color:'var(--text-label)', fontSize:12 }}>Weeks fully executed in WSL</p>
              <div className="pbar" style={{ marginTop: 14 }}>
                <div className="pbar-fill" style={{ width:`${completionPct}%`, background:'var(--green)' }} />
              </div>
            </div>

            <div className="glass gradient-border stat-card sa-purple afu d4 lift">
              <p className="mono" style={{ color:'var(--text-dim)', fontSize:10, textTransform:'uppercase', letterSpacing:'.08em', marginBottom:8 }}>Active Now</p>
              <h3 style={{ fontSize: 42, fontWeight: 900, color: 'var(--purple)', lineHeight: 1, marginBottom: 4 }}>{activeWeeks}</h3>
              <p style={{ color:'var(--text-label)', fontSize:12 }}>Phase 3 — Python &amp; Automation</p>
              <div style={{ marginTop: 14 }}>
                <span className="pill pill-active">In Progress</span>
              </div>
            </div>

            <div className="glass gradient-border stat-card sa-gold afu d5 lift">
              <p className="mono" style={{ color:'var(--text-dim)', fontSize:10, textTransform:'uppercase', letterSpacing:'.08em', marginBottom:8 }}>Remaining</p>
              <h3 style={{ fontSize: 42, fontWeight: 900, lineHeight: 1, marginBottom: 4 }}>
                <span className="g-gold text-grad">{pendingWeeks}</span>
              </h3>
              <p style={{ color:'var(--text-label)', fontSize:12 }}>Weeks scheduled (Phases 3→9)</p>
              <div className="pbar" style={{ marginTop: 14 }}>
                <div className="pbar-fill" style={{ width:`${(pendingWeeks/totalWeeks)*100}%`, background:'#f59e0b', opacity: 0.5 }} />
              </div>
            </div>

            {/* GitHub Stats */}
            <div className="glass gradient-border stat-card afu d6 lift" style={{ gridColumn: 'span 1' }}>
              <p className="mono" style={{ color:'var(--text-dim)', fontSize:10, textTransform:'uppercase', letterSpacing:'.08em', marginBottom:10 }}>Repository</p>
              <div className="terminal" style={{ padding: '10px 14px' }}>
                <p><span className="term-dim">repo</span>  <span className="term-blue">DevOps-2026</span></p>
                <p><span className="term-dim">user</span>  <span className="term-green">Syedabanog-1</span></p>
                <p><span className="term-dim">files</span> <span className="term-amber">108 scripts</span></p>
                <p><span className="term-dim">ci</span>    <span className="term-green">✓ passing</span></p>
              </div>
            </div>
          </section>

          {/* ── SECTION DIVIDER ── */}
          <div className="flex items-center gap-4" style={{ marginBottom: 40 }}>
            <div className="sep flex-1" />
            <span className="mono text-xs" style={{ color:'var(--text-ghost)', letterSpacing:'.12em' }}>ALL 9 PHASES · 36 WEEKS</span>
            <div className="sep flex-1" />
          </div>

          {/* ── PHASE GRID ── */}
          <section style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fill, minmax(340px,1fr))',
            gap: 20,
            marginBottom: 80
          }}>
            {phases.map((ph, i) => (
              <div key={ph.id} className={`afu d${Math.min(i+1,8)}`}>
                <PhaseCard phase={ph} />
              </div>
            ))}
          </section>

          {/* ── TERMINAL SECTION ── */}
          <section className="afu" style={{ marginBottom: 80 }}>
            <h2 style={{ fontWeight:800, fontSize:22, marginBottom:16 }}>
              Execution Environment{' '}
              <span className="g-cyan text-grad">↗</span>
            </h2>
            <div className="glass gradient-border" style={{ padding: 0, overflow: 'hidden' }}>
              {/* window chrome */}
              <div style={{ padding: '10px 16px', borderBottom: '1px solid var(--border-subtle)',
                display:'flex', alignItems:'center', gap: 8 }}>
                <div style={{width:10,height:10,borderRadius:'50%',background:'#ef4444',opacity:.7}} />
                <div style={{width:10,height:10,borderRadius:'50%',background:'#f59e0b',opacity:.7}} />
                <div style={{width:10,height:10,borderRadius:'50%',background:'#10b981',opacity:.7}} />
                <span className="mono" style={{ color:'var(--text-label)', fontSize:11, marginLeft:8 }}>
                  wsl2 — bash — devops-2026
                </span>
              </div>
              <div className="terminal" style={{ borderRadius:0, border:'none', padding:'20px 24px' }}>
                <p><span className="term-dim"># Phase 1-2 complete. Running Phase 3 now.</span></p>
                <p><span className="term-green">✔</span> <span className="term-dim">Week 01-08 labs executed and committed to git</span></p>
                <p><span className="term-green">✔</span> <span className="term-dim">All RCA documents generated in /tmp/devops2026-*/</span></p>
                <p><span className="term-green">✔</span> <span className="term-dim">GitHub CI pipeline: shellcheck + yamllint + gitleaks PASSING</span></p>
                <p><span className="term-amber">→</span> <span className="term-blue">wsl bash Week-09/lab-day2-python.sh</span></p>
                <p><span className="term-amber">→</span> <span className="term-blue">wsl bash Week-09/incident-day3-broken-script.sh</span></p>
                <p><span className="term-dim">  Executing Python DevOps automation lab...</span><span className="cursor" /></p>
              </div>
            </div>
          </section>

          {/* ── FOOTER ── */}
          <footer className="afu">
            <div className="sep" style={{ marginBottom: 32 }} />
            <div style={{ display:'flex', flexWrap:'wrap', justifyContent:'space-between', alignItems:'center', gap: 16 }}>
              <div style={{ display:'flex', alignItems:'center', gap: 12 }}>
                <div className="phase-icon-ring" style={{ width:36, height:36, borderRadius:10, fontSize:16, background:'rgba(59,130,246,.12)' }}>
                  ⚡
                </div>
                <div>
                  <p style={{ fontWeight:700, fontSize:14 }}>Syeda Gulzar Bano</p>
                  <p className="mono" style={{ color:'var(--text-label)', fontSize:10 }}>DevOps Engineer 2026 · @Syedabanog-1</p>
                </div>
              </div>
              <div className="flex items-center gap-4">
                <a href={githubUrl} target="_blank" rel="noreferrer"
                  className="pill pill-active" style={{ textDecoration:'none' }}>
                  GitHub Repo
                </a>
                <span className="mono" style={{ color:'var(--text-ghost)', fontSize:10 }}>
                  Deployed on Vercel · Built with Next.js 15
                </span>
              </div>
            </div>
          </footer>

        </div>
      </main>
    </>
  );
}
