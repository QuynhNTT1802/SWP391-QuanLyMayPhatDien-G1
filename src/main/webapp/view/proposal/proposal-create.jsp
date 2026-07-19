<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Tạo đề xuất nhập kho - Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
<<<<<<< HEAD
        <style>
            h1,h2,h3,h4{font-weight:700;letter-spacing:-0.01em}
            label,.label{font-weight:600}
            input,select,textarea,button{font-weight:500}
            .mono{font-family:var(--font-mono);font-variant-numeric:tabular-nums}
            main{padding:24px 32px 60px;max-width:880px;margin:0 auto}
            .page-head{margin-bottom:20px}
            .eyebrow{display:inline-flex;align-items:center;gap:6px;font-size:11px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:var(--accent);margin-bottom:8px}
            .eyebrow::before{content:'';width:5px;height:5px;border-radius:50%;background:var(--accent)}
            .page-head h1.title{font-size:26px;font-weight:700;letter-spacing:-0.02em;margin:0}
            .page-head .lede{color:var(--muted);margin-top:6px;max-width:640px;font-size:14px}
            .section{background:var(--surface);border:1px solid var(--border);border-radius:10px;overflow:hidden;margin-bottom:16px}
            .section-head{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:16px 20px;border-bottom:1px solid var(--border)}
            .section-head h3{font-size:14px;font-weight:700;margin:0}
            .section-head .sub{font-size:11.5px;color:var(--muted);font-family:var(--font-mono)}
            .section-body{padding:22px 20px}
            .field-grid{display:grid;grid-template-columns:1fr 1fr;gap:18px 20px}
            .field{display:flex;flex-direction:column;gap:6px;min-width:0}
            .field.full{grid-column:1/-1}
            .field-label{font-size:12px;font-weight:600;color:var(--muted);text-transform:uppercase;letter-spacing:0.04em;display:flex;align-items:center;justify-content:space-between}
            .field-label .req{color:var(--danger);margin-inline-start:2px}
            .input,.select{font-family:var(--font-ui);font-size:14px;color:var(--fg);background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-sm);padding:9px 12px;width:100%;line-height:1.4;box-sizing:border-box}
            .input:focus,.select:focus{outline:none;border-color:var(--accent);box-shadow:0 0 0 3px var(--accent-soft)}
            .select{appearance:none;background-image:url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23999' stroke-width='2'><path d='m6 9 6 6 6-6'/></svg>");background-repeat:no-repeat;background-position:right 10px center;background-size:14px;padding-inline-end:32px;cursor:pointer}
            textarea.input{min-height:80px;resize:vertical}
            .dropzone{position:relative;border:2px dashed var(--border);border-radius:var(--radius);background:var(--surface-2);padding:48px 24px 36px;text-align:center;transition:all .18s ease;cursor:pointer;margin-bottom:14px}
            .dropzone:hover{border-color:var(--accent);background:var(--accent-soft)}
            .dropzone.drag-over,.dropzone.has-file{border-color:var(--accent);background:var(--accent-soft)}
            .dropzone input[type=file]{position:absolute;inset:0;opacity:0;cursor:pointer}
            .dz-icon{width:64px;height:64px;margin:0 auto 14px;border-radius:50%;background:var(--surface);color:var(--accent);display:grid;place-items:center;border:1px solid var(--border)}
            .dz-icon svg{width:28px;height:28px;stroke:currentColor;fill:none;stroke-width:1.6}
            .dz-title{font-size:15px;font-weight:600;color:var(--fg);margin:0 0 4px}
            .dz-title strong{color:var(--accent);font-weight:700}
            .dz-sub{font-size:12.5px;color:var(--muted);margin:0}
            .file-info{display:none;align-items:center;gap:12px;padding:12px 16px;background:var(--surface);border:1px solid color-mix(in srgb,var(--accent) 30%,transparent);border-radius:var(--radius-sm);margin-bottom:14px;text-align:left}
            .file-info.show{display:flex}
            .file-info .fi-icon{width:36px;height:36px;border-radius:8px;background:var(--accent-soft);color:var(--accent);display:grid;place-items:center;flex-shrink:0}
            .file-info .fi-icon svg{width:18px;height:18px;stroke:currentColor;fill:none;stroke-width:1.8}
            .file-info .fi-body{flex:1;min-width:0}
            .file-info .fi-name{font-size:13.5px;font-weight:600;color:var(--fg);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
            .file-info .fi-meta{font-size:11.5px;color:var(--muted);margin-top:2px}
            .file-info .fi-remove{background:0 0;border:0;color:var(--danger);cursor:pointer;padding:6px;border-radius:var(--radius-sm)}
            .file-info .fi-remove:hover{background:var(--danger-soft)}
            .file-info .fi-remove svg{width:16px;height:16px;stroke:currentColor;fill:none;stroke-width:2}
            .btn{display:inline-flex;align-items:center;gap:6px;border:1px solid var(--border);background:var(--surface);color:var(--fg);padding:8px 16px;border-radius:var(--radius-sm);font-size:13px;font-weight:600;cursor:pointer;font-family:var(--font-ui);text-decoration:none}
            .btn:hover{background:var(--surface-2)}
            .btn-primary{background:var(--fg);color:var(--bg);border-color:var(--fg)}
            .btn-primary:hover{background:var(--fg-soft);border-color:var(--fg-soft)}
            .btn:disabled{opacity:.4;cursor:not-allowed}
            .actions{display:flex;gap:10px;justify-content:flex-end;margin-top:20px;flex-wrap:wrap}
            .notice{padding:14px 18px;border-radius:var(--radius-sm);margin-top:16px;font-size:13px;font-weight:500;background:var(--info-soft);color:var(--info);border:1px solid color-mix(in srgb,var(--info) 25%,transparent);line-height:1.7}
            .notice ul{margin:6px 0 0;padding-left:18px}
            .notice ul li{margin-bottom:2px}
            .topbar{position:sticky;top:0;z-index:10;background:color-mix(in srgb,var(--bg) 85%,transparent);backdrop-filter:blur(8px);border-bottom:1px solid var(--border);display:flex;align-items:center;gap:16px;padding:12px 24px}
            .topbar h1{font-size:16px;font-weight:700;margin:0;letter-spacing:-0.01em}
            .crumb{color:var(--muted);font-size:13px;font-weight:500}
            .top-actions{margin-inline-start:auto;display:flex;align-items:center;gap:8px}
            .icon-btn{width:32px;height:32px;border:1px solid var(--border);background:var(--surface);color:var(--fg-soft);border-radius:var(--radius-sm);display:grid;place-items:center;cursor:pointer}
            .icon-btn:hover{background:var(--surface-2);color:var(--fg)}
            .icon-btn svg{width:15px;height:15px;stroke:currentColor;fill:none;stroke-width:1.6}
            .alert{padding:12px 16px;border-radius:var(--radius-sm);margin-bottom:16px;font-size:13px;font-weight:600;display:flex;align-items:center;gap:10px;border:1px solid}
            .alert svg{width:18px;height:18px;stroke:currentColor;fill:none;stroke-width:2;flex-shrink:0}
            .alert-error{background:var(--danger-soft);color:var(--danger);border-color:color-mix(in srgb,var(--danger) 30%,transparent)}
            .back-link{display:inline-flex;align-items:center;gap:6px;color:var(--muted);text-decoration:none;font-size:13px;font-weight:600;margin-bottom:14px}
            .back-link:hover{color:var(--fg)}
        </style>
=======
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/create-user.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/searchable-dropdown.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customer-picker.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/proposal-create.css">
>>>>>>> 43e4ad0e5deebd88847eabeffbcf9cd1a13a3749
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>
            <div>
                <header class="topbar">
                    <h1>Tạo đề xuất</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/proposal">Đề xuất nhập kho</a> / Tạo mới</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                        <jsp:include page="../common/admin/bell.jsp"/>
                    </div>
                </header>
                <main>
                    <a class="back-link" href="${pageContext.request.contextPath}/proposal">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại danh sách
                    </a>

                    <script>
                        <c:if test="${not empty sessionScope.toastMessage}">
                            window.SESSION_DATA = {
                                message: '<c:out value="${sessionScope.toastMessage}"/>',
                                type: '<c:out value="${sessionScope.toastType}"/>'
                            };
                            <c:remove var="toastMessage" scope="session"/>
                            <c:remove var="toastType" scope="session"/>
                        </c:if>
                    </script>

                    <div class="page-head">
                        <div class="eyebrow">Đề xuất nhập kho · Tạo mới</div>
                        <h2 class="page-title">Tạo phiếu đề xuất nhập</h2>
                        <p class="page-sub">Chọn kho + nhà cung cấp, sau đó thêm từng dòng máy cần đề xuất.</p>
                    </div>

                    <form id="proposalForm" method="POST" action="${pageContext.request.contextPath}/proposal?action=save" onsubmit="return validateForm()">
                        <div class="form-card">
                            <div class="form-section">
                                <div class="form-section-head">
                                    <div>
                                        <div class="form-section-num">01 — THÔNG TIN CHUNG</div>
                                        <h3 class="form-section-title">Thông tin chung</h3>
                                    </div>
                                </div>

                                <div class="field">
                                    <label class="field-label" for="warehouseId">Kho nhập <span class="req">*</span></label>
                                    <select class="select" id="warehouseId" name="warehouseId" required
                                            onchange="if (this.value) {
                                                location.href = '${pageContext.request.contextPath}/proposal?action=create&amp;warehouseId=' + this.value;
                                            }">
                                        <option value="">-- Chọn kho --</option>
                                        <c:forEach var="w" items="${warehouses}">
                                            <option value="${w.warehouseId}" <c:if test="${w.warehouseId == selectedWarehouseId}">selected</c:if>><c:out value="${w.name}"/></option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="cust-subhead">
                                    <h4>Nhà cung cấp <span class="req">*</span></h4>
                                </div>
                                <p class="kv-hint">Chọn nhà cung cấp có sẵn hoặc thêm mới để gán vào phiếu đề xuất.</p>

                                <div id="custPicker">
                                    <div class="sd" id="customerDropdown"
                                         data-endpoint="${pageContext.request.contextPath}/warehouse/suppliers?action=search&q=">
                                        <div class="cust-trigger-wrap">
                                            <button type="button" class="cust-trigger" id="custTrigger"
                                                    onclick="openCustomerPanel()" aria-haspopup="dialog">
                                                <span class="cust-trigger-label" id="custTriggerLabel">-- Click để chọn nhà cung cấp --</span>
                                                <svg class="cust-trigger-icon" viewBox="0 0 24 24" aria-hidden="true">
                                                <path d="M21 21l-4.35-4.35M11 19a8 8 0 1 1 0-16 8 8 0 0 1 0 16z" stroke="currentColor" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                                                </svg>
                                            </button>
                                            <button type="button" class="cust-clear-btn" id="custClearBtn"
                                                    onclick="clearCustomerSelection()" title="Hủy chọn nhà cung cấp" aria-label="Hủy chọn">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M18 6L6 18M6 6l12 12"/>
                                                </svg>
                                            </button>
                                        </div>
                                        <input type="hidden" name="supplierId" id="sdHiddenId" value="" />
                                        <input type="hidden" id="inpCustName" value="" />
                                        <input type="hidden" id="inpCustPhone" value="" />
                                        <input type="hidden" id="inpCustEmail" value="" />
                                        <input type="hidden" id="inpCustAddress" value="" />
                                        <input type="hidden" id="customerCompany" value="" />
                                    </div>

                                    <c:if test="${canCreateSupplier}">
                                        <button type="button" class="btn btn-primary" onclick="openNewSupplierModal()" style="margin-top:10px;">
                                            <svg class="icon" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5v14M5 12h14"/></svg>
                                            Thêm NCC mới
                                        </button>
                                    </c:if>
                                </div>

                                <div id="customerCardContainer" class="customer-info-card" style="display:none;"></div>

                                <div class="field" style="margin-top:20px;">
                                    <label class="field-label" for="note">Ghi chú</label>
                                    <textarea class="textarea" id="note" name="note" rows="2" placeholder="VD: Đề xuất nhập máy phát cho kho HCM..."></textarea>
                                </div>
                            </div>
                        </div>

                        <div class="form-card">
                            <div class="form-section">
                                <div class="form-section-head">
                                    <div>
                                        <div class="form-section-num">02 — DANH SÁCH MÁY PHÁT</div>
                                        <h3 class="form-section-title">Chi tiết sản phẩm</h3>
                                    </div>
                                    <div class="section-actions-bar">
                                        <a class="btn btn-sm" href="${pageContext.request.contextPath}/proposal?action=downloadTemplate">
                                            <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                                            Tải mẫu Excel
                                        </a>
                                        <button type="button" class="btn btn-sm" onclick="triggerImportExcel()">
                                            <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                                            Import Excel
                                        </button>
                                    </div>
                                </div>

                                <c:if test="${canCreateGenerator}">
                                    <div class="gen-toolbar">
                                        <button type="button" class="btn btn-primary btn-sm" onclick="openNewGeneratorModal()">
                                            <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5v14M5 12h14"/></svg>
                                            Thêm máy phát mới
                                        </button>
                                    </div>
                                </c:if>

                                <table class="detail-table">
                                    <thead>
                                        <tr>
                                            <th class="col-num">#</th>
                                            <th>Mẫu máy <span class="req">*</span></th>
                                            <th class="col-stock">Tồn kho</th>
                                            <th class="col-qty">Số lượng <span class="req">*</span></th>
                                            <th class="col-price">Đơn giá (VNĐ) <span class="req">*</span></th>
                                            <th class="col-price">Thành tiền</th>
                                            <th class="col-del"></th>
                                        </tr>
                                    </thead>
                                    <tbody id="detailBody">
                                        <tr>
                                            <td class="col-num"><span class="row-num">1</span></td>
                                            <td>
                                                <select name="generatorId" class="gen-select" required onchange="updateStockCell(this)">
                                                    <option value="">-- Chọn máy --</option>
                                                    <c:forEach var="g" items="${generators}">
                                                        <option value="${g.id}"><c:out value="${g.model}"/></option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td class="col-stock"><span class="row-stock mono">—</span></td>
                                            <td><input type="text" inputmode="numeric" name="quantity" class="qty-input" value="1" maxlength="4" oninput="validateQty(this);updateTotal()" onblur="finalizeQty(this)" required /></td>
                                            <td><input type="text" inputmode="numeric" name="unitPrice" class="unit-price-input mono" value="0" oninput="validateUnitPrice(this);updateTotal()" onfocus="unformatPrice(this)" onblur="finalizeUnitPrice(this)" required /></td>
                                            <td class="col-price row-subtotal-cell"><span class="row-subtotal mono">0₫</span></td>
                                            <td class="col-del"><button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button></td>
                                        </tr>
                                    </tbody>
                                    <tfoot>
                                        <tr class="total-row">
                                            <td colspan="5" class="text-right">Tổng cộng:</td>
                                            <td class="text-right mono" id="grandTotal">0₫</td>
                                            <td></td>
                                        </tr>
                                    </tfoot>
                                </table>

                                <button type="button" class="btn add-row-btn" onclick="addRow()">
                                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5v14M5 12h14"/></svg>
                                    Thêm dòng
                                </button>

                                <template id="rowTemplate">
                                    <tr>
                                        <td class="col-num"><span class="row-num"></span></td>
                                        <td>
                                            <select name="generatorId" class="gen-select" required onchange="updateStockCell(this)">
                                                <option value="">-- Chọn máy --</option>
                                                <c:forEach var="g" items="${generators}">
                                                    <option value="${g.id}"><c:out value="${g.model}"/></option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td class="col-stock"><span class="row-stock mono">—</span></td>
                                        <td><input type="text" inputmode="numeric" name="quantity" class="qty-input" value="1" maxlength="4" oninput="validateQty(this);updateTotal()" onblur="finalizeQty(this)" required /></td>
                                        <td><input type="text" inputmode="numeric" name="unitPrice" class="unit-price-input mono" value="0" oninput="validateUnitPrice(this);updateTotal()" onfocus="unformatPrice(this)" onblur="finalizeUnitPrice(this)" required /></td>
                                        <td class="col-price row-subtotal-cell"><span class="row-subtotal mono">0₫</span></td>
                                        <td class="col-del"><button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button></td>
                                    </tr>
                                </template>
                            </div>
                        </div>

                        <div class="form-actions">
                            <a class="btn" href="${pageContext.request.contextPath}/proposal">Huỷ</a>
                            <button type="submit" name="submitType" value="submit" class="btn btn-primary">
                                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                                Gửi duyệt
                            </button>
                        </div>
                    </form>
<<<<<<< HEAD
                    <div class="notice">
                        <strong>Lưu ý:</strong>
                        <ul>
                            <li>File Excel phải theo đúng biểu mẫu, không thay đổi cấu trúc cột.</li>
                            
                            <li>Số lượng phải là số nguyên dương, không vượt quá 9999</li>
                            <li>Ở bước xem trước, bạn có thể chọn <strong>Lưu nháp</strong> hoặc <strong>Gửi duyệt</strong> tùy nhu cầu.</li>
                        </ul>
                    </div>
=======
>>>>>>> 43e4ad0e5deebd88847eabeffbcf9cd1a13a3749
                </main>
            </div>
        </div>

        <div class="modal-host" id="genModalOverlay">
            <div class="modal">
                <div class="modal-head">
                    <h3>Thêm máy phát mới</h3>
                    <button type="button" class="modal-close" onclick="closeNewGeneratorModal()">&times;</button>
                </div>
                <p class="modal-sub">Máy phát sẽ được thêm vào dropdown của mọi dòng bên dưới.</p>
                <div class="modal-error" id="genModalError"></div>
                <div class="modal-grid">
                    <div>
                        <label class="field-label">Mã máy phát (model) <span class="req">*</span></label>
                        <input class="input" id="ngModel" placeholder="VD: Honda EU22i" />
                    </div>
                    <div>
                        <label class="field-label">Công suất (kVA) <span class="req">*</span></label>
                        <input class="input mono" id="ngPower" type="number" step="0.01" placeholder="VD: 50" />
                    </div>
                    <div>
                        <label class="field-label">Tần số (Hz)</label>
                        <input class="input mono" id="ngFreq" placeholder="VD: 50" />
                    </div>
                    <div>
                        <label class="field-label">Trọng lượng (kg)</label>
                        <input class="input mono" id="ngWeight" type="number" step="0.01" placeholder="VD: 120" />
                    </div>
                    <div>
                        <label class="field-label">Thương hiệu</label>
                        <select class="select" id="ngBrandId">
                            <option value="">-- Chọn --</option>
                            <c:forEach var="b" items="${catBrands}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                            </select>
                        </div>
                        <div>
                            <label class="field-label">Xuất xứ</label>
                            <select class="select" id="ngOriginId">
                                <option value="">-- Chọn --</option>
                            <c:forEach var="b" items="${catOrigins}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                            </select>
                        </div>
                        <div>
                            <label class="field-label">Tình trạng</label>
                            <select class="select" id="ngConditionId">
                                <option value="">-- Chọn --</option>
                            <c:forEach var="b" items="${catConditions}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                            </select>
                        </div>
                        <div>
                            <label class="field-label">Nhiên liệu</label>
                            <select class="select" id="ngFuelTypeId">
                                <option value="">-- Chọn --</option>
                            <c:forEach var="b" items="${catFuelTypes}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                            </select>
                        </div>
                        <div>
                            <label class="field-label">Số pha</label>
                            <select class="select" id="ngPhaseId">
                                <option value="">-- Chọn --</option>
                            <c:forEach var="b" items="${catPhases}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                            </select>
                        </div>
                        <div>
                            <label class="field-label">Loại máy phát</label>
                            <select class="select" id="ngGenTypeId">
                                <option value="">-- Chọn --</option>
                            <c:forEach var="b" items="${catGenTypes}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="modal-actions">
                        <button type="button" class="btn" onclick="closeNewGeneratorModal()">Huỷ</button>
                        <button type="button" class="btn btn-primary" id="ngSaveBtn" onclick="saveNewGenerator()">Lưu máy phát</button>
                    </div>
                </div>
            </div>

            <div class="modal-host" id="supModalOverlay">
                <div class="modal">
                    <div class="modal-head">
                        <h3>Thêm nhà cung cấp mới</h3>
                        <button type="button" class="modal-close" onclick="closeNewSupplierModal()">&times;</button>
                    </div>
                    <p class="modal-sub">Nhà cung cấp sẽ được áp dụng cho toàn bộ phiếu.</p>
                    <div class="modal-error" id="supModalError"></div>
                    <div class="modal-grid">
                        <div>
                            <label class="field-label">Tên nhà cung cấp <span class="req">*</span></label>
                            <input class="input" id="nsName" placeholder="VD: Nguyễn Văn B" />
                        </div>
                        <div>
                            <label class="field-label">Số điện thoại <span class="req">*</span></label>
                            <input class="input mono" id="nsPhone" type="tel" placeholder="VD: 0912345678" inputmode="numeric" maxlength="11" />
                        </div>
                        <div>
                            <label class="field-label">Email</label>
                            <input class="input mono" id="nsEmail" type="email" placeholder="email@example.com" />
                        </div>
                        <div>
                            <label class="field-label">Loại NCC</label>
                            <select class="select" id="nsTypeId">
                                <option value="">-- Chọn --</option>
                            <c:forEach var="t" items="${supplierTypeList}"><option value="${t.id}"><c:out value="${t.name}"/></option></c:forEach>
                            </select>
                        </div>
                        <div class="span-2">
                            <label class="field-label">Tên công ty</label>
                            <input class="input" id="nsCompanyName" placeholder="VD: Công ty TNHH ABC" />
                        </div>
                        <div class="span-2">
                            <label class="field-label">Địa chỉ</label>
                            <textarea class="textarea" id="nsAddress" rows="2" placeholder="Địa chỉ NCC"></textarea>
                        </div>
                    </div>
                    <div class="modal-actions">
                        <button type="button" class="btn" onclick="closeNewSupplierModal()">Huỷ</button>
                        <button type="button" class="btn btn-primary" id="nsSaveBtn" onclick="saveNewSupplier()">Lưu NCC</button>
                    </div>
                </div>
            </div>

            <div class="side-panel-overlay" id="custPanelOverlay" onclick="closeCustomerPanel()"></div>
            <div class="side-panel" id="custSidePanel">
                <div class="side-panel-head">
                    <h3 class="side-panel-title">Chọn nhà cung cấp</h3>
                    <button type="button" class="side-panel-close" onclick="closeCustomerPanel()">&times;</button>
                </div>
                <div class="side-panel-body">
                    <div class="sp-search-bar">
                        <input type="text" id="custSearchInput" class="serial-search-box" placeholder="Tìm nhanh theo tên, SĐT, email..." />
                        <select id="custSortOrder" class="serial-search-box sp-sort">
                            <option value="name_asc">Tên A-Z</option>
                            <option value="name_desc">Tên Z-A</option>
                            <option value="newest">Mới nhất</option>
                        </select>
                    </div>
                    <div id="custLoading" class="sp-loading">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10" stroke-dasharray="31.4 31.4" stroke-dashoffset="10"><animateTransform attributeName="transform" type="rotate" from="0 12 12" to="360 12 12" dur="0.8s" repeatCount="indefinite"/></circle>
                        </svg><br>Đang tải...
                    </div>
                    <div class="cust-list-wrap" id="custList"></div>
                </div>
            </div>

            <input type="file" id="importExcelFile" name="excelFile"
                   accept=".xlsx,.xls"
                   style="display:none"
                   onchange="uploadExcelFile(this)" />

            <div class="toast-host" id="toastHost"></div>
            <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script>
            var STOCK_MAP = {};
            <c:forEach var="entry" items="${stockByGen}">
            STOCK_MAP['${entry.key}'] = ${entry.value};
            </c:forEach>
        </script>
        <script>
var MSG = {};
MSG.QTY_ZERO = 'Số lượng phải lớn hơn 0.';
MSG.QTY_ONLY_NUM = 'Số lượng chỉ được nhập số!';
MSG.DG_ONLY_NUM = 'Đơn giá chỉ được nhập số!';
MSG.SEL_WAREHOUSE = 'Vui lòng chọn kho nhập.';
MSG.SEL_SUPPLIER = 'Vui lòng chọn nhà cung cấp.';
MSG.SEL_ONE_GEN = 'Vui lòng chọn ít nhất 1 máy phát điện.';
MSG.QTY_ROW = 'Số lượng ở dòng ';
MSG.DG_ROW = 'Đơn giá ở dòng ';
MSG.GT_ZERO = ' phải lớn hơn 0.';
MSG.ERR_MODEL_INFO = 'Vui lòng nhập mã máy phát và công suất.';
MSG.ERR_CONTACT = 'Vui lòng nhập tên và SĐT hợp lệ (10-11 chữ số).';
MSG.SAVING = 'Đang lưu...';
MSG.SAVE_GEN = 'Lưu máy phát';
MSG.SAVE_SUP = 'Lưu NCC';
MSG.ERR = 'Lỗi';
MSG.CONN_ERR = 'Lỗi kết nối';
MSG.EXIST_GEN_PREFIX = 'Mã "';
MSG.EXIST_GEN_SUFFIX = '" đã có — đã thêm vào dropdown.';
MSG.ADDED_GEN_PREFIX = 'Đã thêm máy phát "';
MSG.ADDED_GEN_SUFFIX = '"';
MSG.EXIST_SUP_PREFIX = 'SĐT đã có NCC: ';
MSG.EXIST_SUP_SUFFIX = ' — đã tự chọn.';
MSG.ADDED_SUP_PREFIX = 'Đã thêm NCC "';
MSG.ADDED_SUP_SUFFIX = '"';
</script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/searchable-dropdown.js" charset="UTF-8"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/proposal-create.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                if (window.SESSION_DATA && window.SESSION_DATA.message && typeof showToast === 'function') {
                    showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
                }
