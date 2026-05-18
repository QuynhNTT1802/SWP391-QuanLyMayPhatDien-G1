<%-- 
    Document   : homepage
    Created on : May 15, 2026, 9:23:00 AM
    Author     : FPTShop
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Warehouse OS — Hệ điều hành cho kho hàng hiện đại</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500;1,600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/homepage.css">
    </head>
    <body>

        <!-- ============ NAV ============ -->
        <header class="site-nav">
            <div class="container nav-inner">
                <a href="#" class="brand">
                    <span class="brand-mark">WH</span>
                    Warehouse OS
                </a>
                <nav class="nav-links">
                    <a href="#features">Tính năng</a>
                    <a href="#preview">Sản phẩm</a>
                    <a href="#pricing">Bảng giá</a>
                    <a href="#faq">FAQ</a>
                    <a href="#">Khách hàng</a>
                </nav>
                <div class="nav-cta">
                    <a href="authen?action=login" class="btn btn-ghost">Đăng nhập</a>
                    <a href="index.html" class="btn btn-primary">Dùng thử miễn phí <span class="arrow">→</span></a>
                </div>
            </div>
        </header>

        <!-- ============ HERO ============ -->
        <section class="hero">
            <div class="container hero-inner">
                <div class="hero-text">
                    <span class="eyebrow"><span class="dot"></span>v2.4 · Tích hợp Sapo &amp; KiotViet</span>
                    <h1 class="hero-title">Hệ điều hành cho kho hàng <em>biết suy nghĩ.</em></h1>
                    <p class="hero-lede">Quản lý tồn kho real-time, dự báo nhập hàng bằng AI, đồng bộ đơn từ 12 kênh bán — tất cả trong một dashboard duy nhất. Dành cho nhà bán lẻ &amp; phân phối từ 1.000 SKU trở lên.</p>

                    <div class="hero-cta">
                        <a href="index.html" class="btn btn-primary">Xem demo dashboard <span class="arrow">→</span></a>
                        <a href="#preview" class="btn">Đặt lịch tư vấn</a>
                    </div>

                    <div class="hero-meta">
                        <span><strong>14</strong> ngày dùng thử miễn phí</span>
                        <span><strong>0₫</strong> phí setup</span>
                        <span>Hủy bất cứ lúc nào</span>
                    </div>
                </div>

                <!-- mini dashboard mockup -->
                <div class="mockup" aria-hidden="true">
                    <div class="mockup-bar">
                        <span class="dot-tl"></span>
                        <span class="dot-tl"></span>
                        <span class="dot-tl"></span>
                        <span class="url">warehouse-os.vn / dashboard</span>
                    </div>
                    <div class="mockup-body">
                        <div class="mock-kpis">
                            <div class="mock-kpi">
                                <div class="lbl">Tổng SKU</div>
                                <div class="val">12,438</div>
                                <div class="delta">▲ 1.8%</div>
                            </div>
                            <div class="mock-kpi">
                                <div class="lbl">Tồn kho</div>
                                <div class="val">348k</div>
                                <div class="delta" style="color:var(--muted)">▼ 4.2%</div>
                            </div>
                            <div class="mock-kpi">
                                <div class="lbl">Giá trị</div>
                                <div class="val">8.42<span style="font-size:11px;color:var(--muted);margin-inline-start:3px">tỷ</span></div>
                                <div class="delta">▲ 320tr</div>
                            </div>
                        </div>
                        <div class="mock-chart">
                            <div class="mock-chart-head">
                                <strong>Nhập / Xuất — 14 ngày</strong>
                                <span class="mono">+45.2k pcs</span>
                            </div>
                            <svg viewBox="0 0 320 90" preserveAspectRatio="none" style="width:100%;height:90px">
                            <polyline points="0,70 26,60 52,62 78,52 104,46 130,54 156,36 182,44 208,30 234,36 260,22 286,30 312,18" fill="none" stroke="var(--accent)" stroke-width="2"/>
                            <polyline points="0,70 26,60 52,62 78,52 104,46 130,54 156,36 182,44 208,30 234,36 260,22 286,30 312,18 312,90 0,90" fill="var(--accent)" opacity="0.12"/>
                            <polyline points="0,78 26,72 52,70 78,68 104,58 130,62 156,52 182,58 208,48 234,54 260,42 286,50 312,40" fill="none" stroke="var(--muted)" stroke-width="1.5" stroke-dasharray="3,3"/>
                            </svg>
                        </div>
                        <div>
                            <div class="mock-row">
                                <span>Cà phê G7 hòa tan</span>
                                <span><span class="pill-mini"><span class="pdot"></span>Đủ hàng</span></span>
                            </div>
                            <div class="mock-row">
                                <span>Sữa Vinamilk 1L</span>
                                <span style="font-family:var(--font-mono);color:oklch(70% 0.15 75)">⚠ 66</span>
                            </div>
                            <div class="mock-row">
                                <span>Bột giặt OMO 6kg</span>
                                <span style="font-family:var(--font-mono);color:oklch(58% 0.18 25)">● Hết hàng</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ============ LOGOS ============ -->
        <section class="logos">
            <div class="container">
                <div class="logos-head">Hơn 240 doanh nghiệp Việt Nam đang dùng</div>
                <div class="logos-grid">
                    <span class="logo-item">An Phú Foods</span>
                    <span class="logo-item sans">MEGA MARKET</span>
                    <span class="logo-item mono">/ logistics.vn</span>
                    <span class="logo-item">Nhà thuốc Long Châu</span>
                    <span class="logo-item sans">Coopmart</span>
                    <span class="logo-item mono">Tiki — Trading</span>
                    <span class="logo-item">Hệ thống Bibo</span>
                </div>
            </div>
        </section>

        <!-- ============ FEATURES ============ -->
        <section class="block" id="features">
            <div class="container">
                <div class="section-head">
                    <span class="section-kicker">Tính năng</span>
                    <h2 class="section-title">Đủ sâu cho ops team, đủ <em>nhẹ</em> cho founder.</h2>
                    <p class="section-lede">6 module cốt lõi được thiết kế cho cách kho thật sự vận hành ở Việt Nam — không phải bản dịch của Shopify Inventory.</p>
                </div>

                <div class="features-grid">
                    <div class="feature">
                        <div class="feature-icon"><svg viewBox="0 0 24 24"><path d="M3 7l9-4 9 4-9 4z"/><path d="M3 7v10l9 4 9-4V7"/><path d="M12 11v10"/></svg></div>
                        <h3>Tồn kho real-time</h3>
                        <p>Đồng bộ tức thì giữa nhiều kho, nhiều kênh bán. Một SKU bán trên Shopee, tồn ở kho Hà Nội cập nhật ngay không lệch.</p>
                    </div>

                    <div class="feature">
                        <div class="feature-icon"><svg viewBox="0 0 24 24"><path d="M3 3v18h18"/><path d="M7 14l4-4 4 4 5-5"/></svg></div>
                        <h3>Dự báo nhập hàng</h3>
                        <p>Model học từ lịch sử bán + mùa vụ + lead-time nhà cung cấp. Gợi ý đặt hàng trước khi hết, không phải sau khi hết.</p>
                    </div>

                    <div class="feature">
                        <div class="feature-icon"><svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><path d="M20 8v6M23 11h-6"/></svg></div>
                        <h3>Phân quyền theo kho</h3>
                        <p>Quản lý kho HN-01 không thấy được giá vốn kho HCM-03. Audit log từng phiếu, từng người, không cần Excel song song.</p>
                    </div>

                    <div class="feature">
                        <div class="feature-icon"><svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg></div>
                        <h3>Cảnh báo hết hạn</h3>
                        <p>Theo dõi HSD theo lô, FIFO tự động. Sản phẩm còn dưới 30 ngày được đề xuất khuyến mãi xả hàng, không bị âm vốn.</p>
                    </div>

                    <div class="feature">
                        <div class="feature-icon"><svg viewBox="0 0 24 24"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg></div>
                        <h3>Tích hợp sẵn 12 kênh</h3>
                        <p>Sapo, KiotViet, Haravan, Shopee, Lazada, Tiki, TikTok Shop, GHN, GHTK, J&amp;T — webhook 2 chiều, không cần Zapier.</p>
                    </div>

                    <div class="feature">
                        <div class="feature-icon"><svg viewBox="0 0 24 24"><path d="M3 6h18M6 12h12M10 18h4"/></svg></div>
                        <h3>Báo cáo có-thể-export</h3>
                        <p>P&amp;L theo SKU, vòng quay kho, hệ số xuất theo kênh. CSV/Excel/PDF — gửi thẳng vào email kế toán mỗi thứ Hai.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- ============ PRODUCT PREVIEW ============ -->
        <section class="block" id="preview" style="background: var(--surface-2); border-block: 1px solid var(--border);">
            <div class="container">
                <div class="section-head">
                    <span class="section-kicker">Bên trong sản phẩm</span>
                    <h2 class="section-title">Mọi <em>quyết định</em> bắt đầu ở dashboard.</h2>
                </div>

                <div class="preview-wrap">
                    <div class="preview-list">
                        <div class="preview-item active">
                            <span class="num">01</span>
                            <h4>Tổng quan kho</h4>
                            <p>KPI tồn kho, giá trị, SKU sắp hết — cập nhật theo phút.</p>
                        </div>
                        <div class="preview-item">
                            <span class="num">02</span>
                            <h4>Phiếu nhập / xuất</h4>
                            <p>Tạo nhanh, scan barcode, ký số trên mobile.</p>
                        </div>
                        <div class="preview-item">
                            <span class="num">03</span>
                            <h4>Đối soát nhà cung cấp</h4>
                            <p>Tự động khớp công nợ, gửi đối soát hàng tháng.</p>
                        </div>
                        <div class="preview-item">
                            <span class="num">04</span>
                            <h4>Phân tích bán hàng</h4>
                            <p>Top SKU, kênh nào lãi nhất, kho nào quay nhanh nhất.</p>
                        </div>
                    </div>

                    <div class="preview-canvas">
                        <div class="canvas-head">
                            <strong>Nhập / Xuất — 14 ngày qua</strong>
                            <span class="mono">12/05/2026 · HN-01</span>
                        </div>
                        <svg class="canvas-chart" viewBox="0 0 600 220" preserveAspectRatio="none">
                        <g stroke="var(--border)" stroke-width="1">
                        <line x1="30" y1="15" x2="590" y2="15"/>
                        <line x1="30" y1="65" x2="590" y2="65" stroke-dasharray="2,3"/>
                        <line x1="30" y1="115" x2="590" y2="115" stroke-dasharray="2,3"/>
                        <line x1="30" y1="165" x2="590" y2="165" stroke-dasharray="2,3"/>
                        <line x1="30" y1="205" x2="590" y2="205"/>
                        </g>
                        <g font-family="var(--font-mono)" font-size="9" fill="var(--muted)" text-anchor="end">
                        <text x="26" y="19">40k</text>
                        <text x="26" y="69">30k</text>
                        <text x="26" y="119">20k</text>
                        <text x="26" y="169">10k</text>
                        </g>
                        <polyline points="50,150 90,130 130,140 170,110 210,100 250,125 290,85 330,100 370,70 410,80 450,60 490,85 530,65 570,50" fill="none" stroke="var(--accent)" stroke-width="2.2"/>
                        <polyline points="50,150 90,130 130,140 170,110 210,100 250,125 290,85 330,100 370,70 410,80 450,60 490,85 530,65 570,50 570,205 50,205" fill="var(--accent)" opacity="0.12"/>
                        <polyline points="50,170 90,160 130,155 170,150 210,130 250,140 290,120 330,130 370,110 410,125 450,100 490,115 530,95 570,105" fill="none" stroke="var(--muted)" stroke-width="2" stroke-dasharray="3,3"/>
                        <circle cx="570" cy="50" r="4" fill="var(--accent)"/>
                        <circle cx="570" cy="50" r="8" fill="var(--accent)" opacity="0.2"/>
                        <g transform="translate(508, 22)">
                        <rect width="74" height="20" rx="4" fill="var(--surface)" stroke="var(--border)"/>
                        <text x="8" y="14" font-family="var(--font-mono)" font-size="11" fill="var(--fg)">38.2k pcs</text>
                        </g>
                        </svg>
                        <div style="display:flex; gap:20px; margin-top: 6px; font-size: 12px; color: var(--muted);">
                            <span><span style="display:inline-block;width:10px;height:2px;background:var(--accent);margin-inline-end:6px;vertical-align:middle"></span>Nhập kho · 412k</span>
                            <span><span style="display:inline-block;width:10px;height:2px;background:var(--muted);border-top:1px dashed var(--muted);margin-inline-end:6px;vertical-align:middle"></span>Xuất kho · 367k</span>
                        </div>
                    </div>
                </div>

                <div style="text-align:center; margin-top:48px">
                    <a href="index.html" class="btn btn-primary">Mở dashboard demo <span class="arrow">→</span></a>
                </div>
            </div>
        </section>

        <!-- ============ STATS ============ -->
        <section class="block">
            <div class="container">
                <div class="stats">
                    <div class="stats-grid">
                        <div class="stat">
                            <div class="val">240<span class="suffix">+</span></div>
                            <div class="lbl">Doanh nghiệp Việt đang dùng hằng ngày</div>
                        </div>
                        <div class="stat">
                            <div class="val">4.8<span class="suffix">M</span></div>
                            <div class="lbl">SKU được theo dõi mỗi tháng trên hệ thống</div>
                        </div>
                        <div class="stat">
                            <div class="val">31<span class="suffix">%</span></div>
                            <div class="lbl">Giảm trung bình SKU âm hàng sau 90 ngày</div>
                        </div>
                        <div class="stat">
                            <div class="val">99.97<span class="suffix">%</span></div>
                            <div class="lbl">Uptime 12 tháng gần nhất, không tính bảo trì</div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ============ TESTIMONIAL ============ -->
        <section class="testimonial">
            <div class="container">
                <div class="testimonial-card">
                    <div class="quote-mark">"</div>
                    <p class="quote-body">Trước dùng Excel + Zalo, mỗi cuối tháng phải <em>chốt tay 3 ngày</em>. Bây giờ team kho biết hết SKU nào sắp hết trước khi tôi kịp hỏi — và phiếu nhập tự khớp với đối soát NCC, không phải đi truy từng dòng.</p>
                    <div class="quote-attr">
                        <div class="quote-avatar">NHT</div>
                        <div>
                            <div class="name">Nguyễn Hữu Thắng</div>
                            <div class="role">Giám đốc vận hành · An Phú Foods (12 kho · 4.200 SKU)</div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ============ PRICING ============ -->
        <section class="block" id="pricing" style="background: var(--surface-2); border-block: 1px solid var(--border);">
            <div class="container">
                <div class="section-head">
                    <span class="section-kicker">Bảng giá</span>
                    <h2 class="section-title">Giá rõ ràng. Không phụ phí <em>setup.</em></h2>
                    <p class="section-lede">Trả theo tháng, hủy bất cứ lúc nào. Mọi gói đều có 14 ngày dùng thử miễn phí — không cần thẻ tín dụng.</p>
                </div>

                <div class="pricing-grid">
                    <div class="price-card">
                        <div class="price-name">Khởi đầu</div>
                        <div class="price-amount">490<span class="unit">k ₫ / tháng</span></div>
                        <div class="price-desc">Cho shop nhỏ &amp; nhà bán độc lập đang thoát khỏi Excel.</div>
                        <ul class="price-features">
                            <li><svg viewBox="0 0 24 24"><path d="M5 13l4 4 10-10"/></svg>Tối đa 1.000 SKU</li>
                            <li><svg viewBox="0 0 24 24"><path d="M5 13l4 4 10-10"/></svg>2 user, 1 kho</li>
                            <li><svg viewBox="0 0 24 24"><path d="M5 13l4 4 10-10"/></svg>Tích hợp 3 kênh bán</li>
                            <li><svg viewBox="0 0 24 24"><path d="M5 13l4 4 10-10"/></svg>Báo cáo CSV</li>
                        </ul>
                        <a href="#" class="btn">Bắt đầu dùng thử</a>
                    </div>

                    <div class="price-card featured">
                        <span class="price-badge">Phổ biến</span>
                        <div class="price-name">Tăng trưởng</div>
                        <div class="price-amount">1.9<span class="unit">tr ₫ / tháng</span></div>
                        <div class="price-desc">Cho doanh nghiệp 2.000–10.000 SKU, nhiều kho, nhiều kênh.</div>
                        <ul class="price-features">
                            <li><svg viewBox="0 0 24 24"><path d="M5 13l4 4 10-10"/></svg>Tối đa 10.000 SKU</li>
                            <li><svg viewBox="0 0 24 24"><path d="M5 13l4 4 10-10"/></svg>10 user, 5 kho</li>
                            <li><svg viewBox="0 0 24 24"><path d="M5 13l4 4 10-10"/></svg>Tích hợp 12 kênh + webhook</li>
                            <li><svg viewBox="0 0 24 24"><path d="M5 13l4 4 10-10"/></svg>Dự báo nhập hàng AI</li>
                            <li><svg viewBox="0 0 24 24"><path d="M5 13l4 4 10-10"/></svg>Hỗ trợ ưu tiên qua Zalo</li>
                        </ul>
                        <a href="#" class="btn btn-primary">Chọn gói Tăng trưởng <span class="arrow">→</span></a>
                    </div>

                    <div class="price-card">
                        <div class="price-name">Doanh nghiệp</div>
                        <div class="price-amount" style="font-size: 40px">Liên hệ</div>
                        <div class="price-desc">Cho chuỗi &gt; 50.000 SKU, tích hợp ERP, SLA 99.9%.</div>
                        <ul class="price-features">
                            <li><svg viewBox="0 0 24 24"><path d="M5 13l4 4 10-10"/></svg>SKU không giới hạn</li>
                            <li><svg viewBox="0 0 24 24"><path d="M5 13l4 4 10-10"/></svg>User &amp; kho không giới hạn</li>
                            <li><svg viewBox="0 0 24 24"><path d="M5 13l4 4 10-10"/></svg>API riêng + SSO</li>
                            <li><svg viewBox="0 0 24 24"><path d="M5 13l4 4 10-10"/></svg>Triển khai on-premise</li>
                            <li><svg viewBox="0 0 24 24"><path d="M5 13l4 4 10-10"/></svg>Quản lý tài khoản chuyên trách</li>
                        </ul>
                        <a href="#" class="btn">Đặt lịch demo</a>
                    </div>
                </div>
            </div>
        </section>

        <!-- ============ FAQ ============ -->
        <section class="block" id="faq">
            <div class="container">
                <div class="section-head">
                    <span class="section-kicker">Câu hỏi</span>
                    <h2 class="section-title">Thắc mắc <em>thường gặp.</em></h2>
                </div>

                <div class="faq-grid">
                    <details class="faq-item" open>
                        <summary class="faq-q">Tôi đang dùng KiotViet, chuyển sang có mất data không? <span class="plus">+</span></summary>
                        <div class="faq-a">Không. Team triển khai sẽ import lịch sử tồn kho, đơn hàng 12 tháng và mapping SKU 1-1. Trung bình 3 ngày làm việc, miễn phí với mọi gói. Khách hàng cũ có thể chạy song song 2 hệ thống trong 30 ngày để đối chiếu.</div>
                    </details>

                    <details class="faq-item">
                        <summary class="faq-q">Tích hợp với Shopee &amp; TikTok Shop có ổn định không? <span class="plus">+</span></summary>
                        <div class="faq-a">Có. Chúng tôi là Shopee Open Platform Partner từ 2023, dùng webhook chính thức (không scrape). Đồng bộ tồn kho &lt; 5 giây sau khi có đơn. Lỗi rate-limit trong Tết 2026 được xử lý bằng queue retry tự động.</div>
                    </details>

                    <details class="faq-item">
                        <summary class="faq-q">Data của tôi được lưu ở đâu? <span class="plus">+</span></summary>
                        <div class="faq-a">Tại data center của Viettel IDC (Hà Nội &amp; HCM), tuân thủ Nghị định 13/2023 về bảo vệ dữ liệu cá nhân. Backup mỗi 6 giờ, retention 90 ngày. Khách doanh nghiệp có thể chọn deploy on-premise.</div>
                    </details>

                    <details class="faq-item">
                        <summary class="faq-q">Có giới hạn user / kho không trong bản dùng thử? <span class="plus">+</span></summary>
                        <div class="faq-a">Bản dùng thử 14 ngày bằng gói Tăng trưởng — đủ cho 10 user và 5 kho. Sau 14 ngày bạn chọn gói phù hợp, data được giữ nguyên.</div>
                    </details>

                    <details class="faq-item">
                        <summary class="faq-q">Hỗ trợ kỹ thuật làm việc giờ nào? <span class="plus">+</span></summary>
                        <div class="faq-a">Zalo &amp; email: 8h–22h hằng ngày, kể cả cuối tuần. Hotline: 8h–18h thứ Hai đến thứ Bảy. Khách doanh nghiệp có SLA phản hồi &lt; 30 phút 24/7.</div>
                    </details>
                </div>
            </div>
        </section>

        <!-- ============ CTA ============ -->
        <section class="cta-final">
            <div class="container">
                <h2>Chốt sổ kho không nên là việc <em>cuối tháng.</em></h2>
                <p>Bắt đầu với 14 ngày dùng thử miễn phí. Không cần thẻ. Không cần cài đặt. Mở dashboard trong 90 giây.</p>
                <div class="actions">
                    <a href="index.html" class="btn btn-primary">Mở dashboard demo <span class="arrow">→</span></a>
                    <a href="#pricing" class="btn">Xem bảng giá</a>
                </div>
            </div>
        </section>

        <!-- ============ FOOTER ============ -->
        <footer class="site-footer">
            <div class="container">
                <div class="foot-top">
                    <div class="foot-brand">
                        <a href="#" class="brand"><span class="brand-mark">WH</span>Warehouse OS</a>
                        <p>Hệ điều hành cho kho hàng. Made in Vietnam, dành cho nhà bán lẻ &amp; phân phối Việt.</p>
                    </div>

                    <div class="foot-col">
                        <h5>Sản phẩm</h5>
                        <ul>
                            <li><a href="#features">Tính năng</a></li>
                            <li><a href="#pricing">Bảng giá</a></li>
                            <li><a href="index.html">Demo</a></li>
                            <li><a href="#">Tích hợp</a></li>
                            <li><a href="#">Thay đổi gần đây</a></li>
                        </ul>
                    </div>

                    <div class="foot-col">
                        <h5>Công ty</h5>
                        <ul>
                            <li><a href="#">Về chúng tôi</a></li>
                            <li><a href="#">Khách hàng</a></li>
                            <li><a href="#">Tuyển dụng</a></li>
                            <li><a href="#">Liên hệ</a></li>
                        </ul>
                    </div>

                    <div class="foot-col">
                        <h5>Tài liệu</h5>
                        <ul>
                            <li><a href="#">Hướng dẫn dùng</a></li>
                            <li><a href="#">API docs</a></li>
                            <li><a href="#">Blog vận hành kho</a></li>
                            <li><a href="#">Trạng thái hệ thống</a></li>
                        </ul>
                    </div>
                </div>

                <div class="foot-bot">
                    <span>© 2026 Warehouse OS · MST 0108-xxxx-xxx · 24 Lý Thường Kiệt, Hà Nội</span>
                    <div class="socials">
                        <a href="#">Facebook</a>
                        <a href="#">LinkedIn</a>
                        <a href="#">YouTube</a>
                    </div>
                </div>
            </div>
        </footer>

        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script>
            document.querySelectorAll('.preview-item').forEach(item => {
                item.addEventListener('click', () => {
                    document.querySelectorAll('.preview-item').forEach(i => i.classList.remove('active'));
                    item.classList.add('active');
                });
            });
        </script>

    </body>
</html>
