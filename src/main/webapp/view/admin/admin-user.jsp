<%-- 
    Document   : admin-user
    Created on : May 15, 2026, 9:23:11 AM
    Author     : Aadmin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Quản lý người dùng — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <style>

            [data-theme="dark"] {
                --bg: oklch(16% 0.012 250);
                --surface: oklch(20% 0.014 250);
                --surface-2: oklch(22% 0.014 250);
                --surface-3: oklch(24% 0.014 250);
                --fg: oklch(96% 0.005 240);
                --fg-soft: oklch(82% 0.008 240);
                --muted: oklch(65% 0.012 240);
                --muted-2: oklch(50% 0.012 240);
                --border: oklch(28% 0.014 240);
                --border-strong: oklch(36% 0.016 240);
                --accent: oklch(70% 0.18 145);
                --accent-soft: oklch(28% 0.06 145);
                --danger: oklch(68% 0.20 25);
                --danger-soft: oklch(28% 0.06 25);
                --warn: oklch(75% 0.16 75);
                --warn-soft: oklch(28% 0.06 75);
                --info: oklch(70% 0.15 250);
                --info-soft: oklch(28% 0.05 250);
                --purple: oklch(72% 0.16 295);
                --purple-soft: oklch(28% 0.06 295);
            }
            * {
                box-sizing: border-box;
            }
            html, body {
                margin: 0;
                padding: 0;
            }
            body {
                font-family: var(--font-ui);
                font-size: 14px;
                line-height: 1.5;
                font-weight: 450;
                color: var(--fg);
                background: var(--bg);
                font-variant-numeric: tabular-nums;
                font-feature-settings: var(--font-feature);
                -webkit-font-smoothing: antialiased;
                -moz-osx-font-smoothing: grayscale;
                text-rendering: optimizeLegibility;
            }
            .mono {
                font-family: var(--font-mono);
            }
            .app {
                display: grid;
                grid-template-columns: 240px 1fr;
                min-height: 100vh;
            }
            aside.sidebar {
                background: var(--surface);
                border-right: 1px solid var(--border);
                position: sticky;
                top: 0;
                height: 100vh;
                display: flex;
                flex-direction: column;
                padding: 20px 12px 16px;
            }
            .brand {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 4px 10px 18px;
                font-weight: 700;
                font-size: 14px;
                letter-spacing: -0.01em;
            }
            .brand-mark {
                width: 22px;
                height: 22px;
                border-radius: 5px;
                background: var(--fg);
                color: var(--bg);
                display: grid;
                place-items: center;
                font-family: var(--font-mono);
                font-size: 11px;
                font-weight: 700;
            }
            nav.nav {
                display: flex;
                flex-direction: column;
                gap: 1px;
                flex: 1;
            }
            .nav-section {
                font-size: 10.5px;
                letter-spacing: 0.08em;
                text-transform: uppercase;
                color: var(--muted);
                padding: 14px 10px 6px;
                font-weight: 700;
            }
            .nav a {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 7px 10px;
                border-radius: var(--radius-sm);
                color: var(--fg-soft);
                text-decoration: none;
                font-size: 13px;
                font-weight: 600;
            }
            .nav a:hover {
                background: var(--surface-2);
                color: var(--fg);
            }
            .nav a.active {
                background: var(--accent-soft);
                color: var(--accent);
                font-weight: 700;
            }
            .nav a .icon {
                width: 14px;
                height: 14px;
                stroke: currentColor;
                fill: none;
                stroke-width: 1.8;
                flex-shrink: 0;
            }
            .nav a .count {
                margin-left: auto;
                font-family: var(--font-mono);
                font-size: 11px;
                color: var(--muted);
                background: var(--surface-2);
                padding: 1px 6px;
                border-radius: 999px;
                border: 1px solid var(--border);
                font-weight: 600;
            }
            .nav a.active .count {
                color: var(--accent);
                background: transparent;
                border-color: transparent;
            }
            .sidebar-footer {
                border-top: 1px solid var(--border);
                padding: 12px 10px 4px;
                margin-top: 8px;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .avatar {
                width: 28px;
                height: 28px;
                border-radius: 50%;
                background: var(--surface-2);
                border: 1px solid var(--border);
                display: grid;
                place-items: center;
                font-size: 11px;
                font-weight: 700;
                color: var(--fg-soft);
            }
            .user-meta {
                line-height: 1.2;
                flex: 1;
                min-width: 0;
            }
            .user-meta .name {
                font-size: 12.5px;
                font-weight: 700;
            }
            .user-meta .role {
                font-size: 11px;
                color: var(--muted);
                font-weight: 500;
            }

            header.topbar {
                position: sticky;
                top: 0;
                z-index: 10;
                background: color-mix(in srgb, var(--bg) 85%, transparent);
                backdrop-filter: blur(8px);
                border-bottom: 1px solid var(--border);
                display: flex;
                align-items: center;
                gap: 16px;
                padding: 12px 24px;
            }
            .topbar h1 {
                font-size: 16px;
                font-weight: 700;
                margin: 0;
                letter-spacing: -0.01em;
            }
            .crumb {
                color: var(--muted);
                font-size: 13px;
                font-weight: 500;
            }
            .crumb a {
                color: var(--muted);
                text-decoration: none;
            }
            .crumb a:hover {
                color: var(--fg);
            }
            .top-actions {
                margin-left: auto;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .btn {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                border: 1px solid var(--border);
                background: var(--surface);
                color: var(--fg);
                padding: 7px 12px;
                border-radius: var(--radius-sm);
                font-size: 13px;
                font-weight: 600;
                cursor: pointer;
                font-family: var(--font-ui);
                transition: background .12s ease;
            }
            .btn:hover {
                background: var(--surface-2);
            }
            .btn:disabled {
                opacity: 0.5;
                cursor: not-allowed;
            }
            .btn-primary {
                background: var(--fg);
                color: var(--bg);
                border-color: var(--fg);
            }
            .btn-primary:hover {
                background: var(--fg-soft);
                border-color: var(--fg-soft);
            }
            .btn-danger {
                background: var(--surface);
                color: var(--danger);
                border-color: color-mix(in srgb, var(--danger) 30%, transparent);
            }
            .btn-danger:hover {
                background: var(--danger-soft);
            }
            .btn .icon {
                width: 13px;
                height: 13px;
                stroke: currentColor;
                fill: none;
                stroke-width: 1.8;
            }
            .icon-btn {
                width: 32px;
                height: 32px;
                border: 1px solid var(--border);
                background: var(--surface);
                color: var(--fg-soft);
                border-radius: var(--radius-sm);
                display: grid;
                place-items: center;
                cursor: pointer;
            }
            .icon-btn:hover {
                background: var(--surface-2);
                color: var(--fg);
            }
            .icon-btn svg {
                width: 15px;
                height: 15px;
                stroke: currentColor;
                fill: none;
                stroke-width: 1.6;
            }
            .theme-toggle .icon-sun, .theme-toggle .icon-moon {
                display: none;
            }
            [data-theme="light"] .theme-toggle .icon-moon {
                display: block;
            }
            [data-theme="dark"] .theme-toggle .icon-sun {
                display: block;
            }

            main {
                padding: 20px 24px 60px;
                min-width: 0;
            }
            .page-head {
                margin-bottom: 18px;
                display: flex;
                align-items: flex-start;
                gap: 16px;
            }
            .page-head .left {
                flex: 1;
            }
            .eyebrow {
                font-size: 11px;
                font-weight: 700;
                letter-spacing: 0.08em;
                text-transform: uppercase;
                color: var(--accent);
                margin-bottom: 6px;
                display: inline-flex;
                align-items: center;
                gap: 6px;
            }
            .eyebrow::before {
                content: '';
                width: 5px;
                height: 5px;
                border-radius: 50%;
                background: var(--accent);
            }
            .page-title {
                font-size: 22px;
                font-weight: 700;
                letter-spacing: -0.02em;
                margin: 0 0 4px;
            }
            .page-sub {
                font-size: 13px;
                color: var(--muted);
                font-weight: 500;
            }

            .stats-row {
                display: grid;
                grid-template-columns: repeat(5, 1fr);
                gap: 10px;
                margin-bottom: 18px;
            }
            .stat {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                padding: 10px 14px;
            }
            .stat .lbl {
                font-size: 11px;
                color: var(--muted);
                font-weight: 600;
                letter-spacing: 0.02em;
            }
            .stat .val {
                font-family: var(--font-mono);
                font-size: 20px;
                font-weight: 700;
                letter-spacing: -0.02em;
                line-height: 1.2;
                margin-top: 4px;
            }
            .stat .val .delta {
                font-family: var(--font-ui);
                font-size: 11px;
                font-weight: 600;
                margin-inline-start: 6px;
                padding: 1px 5px;
                border-radius: 3px;
                vertical-align: middle;
            }
            .stat .val .delta.up {
                color: var(--accent);
                background: var(--accent-soft);
            }
            .stat .val .delta.down {
                color: var(--danger);
                background: var(--danger-soft);
            }

            .toolbar {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: var(--radius) var(--radius) 0 0;
                padding: 12px 14px;
                display: flex;
                gap: 10px;
                align-items: center;
                flex-wrap: wrap;
                border-bottom: 0;
            }
            .search-input {
                position: relative;
                flex: 1;
                min-width: 240px;
                max-width: 360px;
            }
            .search-input input {
                width: 100%;
                border: 1px solid var(--border);
                background: var(--surface-2);
                color: var(--fg);
                border-radius: var(--radius-sm);
                padding: 7px 10px 7px 32px;
                font-size: 13px;
                font-family: var(--font-ui);
                font-weight: 500;
            }
            .search-input input::placeholder {
                color: var(--muted-2);
                font-weight: 500;
            }
            .search-input input:focus {
                outline: none;
                border-color: var(--accent);
                background: var(--surface);
                box-shadow: 0 0 0 3px var(--accent-soft);
            }
            .search-input svg {
                position: absolute;
                inline-size: 14px;
                block-size: 14px;
                inset-inline-start: 10px;
                inset-block-start: 50%;
                transform: translateY(-50%);
                stroke: var(--muted);
                fill: none;
                stroke-width: 1.8;
            }
            .filter-select {
                border: 1px solid var(--border);
                background: var(--surface-2);
                color: var(--fg);
                border-radius: var(--radius-sm);
                padding: 7px 28px 7px 10px;
                font-size: 13px;
                font-family: var(--font-ui);
                font-weight: 600;
                cursor: pointer;
                appearance: none;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%23888' stroke-width='2'%3E%3Cpath d='m6 9 6 6 6-6'/%3E%3C/svg%3E");
                background-repeat: no-repeat;
                background-position: right 8px center;
            }
            .filter-select:focus {
                outline: none;
                border-color: var(--accent);
                box-shadow: 0 0 0 3px var(--accent-soft);
            }
            .toolbar .spacer {
                flex: 1;
            }

            .bulk-bar {
                display: none;
                align-items: center;
                gap: 10px;
                padding: 10px 14px;
                background: var(--info-soft);
                border: 1px solid color-mix(in srgb, var(--info) 30%, transparent);
                border-bottom: 0;
                font-size: 13px;
                font-weight: 600;
                color: var(--fg);
            }
            body.has-selection .bulk-bar {
                display: flex;
            }
            body.has-selection .toolbar {
                display: none;
            }
            .bulk-bar .count-pill {
                background: var(--info);
                color: var(--bg);
                padding: 2px 9px;
                border-radius: 999px;
                font-family: var(--font-mono);
                font-size: 12px;
                font-weight: 700;
            }
            .bulk-bar .bulk-actions {
                margin-left: auto;
                display: flex;
                gap: 6px;
            }
            .bulk-bar .btn-tiny {
                padding: 5px 10px;
                font-size: 12.5px;
                font-weight: 600;
                background: var(--surface);
                border: 1px solid var(--border);
                color: var(--fg);
                border-radius: var(--radius-sm);
                cursor: pointer;
                font-family: inherit;
                display: inline-flex;
                align-items: center;
                gap: 5px;
            }
            .bulk-bar .btn-tiny:hover {
                background: var(--surface-2);
            }
            .bulk-bar .btn-tiny.danger {
                color: var(--danger);
                border-color: color-mix(in srgb, var(--danger) 30%, transparent);
            }
            .bulk-bar .btn-tiny.danger:hover {
                background: var(--danger-soft);
            }

            .table-card {
                background: var(--surface);
                border: 1px solid var(--border);
                border-top: 0;
                border-radius: 0 0 var(--radius) var(--radius);
                overflow: hidden;
            }
            table.users {
                width: 100%;
                border-collapse: collapse;
                font-size: 13px;
            }
            table.users th, table.users td {
                text-align: start;
                padding: 11px 14px;
                border-bottom: 1px solid var(--border);
            }
            table.users th {
                font-size: 11px;
                font-weight: 700;
                color: var(--muted);
                text-transform: uppercase;
                letter-spacing: 0.04em;
                background: var(--surface-2);
                border-bottom: 1px solid var(--border-strong);
                position: sticky;
                top: 0;
                z-index: 1;
            }
            table.users th.sortable {
                cursor: pointer;
                user-select: none;
            }
            table.users th.sortable:hover {
                color: var(--fg);
            }
            table.users th .sort-ind {
                display: inline-block;
                margin-inline-start: 4px;
                font-family: var(--font-mono);
                color: var(--muted-2);
            }
            table.users th.sorted-asc .sort-ind::after {
                content: '↑';
                color: var(--accent);
            }
            table.users th.sorted-desc .sort-ind::after {
                content: '↓';
                color: var(--accent);
            }
            table.users tbody tr {
                cursor: pointer;
            }
            table.users tbody tr:hover {
                background: var(--surface-2);
            }
            table.users tbody tr.selected {
                background: var(--info-soft);
            }
            table.users tbody tr.selected:hover {
                background: color-mix(in srgb, var(--info-soft) 80%, var(--info) 20%);
            }
            table.users td {
                vertical-align: middle;
            }
            td.col-check, th.col-check {
                width: 36px;
                padding-inline-end: 0;
            }
            td.col-actions, th.col-actions {
                width: 88px;
                text-align: end;
            }

            .checkbox {
                appearance: none;
                width: 15px;
                height: 15px;
                border: 1.5px solid var(--border-strong);
                border-radius: 3px;
                background: var(--surface);
                cursor: pointer;
                position: relative;
                transition: all .1s ease;
                vertical-align: middle;
            }
            .checkbox:hover {
                border-color: var(--muted);
            }
            .checkbox:checked {
                background: var(--accent);
                border-color: var(--accent);
            }
            .checkbox:checked::after {
                content: '';
                position: absolute;
                inset-inline-start: 3px;
                inset-block-start: 0;
                width: 6px;
                height: 9px;
                border: solid var(--bg);
                border-width: 0 1.8px 1.8px 0;
                transform: rotate(45deg);
            }
            .checkbox:indeterminate {
                background: var(--accent);
                border-color: var(--accent);
            }
            .checkbox:indeterminate::after {
                content: '';
                position: absolute;
                inset-inline-start: 2.5px;
                inset-block-start: 6px;
                width: 8px;
                height: 1.8px;
                background: var(--bg);
            }

            .user-cell {
                display: flex;
                align-items: center;
                gap: 10px;
                min-width: 0;
            }
            .user-avatar {
                width: 32px;
                height: 32px;
                border-radius: 50%;
                flex-shrink: 0;
                display: grid;
                place-items: center;
                font-size: 12px;
                font-weight: 700;
                color: var(--bg);
            }
            .user-avatar.green {
                background: oklch(60% 0.16 145);
            }
            .user-avatar.blue {
                background: oklch(58% 0.14 250);
            }
            .user-avatar.orange {
                background: oklch(64% 0.15 50);
            }
            .user-avatar.purple {
                background: oklch(58% 0.16 295);
            }
            .user-avatar.pink {
                background: oklch(62% 0.18 0);
            }
            .user-avatar.teal {
                background: oklch(58% 0.13 195);
            }
            .user-avatar.grey {
                background: oklch(55% 0.01 240);
            }
            .user-name-block {
                line-height: 1.3;
                min-width: 0;
            }
            .user-name {
                font-weight: 600;
                color: var(--fg);
            }
            .user-email {
                font-size: 11.5px;
                color: var(--muted);
                font-family: var(--font-mono);
                font-weight: 500;
            }

            .pill {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                font-size: 11.5px;
                font-weight: 600;
                padding: 2px 8px;
                border-radius: 999px;
                border: 1px solid;
            }
            .pill .pdot {
                width: 5px;
                height: 5px;
                border-radius: 50%;
            }
            .pill.role-admin {
                color: var(--purple);
                border-color: color-mix(in srgb, var(--purple) 30%, transparent);
                background: var(--purple-soft);
            }
            .pill.role-admin .pdot {
                background: var(--purple);
            }
            .pill.role-manager {
                color: var(--info);
                border-color: color-mix(in srgb, var(--info) 30%, transparent);
                background: var(--info-soft);
            }
            .pill.role-manager .pdot {
                background: var(--info);
            }
            .pill.role-keeper {
                color: var(--accent);
                border-color: color-mix(in srgb, var(--accent) 30%, transparent);
                background: var(--accent-soft);
            }
            .pill.role-keeper .pdot {
                background: var(--accent);
            }
            .pill.role-account {
                color: var(--warn);
                border-color: color-mix(in srgb, var(--warn) 30%, transparent);
                background: var(--warn-soft);
            }
            .pill.role-account .pdot {
                background: var(--warn);
            }
            .pill.role-staff {
                color: var(--fg-soft);
                border-color: var(--border-strong);
                background: var(--surface-2);
            }
            .pill.role-staff .pdot {
                background: var(--fg-soft);
            }
            .pill.role-viewer {
                color: var(--muted);
                border-color: var(--border);
                background: var(--surface-2);
            }
            .pill.role-viewer .pdot {
                background: var(--muted-2);
            }

            .status {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                font-size: 12px;
                font-weight: 600;
            }
            .status .sdot {
                width: 7px;
                height: 7px;
                border-radius: 50%;
                flex-shrink: 0;
            }
            .status.active .sdot {
                background: var(--accent);
                box-shadow: 0 0 0 3px var(--accent-soft);
            }
            .status.active {
                color: var(--fg);
            }
            .status.pending .sdot {
                background: var(--warn);
            }
            .status.pending {
                color: var(--warn);
            }
            .status.locked .sdot {
                background: var(--danger);
            }
            .status.locked {
                color: var(--danger);
            }
            .status.disabled .sdot {
                background: var(--muted-2);
            }
            .status.disabled {
                color: var(--muted);
            }

            .warehouse-tag {
                font-size: 11.5px;
                font-family: var(--font-mono);
                font-weight: 600;
                color: var(--fg-soft);
                background: var(--surface-2);
                border: 1px solid var(--border);
                padding: 2px 7px;
                border-radius: 3px;
            }

            .last-login {
                font-size: 12px;
                color: var(--fg-soft);
                font-weight: 500;
            }
            .last-login .when {
                color: var(--muted);
                font-size: 11px;
                font-family: var(--font-mono);
            }

            .row-actions {
                display: inline-flex;
                gap: 2px;
                opacity: 0;
                transition: opacity .15s ease;
            }
            tbody tr:hover .row-actions {
                opacity: 1;
            }
            .row-actions .icon-mini {
                width: 26px;
                height: 26px;
                border: 1px solid transparent;
                background: transparent;
                color: var(--muted);
                border-radius: 4px;
                display: grid;
                place-items: center;
                cursor: pointer;
                transition: all .12s ease;
            }
            .row-actions .icon-mini:hover {
                background: var(--surface);
                border-color: var(--border);
                color: var(--fg);
            }
            .row-actions .icon-mini.danger:hover {
                color: var(--danger);
                border-color: color-mix(in srgb, var(--danger) 30%, transparent);
                background: var(--danger-soft);
            }
            .row-actions svg {
                width: 14px;
                height: 14px;
                stroke: currentColor;
                fill: none;
                stroke-width: 1.8;
            }

            .pagination {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 12px 14px;
                background: var(--surface);
                border-top: 1px solid var(--border);
                font-size: 12.5px;
                font-weight: 500;
            }
            .pagination .info {
                color: var(--muted);
                font-family: var(--font-mono);
            }
            .pagination .info strong {
                color: var(--fg);
                font-weight: 700;
            }
            .pagination .controls {
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .pagination .page-btn {
                min-width: 28px;
                height: 28px;
                padding: 0 9px;
                border: 1px solid var(--border);
                background: var(--surface);
                color: var(--fg-soft);
                border-radius: var(--radius-sm);
                font-family: var(--font-mono);
                font-size: 12px;
                font-weight: 600;
                cursor: pointer;
            }
            .pagination .page-btn:hover {
                background: var(--surface-2);
                color: var(--fg);
            }
            .pagination .page-btn.active {
                background: var(--fg);
                color: var(--bg);
                border-color: var(--fg);
            }
            .pagination .page-btn:disabled {
                opacity: 0.4;
                cursor: not-allowed;
            }
            .pagination .page-size {
                border: 1px solid var(--border);
                background: var(--surface);
                color: var(--fg);
                border-radius: var(--radius-sm);
                padding: 4px 22px 4px 8px;
                font-size: 12px;
                font-weight: 600;
                font-family: var(--font-ui);
                cursor: pointer;
                appearance: none;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='10' height='10' viewBox='0 0 24 24' fill='none' stroke='%23888' stroke-width='2'%3E%3Cpath d='m6 9 6 6 6-6'/%3E%3C/svg%3E");
                background-repeat: no-repeat;
                background-position: right 6px center;
            }

            .empty-state {
                padding: 60px 20px;
                text-align: center;
                color: var(--muted);
                font-size: 13px;
            }
            .empty-state .icon-wrap {
                width: 48px;
                height: 48px;
                margin: 0 auto 14px;
                background: var(--surface-2);
                border-radius: 12px;
                display: grid;
                place-items: center;
            }
            .empty-state .icon-wrap svg {
                width: 22px;
                height: 22px;
                stroke: var(--muted);
                fill: none;
                stroke-width: 1.6;
            }
            .empty-state strong {
                display: block;
                color: var(--fg);
                font-size: 14px;
                font-weight: 700;
                margin-bottom: 4px;
            }

            .toast-host {
                position: fixed;
                bottom: 24px;
                inset-inline-end: 24px;
                z-index: 60;
                display: flex;
                flex-direction: column;
                gap: 8px;
            }
            .toast {
                background: var(--fg);
                color: var(--bg);
                padding: 10px 14px;
                border-radius: var(--radius);
                font-size: 13px;
                font-weight: 600;
                box-shadow: var(--shadow-md);
                display: flex;
                align-items: center;
                gap: 10px;
                transform: translateY(8px);
                opacity: 0;
                transition: all .2s ease;
            }
            .toast.show {
                transform: translateY(0);
                opacity: 1;
            }
            .toast.success {
                background: var(--accent);
                color: var(--bg);
            }
            .toast.danger {
                background: var(--danger);
                color: var(--bg);
            }
            .toast svg {
                width: 15px;
                height: 15px;
                stroke: currentColor;
                fill: none;
                stroke-width: 2.2;
            }

            .modal-host {
                position: fixed;
                inset: 0;
                background: oklch(0% 0 0 / 0.4);
                z-index: 50;
                display: none;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }
            .modal-host.open {
                display: flex;
            }
            .modal {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                width: 100%;
                max-width: 420px;
                padding: 22px 22px 18px;
                box-shadow: var(--shadow-md);
            }
            .modal h3 {
                font-size: 16px;
                font-weight: 700;
                margin: 0 0 6px;
            }
            .modal p {
                font-size: 13px;
                color: var(--muted);
                margin: 0 0 16px;
                line-height: 1.5;
            }
            .modal .actions {
                display: flex;
                gap: 8px;
                justify-content: flex-end;
            }

            @media (max-width: 1100px) {
                .stats-row {
                    grid-template-columns: repeat(3, 1fr);
                }
                .stats-row .stat:nth-child(n+4) {
                    display: none;
                }
            }
            @media (max-width: 760px) {
                .app {
                    grid-template-columns: 1fr;
                }
                aside.sidebar {
                    display: none;
                }
                main {
                    padding: 16px;
                }
                .stats-row {
                    grid-template-columns: repeat(2, 1fr);
                }
                table.users th:nth-child(4), table.users td:nth-child(4),
                table.users th:nth-child(6), table.users td:nth-child(6) {
                    display: none;
                }
            }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/dashboard/aside.jsp"></jsp:include>

                <div>
                    <header class="topbar">
                        <h1>Người dùng</h1>
                        <span class="crumb">/ <a href="#">Quản trị</a> / Người dùng</span>
                        <div class="top-actions">
                            <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                                <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                                <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            </button>
                            <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/users?action=create">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><path d="M20 8v6M23 11h-6"/></svg>
                            Thêm người dùng
                        </a>
                    </div>
                </header>

                <main>
                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Quản trị · Super Admin</div>
                            <h2 class="page-title">Quản lý người dùng</h2>
                            <div class="page-sub">${totalUsers} tài khoản · Cập nhật ${nowFormatted}</div>
                        </div>
                    </div>

                    <div class="stats-row">
                        <div class="stat"><div class="lbl">Tổng người dùng</div><div class="val">${totalUsers}</div></div>
                        <div class="stat"><div class="lbl">Đang hoạt động</div><div class="val">${activeCount}</div></div>
                        <div class="stat"><div class="lbl">Chờ kích hoạt</div><div class="val">${pendingCount}</div></div>
                        <div class="stat"><div class="lbl">Bị khoá</div><div class="val">${lockedCount}</div></div>
                        <div class="stat"><div class="lbl">Vô hiệu</div><div class="val">${inactiveCount}</div></div>
                    </div>

                    <div class="toolbar">
                        <form method="get" action="${pageContext.request.contextPath}/admin/users" id="filterForm" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;flex:1;">
                            <input type="hidden" name="action" value="list" />
                            <input type="hidden" name="page" id="filterPage" value="1" />
                            <div class="search-input">
                                <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                <input name="search" id="searchInput" value="${searchFilter != null ? searchFilter : ''}" placeholder="Tìm theo tên hoặc email…" autocomplete="off" />
                            </div>
                            <select class="filter-select" name="role" id="filterRole" style="display:none;">
                                <option value="">Vai trò: Tất cả</option>
                                <option value="admin" ${roleFilter == 'admin' ? 'selected' : ''}>Admin</option>
                                <option value="warehouse_manager" ${roleFilter == 'warehouse_manager' ? 'selected' : ''}>Quản lý kho</option>
                                <option value="warehouse_staff" ${roleFilter == 'warehouse_staff' ? 'selected' : ''}>Thủ kho</option>
                                <option value="accountant" ${roleFilter == 'accountant' ? 'selected' : ''}>Kế toán</option>
                                <option value="sales_staff" ${roleFilter == 'sales_staff' ? 'selected' : ''}>Nhân viên</option>
                                <option value="technician" ${roleFilter == 'technician' ? 'selected' : ''}>Kỹ thuật</option>
                                <option value="customer" ${roleFilter == 'customer' ? 'selected' : ''}>Khách hàng</option>
                                <option value="driver" ${roleFilter == 'driver' ? 'selected' : ''}>Tài xế</option>
                            </select>
                            <select class="filter-select" name="status" id="filterStatus">
                                <option value="">Trạng thái: Tất cả</option>
                                <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Đang hoạt động</option>
                                <option value="inactive" ${statusFilter == 'inactive' ? 'selected' : ''}>Vô hiệu</option>
                                <option value="pending" ${statusFilter == 'pending' ? 'selected' : ''}>Chờ kích hoạt</option>
                                <option value="locked" ${statusFilter == 'locked' ? 'selected' : ''}>Bị khoá</option>
                            </select>
                            <div class="spacer"></div>
                            <button type="button" class="btn" id="clearFilters" title="Xoá bộ lọc">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                                Xoá lọc
                            </button>
                        </form>
                    </div>

                    <div class="bulk-bar" id="bulkBar">
                        <span class="count-pill" id="bulkCount">0</span>
                        <span>người dùng đã chọn</span>
                        <div class="bulk-actions">
                            <button class="btn-tiny" data-bulk="role"><svg viewBox="0 0 24 24" width="13" height="13" stroke="currentColor" fill="none" stroke-width="1.8"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg> Đổi vai trò</button>
                            <button class="btn-tiny" data-bulk="lock"><svg viewBox="0 0 24 24" width="13" height="13" stroke="currentColor" fill="none" stroke-width="1.8"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg> Khoá</button>
                            <button class="btn-tiny danger" data-bulk="delete"><svg viewBox="0 0 24 24" width="13" height="13" stroke="currentColor" fill="none" stroke-width="1.8"><path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg> Xoá</button>
                            <button class="btn-tiny" id="bulkClear">Bỏ chọn</button>
                        </div>
                    </div>

                    <div class="table-card">
                        <table class="users" id="usersTable">
                            <thead>
                                <tr>
                                    <th class="col-check"><input type="checkbox" class="checkbox" id="checkAll" /></th>
                                    <th>Người dùng</th>
                                        <%-- <th>Vai trò</th> --%>
                                    <th>Trạng thái</th>
                                    <th>Tham gia</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty users}">
                                        <tr>
                                            <td colspan="5" class="empty-state">
                                                <div class="icon-wrap"><svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg></div>
                                                <strong>Không tìm thấy người dùng</strong>
                                                Thử bỏ bộ lọc hoặc đổi từ khoá tìm kiếm
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="user" items="${users}" varStatus="loop">
                                            <tr data-id="${user.id}">
                                                <td class="col-check"><input type="checkbox" class="checkbox row-check" value="${user.id}" /></td>
                                                <td>
                                                    <div class="user-cell">
                                                        <div class="user-avatar ${loop.index % 7 == 0 ? 'green' : loop.index % 7 == 1 ? 'blue' : loop.index % 7 == 2 ? 'orange' : loop.index % 7 == 3 ? 'purple' : loop.index % 7 == 4 ? 'pink' : loop.index % 7 == 5 ? 'teal' : 'grey'}">
                                                            <c:set var="words" value="${fn:split(fn:trim(user.name), ' ')}" />
                                                            <c:choose>
                                                                <c:when test="${fn:length(words) >= 2}">
                                                                    ${fn:toUpperCase(fn:substring(words[0], 0, 1))}${fn:toUpperCase(fn:substring(words[1], 0, 1))}
                                                                </c:when>
                                                                <c:when test="${fn:length(user.name) >= 2}">
                                                                    ${fn:toUpperCase(fn:substring(user.name, 0, 2))}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${fn:toUpperCase(user.name)}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="user-name-block">
                                                            <div class="user-name">${user.name}</div>
                                                            <div class="user-email">${user.email}</div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <%-- 
                                                <td>
                                                  <c:choose>
                                                    <c:when test="${empty user.roles}">
                                                      <span class="pill role-staff"><span class="pdot"></span>Chưa gán</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                      <c:forEach var="role" items="${user.roles}" varStatus="rs">
                                                        <span class="pill role-${role.roleName}"><span class="pdot"></span>
                                                          <c:choose>
                                                            <c:when test="${role.roleName == 'admin'}">Admin</c:when>
                                                            <c:when test="${role.roleName == 'warehouse_manager'}">Quản lý kho</c:when>
                                                            <c:when test="${role.roleName == 'warehouse_staff'}">Thủ kho</c:when>
                                                            <c:when test="${role.roleName == 'accountant'}">Kế toán</c:when>
                                                            <c:when test="${role.roleName == 'sales_staff'}">Nhân viên</c:when>
                                                            <c:when test="${role.roleName == 'technician'}">Kỹ thuật</c:when>
                                                            <c:when test="${role.roleName == 'customer'}">Khách hàng</c:when>
                                                            <c:when test="${role.roleName == 'driver'}">Tài xế</c:when>
                                                            <c:otherwise>${role.roleName}</c:otherwise>
                                                          </c:choose>
                                                        </span>
                                                      </c:forEach>
                                                    </c:otherwise>
                                                  </c:choose>
                                                </td>
                                                --%>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${user.status == 'active'}">
                                                            <span class="status active"><span class="sdot"></span>Hoạt động</span>
                                                        </c:when>
                                                        <c:when test="${user.status == 'inactive'}">
                                                            <span class="status disabled"><span class="sdot"></span>Vô hiệu</span>
                                                        </c:when>
                                                        <c:when test="${user.status == 'pending'}">
                                                            <span class="status pending"><span class="sdot"></span>Chờ kích hoạt</span>
                                                        </c:when>
                                                        <c:when test="${user.status == 'locked'}">
                                                            <span class="status locked"><span class="sdot"></span>Bị khoá</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status disabled"><span class="sdot"></span>${user.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                </td>
                                                <td class="last-login">
                                                    <div>${user.createdDateStr}</div>
                                                    <c:if test="${not empty user.createdTimeStr}">
                                                        <div class="when">${user.createdTimeStr}</div>
                                                    </c:if>
                                                </td>
                                                <td class="col-actions">
                                                    <div class="row-actions">
                                                        <button class="icon-mini" onclick="location.href = '${pageContext.request.contextPath}/admin/users?action=update&id=${user.id}&page=${currentPage}'" title="Chỉnh sửa">
                                                            <svg viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                                        </button>
                                                        <c:choose>
                                                            <c:when test="${user.status == 'active'}">
                                                                <button class="icon-mini" onclick="confirmDeactivate(${user.id}, ${currentPage})" title="Vô hiệu hoá">
                                                                    <svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button class="icon-mini" onclick="confirmActivate(${user.id}, ${currentPage})" title="Kích hoạt">
                                                                    <svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><path d="M20 8v6M23 11h-6"/></svg>
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                        <div class="pagination">
                            <div class="info">Hiển thị <strong id="rangeFrom">${(currentPage - 1) * 10 + 1}</strong>–<strong id="rangeTo">${currentPage * 10 > totalUsers ? totalUsers : currentPage * 10}</strong> / <strong id="totalFiltered">${totalUsers}</strong> kết quả</div>
                            <div class="controls">
                                <c:if test="${currentPage > 1}">
                                    <a href="?action=list&page=${currentPage - 1}${searchFilter != null ? '&search=' : ''}${searchFilter}${roleFilter != null ? '&role=' : ''}${roleFilter}${statusFilter != null ? '&status=' : ''}${statusFilter}" class="page-btn">‹</a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <c:choose>
                                        <c:when test="${p == currentPage}">
                                            <span class="page-btn active">${p}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="?action=list&page=${p}${searchFilter != null ? '&search=' : ''}${searchFilter}${roleFilter != null ? '&role=' : ''}${roleFilter}${statusFilter != null ? '&status=' : ''}${statusFilter}" class="page-btn">${p}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?action=list&page=${currentPage + 1}${searchFilter != null ? '&search=' : ''}${searchFilter}${roleFilter != null ? '&role=' : ''}${roleFilter}${statusFilter != null ? '&status=' : ''}${statusFilter}" class="page-btn">›</a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>

        <div class="modal-host" id="confirmModal">
            <div class="modal">
                <h3 id="modalTitle">Xác nhận hành động</h3>
                <p id="modalText">Bạn có chắc muốn thực hiện hành động này?</p>
                <div class="actions">
                    <button class="btn" id="modalCancel">Huỷ</button>
                    <button class="btn btn-danger" id="modalConfirm">Xác nhận</button>
                </div>
            </div>
        </div>

        <script>
            window.APP_CTX = '${pageContext.request.contextPath}';
        </script>
        <script src="${pageContext.request.contextPath}/view/admin/admin-js.js"></script>

        <c:if test="${not empty sessionScope.message}">
            <script>
            document.addEventListener('DOMContentLoaded', () => {
                toast('${fn:escapeXml(sessionScope.message)}', 'success');
            });
            </script>
            <c:remove var="message" scope="session" />
        </c:if>

        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
    </body>
</html>

