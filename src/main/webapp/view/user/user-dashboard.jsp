<%-- 
    Document   : user-dashboard
    Created on : May 18, 2026, 1:58:37 PM
    Author     : FPTShop
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
  <!doctype html>
  <html lang="vi" data-theme="light">
  <head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Quản lý kho — Bảng điều khiển</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="assets/css/variables.css">
  <link rel="stylesheet" href="assets/css/base.css">
  <link rel="stylesheet" href="assets/css/sidebar.css">
  <style>
    .kpis { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; }
    .kpi { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 14px 16px 16px; }
    .kpi .label { display: flex; align-items: center; justify-content: space-between; font-size: 11.5px; color: var(--muted); font-weight: 500; letter-spacing: 0.01em; margin-bottom: 10px; }
    .kpi .label .dot { width: 6px; height: 6px; border-radius: 50%; background: var(--muted); }
    .kpi .value { font-family: var(--font-mono); font-size: 24px; font-weight: 600; letter-spacing: -0.02em; line-height: 1.1; color: var(--fg); }
    .kpi .value .unit { font-size: 13px; font-weight: 500; color: var(--muted); margin-inline-start: 4px; }
    .kpi .delta { margin-top: 8px; display: flex; align-items: center; gap: 8px; font-size: 12px; color: var(--muted); }
    .delta .change { display: inline-flex; align-items: center; gap: 2px; font-family: var(--font-mono); font-weight: 500; padding: 1px 6px; border-radius: 3px; font-size: 11.5px; }
    .change.up { color: var(--accent); background: var(--accent-soft); }
    .change.down { color: var(--danger); background: var(--danger-soft); }
    .change.flat { color: var(--muted); background: var(--surface-2); }
    .kpi .spark { margin-top: 12px; height: 32px; }

    .grid-2 { display: grid; grid-template-columns: minmax(0, 2fr) minmax(0, 1fr); gap: 12px; }

    .chart { width: 100%; height: 240px; }
    .chart-legend { display: flex; align-items: center; gap: 20px; margin-top: 4px; padding: 0 4px; font-size: 12px; color: var(--muted); }
    .legend-item { display: inline-flex; align-items: center; gap: 6px; }
    .legend-swatch { width: 10px; height: 2px; border-radius: 2px; }

    .tx-list { display: flex; flex-direction: column; }
    .tx { display: grid; grid-template-columns: 28px 1fr auto; gap: 12px; align-items: center; padding: 10px 0; border-bottom: 1px dashed var(--border); }
    .tx:last-child { border-bottom: 0; }
    .tx-icon { width: 28px; height: 28px; border-radius: 6px; display: grid; place-items: center; background: var(--surface-2); border: 1px solid var(--border); }
    .tx-icon svg { width: 13px; height: 13px; stroke: currentColor; fill: none; stroke-width: 1.8; }
    .tx-icon.in, .tx-icon.out, .tx-icon.move { color: var(--muted-2); background: var(--surface-2); border-color: var(--border); }
    .tx-body { line-height: 1.3; min-width: 0; }
    .tx-title { font-size: 13px; font-weight: 500; }
    .tx-sub { font-size: 11.5px; color: var(--muted); font-family: var(--font-mono); }
    .tx-amount { text-align: end; font-family: var(--font-mono); font-size: 13px; font-weight: 500; }
    .tx-amount .when { display: block; font-size: 10.5px; color: var(--muted-2); font-weight: 400; }

    table.inv { width: 100%; border-collapse: collapse; font-size: 13px; }
    table.inv th, table.inv td { text-align: start; padding: 10px 16px; border-bottom: 1px solid var(--border); }
    table.inv th { font-size: 11px; font-weight: 600; color: var(--muted); text-transform: uppercase; letter-spacing: 0.04em; background: var(--surface-2); border-bottom: 1px solid var(--border-strong); border-top: 1px solid var(--border); }
    table.inv tbody tr:hover { background: var(--surface-2); }
    table.inv td { vertical-align: middle; }
    td.num, th.num { text-align: end; font-family: var(--font-mono); }
    .sku { font-family: var(--font-mono); font-size: 12px; color: var(--muted); }
    .product { font-weight: 500; }
    .product-sub { font-size: 11.5px; color: var(--muted); margin-top: 2px; }


    .alerts { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; }
    .alert { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 14px 16px; display: flex; gap: 12px; align-items: flex-start; }
    .alert-icon { width: 30px; height: 30px; border-radius: 6px; display: grid; place-items: center; flex-shrink: 0; }
    .alert-icon svg { width: 15px; height: 15px; stroke: currentColor; fill: none; stroke-width: 1.8; }
    .alert.warn .alert-icon, .alert.danger .alert-icon, .alert.info .alert-icon { background: var(--surface-2); color: var(--muted-2); }
    .alert-body { flex: 1; min-width: 0; }
    .alert-title { font-size: 13px; font-weight: 600; display: flex; align-items: center; gap: 8px; }
    .alert-title .count { font-family: var(--font-mono); font-size: 11px; padding: 1px 6px; border-radius: 3px; background: var(--surface-2); color: var(--fg-soft); border: 1px solid var(--border); font-weight: 500; }
    .alert-desc { font-size: 12px; color: var(--muted); margin-top: 4px; line-height: 1.45; }
    .alert-cta { margin-top: 8px; font-size: 12px; color: var(--fg); font-weight: 500; text-decoration: none; display: inline-flex; align-items: center; gap: 4px; border-bottom: 1px solid var(--border-strong); padding-bottom: 1px; }
    .alert-cta:hover { color: var(--accent); border-color: var(--accent); }

    .foot { margin-top: 28px; padding-top: 14px; border-top: 1px solid var(--border); color: var(--muted); font-size: 11.5px; font-family: var(--font-mono); display: flex; justify-content: space-between; }

    @media (max-width: 1280px) {
      .kpis { grid-template-columns: repeat(2, 1fr); }
      .alerts { grid-template-columns: 1fr; }
    }
  </style>
  </head>
  <body>
  <div class="app">

    <aside class="sidebar" data-od-id="sidebar">
      <div class="brand">
        <div class="brand-mark">WH</div>
        <div>Warehouse OS</div>
      </div>

      <nav class="nav">
        <div class="nav-section">Tổng quan</div>
        <a href="index.html">
          <svg class="icon" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
          Bảng điều khiển
        </a>
        <a href="#">
          <svg class="icon" viewBox="0 0 24 24"><path d="M3 7l9-4 9 4-9 4z"/><path d="M3 7v10l9 4 9-4V7"/><path d="M12 11v10"/></svg>
          Tồn kho
          <span class="count">12.4k</span>
        </a>
        <a href="#">
          <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M3 12h18M3 18h12"/></svg>
          Phiếu nhập/xuất
          <span class="count">23</span>
        </a>
        <a href="#">
          <svg class="icon" viewBox="0 0 24 24"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
          Đơn hàng
        </a>

        <div class="nav-section">Quản trị</div>
        <a href="admin-users.html">
          <svg class="icon" viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><path d="M20 8v6M23 11h-6"/></svg>
          Người dùng
          <span class="count">142</span>
        </a>
        <a href="rbac-roles.html">
          <svg class="icon" viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
          Phân quyền
        </a>
        <a href="#">
          <svg class="icon" viewBox="0 0 24 24"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
          Nhà cung cấp
        </a>
        <a href="#">
          <svg class="icon" viewBox="0 0 24 24"><path d="M20 7l-8 4-8-4M4 7l8 4 8-4M4 7v10l8 4 8-4V7"/></svg>
          Kho &amp; vị trí
        </a>

        <div class="nav-section">Tài khoản</div>
        <a href="profile.html">
          <svg class="icon" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
          Hồ sơ của tôi
        </a>
        <a href="change-password.html">
          <svg class="icon" viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
          Đổi mật khẩu
        </a>
        <a href="#">
          <svg class="icon" viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09a1.65 1.65 0 0 0-1-1.51 1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09a1.65 1.65 0 0 0 1.51-1 1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33h0a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82v0a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
          Cài đặt
        </a>

        <div class="nav-section">Báo cáo</div>
        <a href="#">
          <svg class="icon" viewBox="0 0 24 24"><path d="M3 3v18h18"/><path d="M7 14l4-4 4 4 5-5"/></svg>
          Phân tích
        </a>
      </nav>

      <div class="sidebar-footer">
        <div class="avatar">MH</div>
        <div class="user-meta">
          <div class="name">Mai Hoàng</div>
          <div class="role">Quản lý kho · HN-01</div>
        </div>
      </div>
    </aside>

    <div>
      <header class="topbar" data-od-id="topbar">
        <h1>Bảng điều khiển</h1>
        <span class="crumb">/ Kho HN-01 · Hôm nay</span>

        <div class="search">
          <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
          <input placeholder="Tìm mã hàng, phiếu, nhà cung cấp…" />
          <kbd>⌘K</kbd>
        </div>

        <div class="top-actions">
          <button class="icon-btn" title="Thông báo">
            <svg viewBox="0 0 24 24"><path d="M18 8a6 6 0 0 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
          </button>
          <button class="btn btn-primary">
            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
            Tạo phiếu
          </button>
        </div>
      </header>

      <main>

        <section data-od-id="kpis">
          <div class="kpis">
            <div class="kpi">
              <div class="label">Tổng mã hàng đang quản lý <span class="dot"></span></div>
              <div class="value mono">12,438</div>
              <div class="delta">
                <span class="change up">▲ 1.8%</span>
                so với tuần trước
              </div>
              <svg class="spark" viewBox="0 0 120 32" preserveAspectRatio="none">
                <polyline points="0,24 12,22 24,20 36,21 48,18 60,16 72,14 84,15 96,11 108,9 120,7" fill="none" stroke="var(--muted)" stroke-width="1.6"/>
                <polyline points="0,24 12,22 24,20 36,21 48,18 60,16 72,14 84,15 96,11 108,9 120,7 120,32 0,32" fill="var(--muted)" opacity="0.12"/>
              </svg>
            </div>

            <div class="kpi">
              <div class="label">Tổng tồn kho (đơn vị)</div>
              <div class="value mono">348,920 <span class="unit">chiếc</span></div>
              <div class="delta">
                <span class="change down">▼ 4.2%</span>
                so với đầu tháng
              </div>
              <svg class="spark" viewBox="0 0 120 32" preserveAspectRatio="none">
                <polyline points="0,10 12,11 24,13 36,12 48,15 60,17 72,19 84,18 96,21 108,23 120,25" fill="none" stroke="var(--muted)" stroke-width="1.6"/>
              </svg>
            </div>

            <div class="kpi">
              <div class="label">Giá trị tồn kho</div>
              <div class="value mono">8.42<span class="unit">tỷ ₫</span></div>
              <div class="delta">
                <span class="change up">▲ 320 triệu</span>
                tháng này
              </div>
              <svg class="spark" viewBox="0 0 120 32" preserveAspectRatio="none">
                <polyline points="0,22 12,20 24,21 36,18 48,17 60,15 72,17 84,13 96,12 108,10 120,8" fill="none" stroke="var(--muted)" stroke-width="1.6"/>
              </svg>
            </div>

            <div class="kpi">
              <div class="label">Mã hàng sắp hết</div>
              <div class="value mono">47</div>
              <div class="delta">
                <span class="change down">▲ 12</span>
                cần đặt hàng tuần này
              </div>
              <svg class="spark" viewBox="0 0 120 32" preserveAspectRatio="none">
                <polyline points="0,28 12,26 24,27 36,24 48,22 60,20 72,17 84,15 96,12 108,9 120,6" fill="none" stroke="var(--muted)" stroke-width="1.6"/>
              </svg>
            </div>
          </div>
        </section>

        <div class="section-head">
          <h2>Hoạt động kho — 14 ngày qua</h2>
          <span class="meta">28/04 – 12/05/2026</span>
        </div>

        <section class="grid-2" data-od-id="activity">
          <div class="card">
            <div class="card-head">
              <div>
                <h3>Nhập / Xuất kho</h3>
                <div class="sub" style="margin-top:2px">Đơn vị: nghìn chiếc</div>
              </div>
              <div class="tabs">
                <button class="tab">7N</button>
                <button class="tab active">14N</button>
                <button class="tab">30N</button>
                <button class="tab">Quý này</button>
              </div>
            </div>
            <div class="card-body">
              <svg class="chart" viewBox="0 0 720 240" preserveAspectRatio="none">
                <g stroke="var(--border)" stroke-width="1">
                  <line x1="40" y1="20" x2="710" y2="20"/>
                  <line x1="40" y1="70" x2="710" y2="70" stroke-dasharray="2,3"/>
                  <line x1="40" y1="120" x2="710" y2="120" stroke-dasharray="2,3"/>
                  <line x1="40" y1="170" x2="710" y2="170" stroke-dasharray="2,3"/>
                  <line x1="40" y1="220" x2="710" y2="220"/>
                </g>
                <g font-family="var(--font-mono)" font-size="10" fill="var(--muted)" text-anchor="end">
                  <text x="34" y="24">40</text>
                  <text x="34" y="74">30</text>
                  <text x="34" y="124">20</text>
                  <text x="34" y="174">10</text>
                  <text x="34" y="224">0</text>
                </g>
                <g font-family="var(--font-mono)" font-size="10" fill="var(--muted)" text-anchor="middle">
                  <text x="60" y="236">28/4</text>
                  <text x="155" y="236">01/5</text>
                  <text x="250" y="236">04/5</text>
                  <text x="345" y="236">07/5</text>
                  <text x="440" y="236">10/5</text>
                  <text x="535" y="236">12/5</text>
                </g>
                <polyline points="60,160 108,140 155,150 203,120 250,110 298,135 345,95 393,110 440,80 488,90 535,70 583,95 630,75 678,60" fill="none" stroke="var(--muted)" stroke-width="2"/>
                <polyline points="60,160 108,140 155,150 203,120 250,110 298,135 345,95 393,110 440,80 488,90 535,70 583,95 630,75 678,60 678,220 60,220" fill="var(--muted)" opacity="0.10"/>
                <polyline points="60,180 108,170 155,165 203,160 250,140 298,150 345,130 393,140 440,120 488,135 535,110 583,125 630,105 678,115" fill="none" stroke="var(--muted)" stroke-width="2" stroke-dasharray="3,3"/>
                <g fill="var(--muted)">
                  <circle cx="678" cy="60" r="3.5"/>
                  <circle cx="678" cy="60" r="6" fill="var(--muted)" opacity="0.25"/>
                </g>
                <g fill="var(--muted)">
                  <circle cx="678" cy="115" r="2.5"/>
                </g>
                <g transform="translate(630, 38)">
                  <rect x="0" y="0" width="78" height="20" rx="3" fill="var(--surface-2)" stroke="var(--border)"/>
                  <text x="6" y="14" font-family="var(--font-mono)" font-size="11" fill="var(--fg)">38,2k chiếc</text>
                </g>
              </svg>
              <div class="chart-legend">
                <span class="legend-item"><span class="legend-swatch" style="background:var(--muted)"></span>Nhập kho · 412k chiếc</span>
                <span class="legend-item"><span class="legend-swatch" style="background:var(--muted); height:2px; border-top: 1px dashed var(--muted)"></span>Xuất kho · 367k chiếc</span>
                <span class="legend-item" style="margin-inline-start:auto"><span class="mono" style="font-weight:600">+45,2k</span> tồn ròng</span>
              </div>
            </div>
          </div>

          <div class="card">
            <div class="card-head">
              <h3>Giao dịch gần đây</h3>
              <a href="#" style="font-size:12px;color:var(--muted);text-decoration:none">Xem tất cả →</a>
            </div>
            <div class="card-body">
              <div class="tx-list">

                <div class="tx">
                  <div class="tx-icon in"><svg viewBox="0 0 24 24"><path d="M12 5v14M5 12l7 7 7-7"/></svg></div>
                  <div class="tx-body">
                    <div class="tx-title">Nhập kho — Cà phê Trung Nguyên G7</div>
                    <div class="tx-sub">PN-2645 · NCC: Trung Nguyên · 540 thùng</div>
                  </div>
                  <div class="tx-amount">+540<span class="when">12/05 · 09:42</span></div>
                </div>

                <div class="tx">
                  <div class="tx-icon out"><svg viewBox="0 0 24 24"><path d="M12 19V5M19 12l-7-7-7 7"/></svg></div>
                  <div class="tx-body">
                    <div class="tx-title">Xuất kho — Sữa Vinamilk 1L</div>
                    <div class="tx-sub">PX-1183 · KH: Coopmart Hà Đông · 1,200 thùng</div>
                  </div>
                  <div class="tx-amount">−1,200<span class="when">12/05 · 08:15</span></div>
                </div>

                <div class="tx">
                  <div class="tx-icon move"><svg viewBox="0 0 24 24"><path d="M3 12h12M11 6l6 6-6 6"/></svg></div>
                  <div class="tx-body">
                    <div class="tx-title">Chuyển kho — Bột giặt OMO 2kg</div>
                    <div class="tx-sub">CK-0892 · HN-01 → HCM-03 · 380 thùng</div>
                  </div>
                  <div class="tx-amount">380<span class="when">12/05 · 06:50</span></div>
                </div>

                <div class="tx">
                  <div class="tx-icon in"><svg viewBox="0 0 24 24"><path d="M12 5v14M5 12l7 7 7-7"/></svg></div>
                  <div class="tx-body">
                    <div class="tx-title">Nhập kho — Nước mắm Nam Ngư 750ml</div>
                    <div class="tx-sub">PN-2644 · NCC: Masan · 920 thùng</div>
                  </div>
                  <div class="tx-amount">+920<span class="when">11/05 · 17:22</span></div>
                </div>

                <div class="tx">
                  <div class="tx-icon out"><svg viewBox="0 0 24 24"><path d="M12 19V5M19 12l-7-7-7 7"/></svg></div>
                  <div class="tx-body">
                    <div class="tx-title">Xuất kho — Mì Hảo Hảo tôm chua cay</div>
                    <div class="tx-sub">PX-1182 · KH: BigC Long Biên · 2,400 thùng</div>
                  </div>
                  <div class="tx-amount">−2,400<span class="when">11/05 · 14:08</span></div>
                </div>

                <div class="tx">
                  <div class="tx-icon in"><svg viewBox="0 0 24 24"><path d="M12 5v14M5 12l7 7 7-7"/></svg></div>
                  <div class="tx-body">
                    <div class="tx-title">Nhập kho — Dầu ăn Tường An 1L</div>
                    <div class="tx-sub">PN-2643 · NCC: KIDO · 1,500 thùng</div>
                  </div>
                  <div class="tx-amount">+1,500<span class="when">11/05 · 10:34</span></div>
                </div>

              </div>
            </div>
          </div>
        </section>

        <div class="section-head">
          <h2>Tồn kho chi tiết</h2>
          <span class="meta">Hiển thị 6 / 12,438 mã hàng</span>
        </div>
        <section class="card" data-od-id="inventory" style="overflow:hidden">
          <div class="card-head">
            <div style="display:flex; gap:8px; align-items:center">
              <button class="btn">Tất cả · 12,438</button>
              <button class="btn" style="border-color:transparent; color:var(--muted)">Sắp hết · 47</button>
              <button class="btn" style="border-color:transparent; color:var(--muted)">Hết hàng · 8</button>
            </div>
            <div style="display:flex; gap:8px">
              <button class="btn">
                <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M6 12h12M10 18h4"/></svg>
                Lọc
              </button>
              <button class="btn">
                <svg class="icon" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3"/></svg>
                Xuất CSV
              </button>
            </div>
          </div>
          <table class="inv">
            <thead>
              <tr>
                <th style="width:120px">MÃ HÀNG</th>
                <th>Sản phẩm</th>
                <th>Danh mục</th>
                <th>Kho</th>
                <th class="num">Tồn</th>
                <th class="num">Đặt trước</th>
                <th class="num">Khả dụng</th>
                <th>Trạng thái</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td class="sku">SKU-100482</td>
                <td><div class="product">Cà phê G7 hòa tan 3in1</div><div class="product-sub">Hộp 21 gói · Trung Nguyên</div></td>
                <td>Đồ uống</td>
                <td>HN-01 · A2</td>
                <td class="num">4,820</td>
                <td class="num">320</td>
                <td class="num">4,500</td>
                <td><span class="pill ok"><span class="pdot"></span>Đủ hàng</span></td>
              </tr>
              <tr>
                <td class="sku">SKU-100921</td>
                <td><div class="product">Sữa tươi Vinamilk 1L có đường</div><div class="product-sub">Thùng 12 hộp · Vinamilk</div></td>
                <td>Sữa</td>
                <td>HN-01 · B1</td>
                <td class="num">186</td>
                <td class="num">120</td>
                <td class="num">66</td>
                <td><span class="pill low"><span class="pdot"></span>Sắp hết</span></td>
              </tr>
              <tr>
                <td class="sku">SKU-101204</td>
                <td><div class="product">Nước mắm Nam Ngư đệ nhị 750ml</div><div class="product-sub">Thùng 12 chai · Masan</div></td>
                <td>Gia vị</td>
                <td>HN-01 · C3</td>
                <td class="num">2,340</td>
                <td class="num">180</td>
                <td class="num">2,160</td>
                <td><span class="pill ok"><span class="pdot"></span>Đủ hàng</span></td>
              </tr>
              <tr>
                <td class="sku">SKU-101750</td>
                <td><div class="product">Bột giặt OMO Matic cửa trên 6kg</div><div class="product-sub">Bao 1 túi · Unilever</div></td>
                <td>Hóa phẩm</td>
                <td>HCM-03 · D2</td>
                <td class="num">0</td>
                <td class="num">240</td>
                <td class="num">−240</td>
                <td><span class="pill out"><span class="pdot"></span>Hết hàng</span></td>
              </tr>
              <tr>
                <td class="sku">SKU-102108</td>
                <td><div class="product">Mì Hảo Hảo tôm chua cay 75g</div><div class="product-sub">Thùng 30 gói · Acecook</div></td>
                <td>Thực phẩm khô</td>
                <td>HN-01 · A4</td>
                <td class="num">8,640</td>
                <td class="num">1,200</td>
                <td class="num">7,440</td>
                <td><span class="pill ok"><span class="pdot"></span>Đủ hàng</span></td>
              </tr>
              <tr>
                <td class="sku">SKU-102590</td>
                <td><div class="product">Dầu ăn Tường An Vio 1L</div><div class="product-sub">Thùng 24 chai · KIDO</div></td>
                <td>Gia vị</td>
                <td>DN-02 · B5</td>
                <td class="num">412</td>
                <td class="num">380</td>
                <td class="num">32</td>
                <td><span class="pill low"><span class="pdot"></span>Sắp hết</span></td>
              </tr>
            </tbody>
          </table>
        </section>

        <div class="section-head">
          <h2>Cảnh báo cần xử lý</h2>
          <span class="meta">Cập nhật 2 phút trước</span>
        </div>
        <section class="alerts" data-od-id="alerts">
          <div class="alert warn">
            <div class="alert-icon"><svg viewBox="0 0 24 24"><path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><path d="M12 9v4M12 17h.01"/></svg></div>
            <div class="alert-body">
              <div class="alert-title">Sắp hết hàng <span class="count">47 mã hàng</span></div>
              <div class="alert-desc">Khả dụng dưới ngưỡng an toàn (≤ 7 ngày tồn). Có 12 SKU thuộc nhóm bán chạy.</div>
              <a class="alert-cta" href="#">Xem danh sách →</a>
            </div>
          </div>

          <div class="alert danger">
            <div class="alert-icon"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg></div>
            <div class="alert-body">
              <div class="alert-title">Hết hàng <span class="count">8 mã hàng</span></div>
              <div class="alert-desc">Tồn = 0 nhưng vẫn có đơn đặt trước. Cần xử lý ngay để tránh trễ giao.</div>
              <a class="alert-cta" href="#">Tạo phiếu nhập gấp →</a>
            </div>
          </div>

          <div class="alert info">
            <div class="alert-icon"><svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg></div>
            <div class="alert-body">
              <div class="alert-title">Sắp hết hạn <span class="count">15 mã hàng</span></div>
              <div class="alert-desc">Còn dưới 30 ngày HSD. Tổng giá trị 142 triệu ₫. Đề xuất khuyến mãi xả hàng.</div>
              <a class="alert-cta" href="#">Xem chi tiết →</a>
            </div>
          </div>
        </section>

        <div class="foot">
          <span>Đồng bộ cuối · 12/05/2026 13:12 · Kho HN-01</span>
          <span>v2.4.1 · 6 người dùng đang trực tuyến</span>
        </div>

      </main>
    </div>
  </div>

  <script src="assets/js/theme.js"></script>
  <script src="assets/js/sidebar.js"></script>
  <script>
    document.querySelectorAll('.tabs').forEach(function(group) {
      group.addEventListener('click', function(e) {
        if (e.target.classList.contains('tab')) {
          group.querySelectorAll('.tab').forEach(function(t) { t.classList.remove('active'); });
          e.target.classList.add('active');
        }
      });
    });
  </script>
  </body>
  </html>
