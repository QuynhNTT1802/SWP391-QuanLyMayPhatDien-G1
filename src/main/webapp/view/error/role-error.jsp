<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>403 — Khong co quyen truy cap</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body {
            display: flex; align-items: center; justify-content: center;
            min-height: 100vh; margin: 0;
            font-family: 'Be Vietnam Pro', sans-serif;
            background: var(--bg);
            color: var(--fg);
        }
        .error-box {
            text-align: center; padding: 48px 32px;
            max-width: 480px; background: var(--surface);
            border: 1px solid var(--border); border-radius: var(--radius);
        }
        .error-box h1 { font-size: 64px; font-weight: 800; margin: 0 0 8px; color: var(--danger); letter-spacing: -0.02em; }
        .error-box h2 { font-size: 18px; font-weight: 700; margin: 0 0 8px; }
        .error-box p  { font-size: 13px; color: var(--muted); margin: 0 0 20px; line-height: 1.5; }
        .error-box code { font-family: 'JetBrains Mono', monospace; background: var(--surface-2); padding: 2px 8px; border-radius: 4px; font-size: 12px; font-weight: 600; }
        .error-box a  { display: inline-block; margin-top: 8px; padding: 8px 20px; background: var(--accent); color: var(--bg); text-decoration: none; border-radius: var(--radius-sm); font-size: 13px; font-weight: 600; }
    </style>
</head>
<body>
    <div class="error-box">
        <h1>403</h1>
        <h2>Khong co quyen truy cap</h2>
        <p>Ban can quyen <code>${requiredPerm}</code> de truy cap trang nay.</p>
        <a href="${pageContext.request.contextPath}/admin/dashboard">Ve Dashboard</a>
    </div>
</body>
</html>
