<%-- 
    Document   : admin-forgotpass
    Created on : May 16, 2026, 1:35:31 AM
    Author     : FPTShop
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- 
    Document   : admin-forgot-password
    Created on : May 16, 2026
    Author     : Admin
--%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý yêu cầu cấp lại mật khẩu</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">

        <style>
            *{
                margin:0;
                padding:0;
                box-sizing:border-box;
            }

            body{
                font-family:'Be Vietnam Pro', sans-serif;
                background:#f5f7fb;
                color:#1e293b;
            }

            .container{
                width:95%;
                margin:30px auto;
            }

            .page-header{
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:25px;
            }

            .page-title{
                font-size:28px;
                font-weight:700;
            }

            .page-sub{
                margin-top:6px;
                color:#64748b;
                font-size:14px;
            }

            .stats{
                display:grid;
                grid-template-columns:repeat(3,1fr);
                gap:20px;
                margin-bottom:25px;
            }

            .card{
                background:#fff;
                border-radius:12px;
                padding:20px;
                border:1px solid #e2e8f0;
            }

            .card-title{
                font-size:14px;
                color:#64748b;
                margin-bottom:10px;
            }

            .card-value{
                font-size:30px;
                font-weight:700;
            }

            .table-wrapper{
                background:#fff;
                border-radius:12px;
                overflow:hidden;
                border:1px solid #e2e8f0;
            }

            table{
                width:100%;
                border-collapse:collapse;
            }

            thead{
                background:#f8fafc;
            }

            th{
                padding:16px;
                text-align:left;
                font-size:13px;
                color:#64748b;
                border-bottom:1px solid #e2e8f0;
            }

            td{
                padding:16px;
                border-bottom:1px solid #e2e8f0;
                font-size:14px;
            }

            tr:hover{
                background:#f8fafc;
            }

            .status{
                padding:5px 10px;
                border-radius:20px;
                font-size:12px;
                font-weight:600;
                display:inline-block;
            }

            .pending{
                background:#fef3c7;
                color:#92400e;
            }

            .done{
                background:#dcfce7;
                color:#166534;
            }

            .btn{
                border:none;
                padding:10px 14px;
                border-radius:8px;
                cursor:pointer;
                font-weight:600;
                font-size:13px;
            }

            .btn-reset{
                background:#111827;
                color:white;
            }

            .btn-reset:hover{
                background:#1f2937;
            }

            .btn-view{
                background:#e2e8f0;
            }

            .btn-view:hover{
                background:#cbd5e1;
            }

            .action-group{
                display:flex;
                gap:10px;
            }

            .modal{
                position:fixed;
                inset:0;
                background:rgba(0,0,0,0.4);
                display:none;
                justify-content:center;
                align-items:center;
            }

            .modal-content{
                width:450px;
                background:white;
                border-radius:14px;
                padding:24px;
            }

            .modal-title{
                font-size:20px;
                font-weight:700;
                margin-bottom:20px;
            }

            .form-group{
                margin-bottom:16px;
            }

            .form-group label{
                display:block;
                margin-bottom:8px;
                font-size:14px;
                font-weight:600;
            }

            .form-group input,
            .form-group textarea{
                width:100%;
                padding:12px;
                border:1px solid #cbd5e1;
                border-radius:8px;
                font-size:14px;
            }

            .form-group textarea{
                resize:none;
                height:90px;
            }

            .modal-actions{
                display:flex;
                justify-content:flex-end;
                gap:12px;
                margin-top:20px;
            }

            .btn-cancel{
                background:#e2e8f0;
            }

            .btn-save{
                background:#2563eb;
                color:white;
            }

            .btn-save:hover{
                background:#1d4ed8;
            }

        </style>
    </head>
    <body>

        <div class="container">

            <div class="page-header">
                <div>
                    <div class="page-title">Quản lý yêu cầu quên mật khẩu</div>
                    <div class="page-sub">
                        Admin xử lý yêu cầu cấp lại tài khoản cho người dùng
                    </div>
                </div>

                <a href="admin-user.jsp" class="back-btn">
                    ← Quay lại Dashboard
                </a>
            </div>

            <div class="stats">

                <div class="card">
                    <div class="card-title">Tổng yêu cầu</div>
                    <div class="card-value">24</div>
                </div>

                <div class="card">
                    <div class="card-title">Đang chờ xử lý</div>
                    <div class="card-value">7</div>
                </div>

                <div class="card">
                    <div class="card-title">Đã cấp lại</div>
                    <div class="card-value">17</div>
                </div>

            </div>

            <div class="table-wrapper">

                <table>

                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Họ tên</th>
                            <th>Email</th>
                            <th>SĐT</th>
                            <th>Lý do</th>
                            <th>Trạng thái</th>
                            <th>Ngày gửi</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>

                    <tbody>

                        <tr>
                            <td>#FP001</td>
                            <td>Nguyễn Văn A</td>
                            <td>vana@gmail.com</td>
                            <td>0909123123</td>
                            <td>Quên mật khẩu đăng nhập</td>
                            <td>
                                <span class="status pending">
                                    Chờ xử lý
                                </span>
                            </td>
                            <td>16/05/2026</td>
                            <td>
                                <div class="action-group">
                                    <button class="btn btn-view">
                                        Xem
                                    </button>

                                    <button class="btn btn-reset"
                                            onclick="openModal(
                                                    'Nguyễn Văn A',
                                                    'vana@gmail.com'
                                                    )">
                                        Cấp lại
                                    </button>
                                </div>
                            </td>
                        </tr>

                        <tr>
                            <td>#FP002</td>
                            <td>Trần Thị B</td>
                            <td>thib@gmail.com</td>
                            <td>0911222333</td>
                            <td>Mất tài khoản cũ</td>
                            <td>
                                <span class="status done">
                                    Đã cấp lại
                                </span>
                            </td>
                            <td>15/05/2026</td>
                            <td>
                                <div class="action-group">
                                    <button class="btn btn-view">
                                        Chi tiết
                                    </button>
                                </div>
                            </td>
                        </tr>

                    </tbody>

                </table>

            </div>

        </div>

        <div class="modal" id="resetModal">

            <div class="modal-content">

                <div class="modal-title">
                    Cấp lại mật khẩu
                </div>

                <form action="reset-password" method="post">

                    <div class="form-group">
                        <label>Họ tên</label>
                        <input type="text" id="fullName" readonly>
                    </div>

                    <div class="form-group">
                        <label>Email</label>
                        <input type="text" id="email" readonly>
                    </div>

                    <div class="form-group">
                        <label>Mật khẩu mới</label>
                        <input type="password"
                               name="newPassword"
                               placeholder="Nhập mật khẩu mới..."
                               required>
                    </div>

                    <div class="form-group">
                        <label>Ghi chú cho người dùng</label>
                        <textarea name="note"
                                  placeholder="Ví dụ: vui lòng đổi mật khẩu sau lần đăng nhập đầu tiên"></textarea>
                    </div>

                    <div class="modal-actions">

                        <button type="button"
                                class="btn btn-cancel"
                                onclick="closeModal()">
                            Huỷ
                        </button>

                        <button type="submit"
                                class="btn btn-save">
                            Xác nhận cấp lại
                        </button>

                    </div>

                </form>

            </div>

        </div>

        <script>

            const modal = document.getElementById("resetModal");

            function openModal(name, email) {

                modal.style.display = "flex";

                document.getElementById("fullName").value = name;
                document.getElementById("email").value = email;
            }

            function closeModal() {
                modal.style.display = "none";
            }

            window.onclick = function (e) {

                if (e.target === modal) {
                    closeModal();
                }
            }

        </script>

    </body>
</html>