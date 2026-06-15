/*
 * Constants chuẩn hoá tên module dùng cho SystemLogger.
 * Mọi nơi log nên dùng các hằng số này thay vì literal string,
 * để dropdown filter và truy vấn theo module luôn nhất quán.
 */
package com.quanlymayphatdien.g1.utils;

public final class LogModule {

    private LogModule() {}

    public static final String SYSTEM       = "Hệ thống";
    public static final String AUTH         = "Xác thực";
    public static final String USER         = "Quản lý người dùng";
    public static final String ROLE         = "Phân quyền";
    public static final String CATEGORY     = "Quản lý danh mục";
    public static final String WAREHOUSE    = "Quản lý kho";
    public static final String GENERATOR    = "Quản lý vật tư";
    public static final String INVENTORY    = "Quản lý tồn kho";
    public static final String RECEIPT      = "Quản lý phiếu xuất nhập";
    public static final String TRANSFER     = "Quản lý chuyển kho";
    public static final String ORDER        = "Quản lý đơn bán";
    public static final String PROPOSAL     = "Quản lý đề xuất";
    public static final String PURCHASE     = "Quản lý mua hàng";
    public static final String LIQUIDATION  = "Quản lý thanh lý";
    public static final String STOCK_CARD   = "Thẻ kho";
}