<<<<<<< HEAD
                function formatSize(b) {
                    if (b < 1024) return b + ' B';
                    if (b < 1024 * 1024) return (b / 1024).toFixed(1) + ' KB';
                    return (b / 1024 / 1024).toFixed(2) + ' MB';
                }
                function showFile(file) {
                    if (!file) return;
                    if (!/\.xlsx?$/i.test(file.name)) { alert('Chỉ chấp nhận file Excel (.xlsx, .xls)'); return; }
                    if (file.size > 10 * 1024 * 1024) { alert('File vượt quá 10MB'); return; }
                    fileName.textContent = file.name;
                    fileMeta.textContent = formatSize(file.size) + ' - Sẵn sàng tải lên';
                    fileInfo.classList.add('show');
                    dropzone.classList.add('has-file');
                    refreshUploadBtn();
                }
                function clearFile() {
                    fileInput.value = '';
                    fileInfo.classList.remove('show');
                    dropzone.classList.remove('has-file');
                    refreshUploadBtn();
                }
                fileInput.addEventListener('change', function () {
                    if (fileInput.files && fileInput.files[0]) showFile(fileInput.files[0]);
                });
                if (warehouseSelect) warehouseSelect.addEventListener('change', refreshUploadBtn);
                fileRemove.addEventListener('click', clearFile);
                ['dragenter','dragover'].forEach(function (e) {
                    dropzone.addEventListener(e, function (ev) { ev.preventDefault(); ev.stopPropagation(); dropzone.classList.add('drag-over'); });
                });
                ['dragleave','drop'].forEach(function (e) {
                    dropzone.addEventListener(e, function (ev) { ev.preventDefault(); ev.stopPropagation(); dropzone.classList.remove('drag-over'); });
                });
                dropzone.addEventListener('drop', function (e) {
                    if (e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files[0]) {
                        fileInput.files = e.dataTransfer.files;
                        showFile(e.dataTransfer.files[0]);
                    }
                });
                refreshUploadBtn();
            })();
=======
            });
>>>>>>> 43e4ad0e5deebd88847eabeffbcf9cd1a13a3749
        </script>
    </body>
</html>
