package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Transfer;
import com.quanlymayphatdien.g1.entity.TransferDetail;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author FPTShop
 */
public class TransferDAO extends DBContext implements I_DAO<Transfer> {

    public String generateTransferCode() {
        String date = LocalDateTime.now().toString().substring(0, 10).replace("-", "");
        String suffix = String.format("%03d", System.currentTimeMillis() % 1000);
        return "TRF-" + date + "-" + suffix;
    }

    @Override
    public List<Transfer> findAll() {
        List<Transfer> list = new ArrayList<>();
        String sql = "SELECT t.*, "
                   + "  ws.name AS source_warehouse_name, "
                   + "  wd.name AS dest_warehouse_name, "
                   + "  u1.name AS created_by_name, "
                   + "  u2.name AS manager_reviewed_by_name, "
                   + "  u3.name AS ceo_reviewed_by_name, "
                   + "  u4.name AS final_reviewed_by_name "
                   + "FROM transfer t "
                   + "LEFT JOIN warehouse ws ON t.source_warehouse_id = ws.warehouse_id "
                   + "LEFT JOIN warehouse wd ON t.dest_warehouse_id = wd.warehouse_id "
                   + "LEFT JOIN user u1 ON t.created_by = u1.id "
                   + "LEFT JOIN user u2 ON t.manager_reviewed_by = u2.id "
                   + "LEFT JOIN user u3 ON t.ceo_reviewed_by = u3.id "
                   + "LEFT JOIN user u4 ON t.final_reviewed_by = u4.id "
                   + "ORDER BY t.created_at DESC";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(getFromResultSet(rs));
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return list;
    }

    public List<Transfer> findWithPagination(int limit, int offset, String search,
                                              String status, Integer filterUserId) {
        List<Transfer> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT t.*, "
          + "  ws.name AS source_warehouse_name, "
          + "  wd.name AS dest_warehouse_name, "
          + "  u1.name AS created_by_name, "
          + "  u2.name AS manager_reviewed_by_name, "
          + "  u3.name AS ceo_reviewed_by_name, "
          + "  u4.name AS final_reviewed_by_name "
          + "FROM transfer t "
          + "LEFT JOIN warehouse ws ON t.source_warehouse_id = ws.warehouse_id "
          + "LEFT JOIN warehouse wd ON t.dest_warehouse_id = wd.warehouse_id "
          + "LEFT JOIN user u1 ON t.created_by = u1.id "
          + "LEFT JOIN user u2 ON t.manager_reviewed_by = u2.id "
          + "LEFT JOIN user u3 ON t.ceo_reviewed_by = u3.id "
          + "LEFT JOIN user u4 ON t.final_reviewed_by = u4.id "
          + "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (status != null && !status.isEmpty()) {
            sql.append("AND t.status = ? ");
            params.add(status);
        }
        if (filterUserId != null) {
            sql.append("AND t.created_by = ? ");
            params.add(filterUserId);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND t.transfer_code LIKE ? ");
            params.add("%" + search.trim() + "%");
        }
        sql.append("ORDER BY t.created_at DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(getFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return list;
    }

    public int countTotal(String search, String status, Integer filterUserId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM transfer t WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (status != null && !status.isEmpty()) {
            sql.append("AND t.status = ? ");
            params.add(status);
        }
        if (filterUserId != null) {
            sql.append("AND t.created_by = ? ");
            params.add(filterUserId);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND t.transfer_code LIKE ? ");
            params.add("%" + search.trim() + "%");
        }
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return 0;
    }

    public Map<String, Integer> getKpiCounts(Integer filterUserId) {
        Map<String, Integer> result = new LinkedHashMap<>();
        StringBuilder sql = new StringBuilder("SELECT status, COUNT(*) AS cnt FROM transfer t WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (filterUserId != null) {
            sql.append("AND t.created_by = ? ");
            params.add(filterUserId);
        }
        sql.append("GROUP BY status");
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.put(rs.getString("status"), rs.getInt("cnt"));
                }
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        for (String s : new String[]{"DRAFT", "PENDING_MANAGER", "PENDING_CEO",
                                       "COMPLETED", "REJECTED", "CANCELLED"}) {
            result.putIfAbsent(s, 0);
        }
        return result;
    }

    public Transfer findById(int id) {
        String sql = "SELECT t.*, "
                   + "  ws.name AS source_warehouse_name, "
                   + "  wd.name AS dest_warehouse_name, "
                   + "  u1.name AS created_by_name, "
                   + "  u2.name AS manager_reviewed_by_name, "
                   + "  u3.name AS ceo_reviewed_by_name, "
                   + "  u4.name AS final_reviewed_by_name "
                   + "FROM transfer t "
                   + "LEFT JOIN warehouse ws ON t.source_warehouse_id = ws.warehouse_id "
                   + "LEFT JOIN warehouse wd ON t.dest_warehouse_id = wd.warehouse_id "
                   + "LEFT JOIN user u1 ON t.created_by = u1.id "
                   + "LEFT JOIN user u2 ON t.manager_reviewed_by = u2.id "
                   + "LEFT JOIN user u3 ON t.ceo_reviewed_by = u3.id "
                   + "LEFT JOIN user u4 ON t.final_reviewed_by = u4.id "
                   + "WHERE t.transfer_id = ?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Transfer t = getFromResultSet(rs);
                    TransferDetailDAO dDao = new TransferDetailDAO();
                    t.setDetails(dDao.findByTransferId(id));
                    return t;
                }
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return null;
    }

    @Override
    public int insert(Transfer t) {
        String sql = "INSERT INTO transfer (transfer_code, source_warehouse_id, dest_warehouse_id, "
                   + "status, created_by, note, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, t.getTransferCode());
            ps.setInt(2, t.getSourceWarehouseId());
            ps.setInt(3, t.getDestWarehouseId());
            ps.setString(4, t.getStatus() == null ? "DRAFT" : t.getStatus());
            ps.setInt(5, t.getCreatedBy());
            if (t.getNote() != null && !t.getNote().trim().isEmpty()) {
                ps.setString(6, t.getNote().trim());
            } else {
                ps.setNull(6, Types.VARCHAR);
            }
            ps.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return -1;
    }

    public boolean updateHeader(Transfer t) {
        String sql = "UPDATE transfer SET source_warehouse_id = ?, dest_warehouse_id = ?, "
                   + "note = ?, updated_at = ? WHERE transfer_id = ? AND status = 'DRAFT'";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, t.getSourceWarehouseId());
            ps.setInt(2, t.getDestWarehouseId());
            if (t.getNote() != null && !t.getNote().trim().isEmpty()) {
                ps.setString(3, t.getNote().trim());
            } else {
                ps.setNull(3, Types.VARCHAR);
            }
            ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(5, t.getTransferId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return false;
    }

    @Override
    public boolean update(Transfer t) {
        return updateHeader(t);
    }

    @Override
    public boolean delete(Transfer t) {
        String sql = "DELETE FROM transfer WHERE transfer_id = ? AND status = 'DRAFT'";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, t.getTransferId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return false;
    }

    public boolean submitForReview(int transferId, int userId) {
        String sql = "UPDATE transfer SET status = 'PENDING_MANAGER', updated_at = ? "
                   + "WHERE transfer_id = ? AND status = 'DRAFT' AND created_by = ?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(2, transferId);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return false;
    }

    public boolean managerApproveForward(int transferId, int managerId) {
        String sql = "UPDATE transfer SET status = 'PENDING_CEO', "
                   + "manager_reviewed_by = ?, manager_reviewed_at = ?, updated_at = ? "
                   + "WHERE transfer_id = ? AND status = 'PENDING_MANAGER' "
                   + "AND ceo_reviewed_at IS NULL AND final_reviewed_at IS NULL";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(4, transferId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return false;
    }

    public boolean ceoApproveReturnToManager(int transferId, int ceoId) {
        String sql = "UPDATE transfer SET status = 'PENDING_MANAGER', "
                   + "ceo_reviewed_by = ?, ceo_reviewed_at = ?, updated_at = ? "
                   + "WHERE transfer_id = ? AND status = 'PENDING_CEO' AND final_reviewed_at IS NULL";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, ceoId);
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(4, transferId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return false;
    }

    public boolean staffCancel(int transferId, int userId) {
        String sql = "UPDATE transfer SET status = 'CANCELLED', updated_at = ? "
                   + "WHERE transfer_id = ? AND created_by = ? "
                   + "AND status IN ('DRAFT', 'PENDING_MANAGER') AND ceo_reviewed_at IS NULL";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(2, transferId);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return false;
    }

    public boolean reject(int transferId, int reviewerId, String role, String note) {
        String noteCol = "manager".equals(role) ? "manager_note" : "ceo_note";
        String reviewerCol = "manager".equals(role) ? "manager_reviewed_by" : "ceo_reviewed_by";
        String reviewerAtCol = "manager".equals(role) ? "manager_reviewed_at" : "ceo_reviewed_at";

        String whereClause;
        if ("manager".equals(role)) {
            whereClause = "AND status = 'PENDING_MANAGER' AND final_reviewed_at IS NULL";
        } else {
            whereClause = "AND status = 'PENDING_CEO'";
        }

        String sql = "UPDATE transfer SET status = 'REJECTED', "
                   + reviewerCol + " = ?, " + reviewerAtCol + " = ?, "
                   + noteCol + " = ?, updated_at = ? "
                   + "WHERE transfer_id = ? " + whereClause;
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, reviewerId);
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            if (note != null && !note.trim().isEmpty()) {
                ps.setString(3, note.trim());
            } else {
                ps.setNull(3, Types.VARCHAR);
            }
            ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(5, transferId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return false;
    }

    public boolean setStatusCompleted(int transferId, int finalReviewerId) {
        String sql = "UPDATE transfer SET status = 'COMPLETED', "
                   + "final_reviewed_by = ?, final_reviewed_at = ?, "
                   + "executed_at = ?, updated_at = ? "
                   + "WHERE transfer_id = ? AND status = 'PENDING_MANAGER' "
                   + "AND ceo_reviewed_at IS NOT NULL AND final_reviewed_at IS NULL";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, finalReviewerId);
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(5, transferId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return false;
    }

    public int getAvailableQty(int warehouseId, int generatorId) {
        String sql = "SELECT COUNT(*) FROM inventory WHERE warehouse_id = ? AND generator_id = ? AND status = 'IN_STOCK'";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            ps.setInt(2, generatorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return 0;
    }

    /**
     * Thuc thi chuyen kho trong 1 SQL transaction:
     * 1. Lay transfer header (srcWh, dstWh)
     * 2. Lay transfer_detail, gom theo (generator_id, serial) neu co
     * 3. Voi moi dong:
     *    - Kiem tra ton kho nguon (COUNT inventory IN_STOCK)
     *    - Chuyen serial: neu co serial cu the trong transfer_detail thi doi warehouse_id tung serial
     *      neu khong co thi tu chon FIFO tu kho nguon
     *    - Tinh qtyAfter theo COUNT(inventory WHERE IN_STOCK)
     *    - Ghi 2 stock_card (TRANSFER_OUT + TRANSFER_IN)
     * 4. Set transfer.status = COMPLETED
     * Tra ve null neu thanh cong, error message neu that bai
     */
    public String executeTransfer(int transferId, int finalReviewerId) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            int srcWh, dstWh;
            try (PreparedStatement selPs = conn.prepareStatement(
                    "SELECT source_warehouse_id, dest_warehouse_id FROM transfer WHERE transfer_id = ? FOR UPDATE")) {
                selPs.setInt(1, transferId);
                try (ResultSet selRs = selPs.executeQuery()) {
                    if (!selRs.next()) {
                        conn.rollback();
                        return "Khong tim thay phieu";
                    }
                    srcWh = selRs.getInt("source_warehouse_id");
                    dstWh = selRs.getInt("dest_warehouse_id");
                }
            }

            // Gom transfer_detail theo (generator_id) - tinh tong qty
            Map<Integer, Integer> totalByGen = new LinkedHashMap<>();
            try (PreparedStatement detPs = conn.prepareStatement(
                    "SELECT generator_id, quantity FROM transfer_detail WHERE transfer_id = ?")) {
                detPs.setInt(1, transferId);
                try (ResultSet detRs = detPs.executeQuery()) {
                    while (detRs.next()) {
                        int genId = detRs.getInt("generator_id");
                        int qty = detRs.getInt("quantity");
                        totalByGen.merge(genId, qty, Integer::sum);
                    }
                }
            }

            for (Map.Entry<Integer, Integer> e : totalByGen.entrySet()) {
                int genId = e.getKey();
                int totalQty = e.getValue();

                // Lay danh sach serial theo generator neu co trong transfer_detail
                List<String> serials = new ArrayList<>();
                try (PreparedStatement serPs = conn.prepareStatement(
                        "SELECT serial_number FROM transfer_detail "
                      + "WHERE transfer_id = ? AND generator_id = ? AND serial_number IS NOT NULL AND serial_number <> ''")) {
                    serPs.setInt(1, transferId);
                    serPs.setInt(2, genId);
                    try (ResultSet serRs = serPs.executeQuery()) {
                        while (serRs.next()) {
                            serials.add(serRs.getString("serial_number"));
                        }
                    }
                }

                // Kiem tra ton kho nguon
                int curQty = 0;
                try (PreparedStatement chkPs = conn.prepareStatement(
                        "SELECT COUNT(*) AS cnt FROM inventory WHERE warehouse_id = ? AND generator_id = ? AND status = 'IN_STOCK'")) {
                    chkPs.setInt(1, srcWh);
                    chkPs.setInt(2, genId);
                    try (ResultSet chkRs = chkPs.executeQuery()) {
                        if (chkRs.next()) {
                            curQty = chkRs.getInt("cnt");
                        }
                    }
                }

                if (curQty < totalQty) {
                    conn.rollback();
                    return "Kho nguon khong du ton cho may ID=" + genId
                         + " (can " + totalQty + ", con " + curQty + ")";
                }

                // Chuyen serial: neu co serial cu the trong transfer_detail thi doi warehouse_id tung serial
                if (!serials.isEmpty()) {
                    try (PreparedStatement upSerPs = conn.prepareStatement(
                            "UPDATE inventory SET warehouse_id = ?, status = 'IN_STOCK' "
                          + "WHERE serial_number = ? AND warehouse_id = ? AND status = 'IN_STOCK'")) {
                        for (String serial : serials) {
                            upSerPs.setInt(1, dstWh);
                            upSerPs.setString(2, serial);
                            upSerPs.setInt(3, srcWh);
                            upSerPs.addBatch();
                        }
                        upSerPs.executeBatch();
                    }
                } else {
                    // Auto-chon serial theo FIFO tu kho nguon
                    try (PreparedStatement serPs = conn.prepareStatement(
                            "SELECT serial_number FROM inventory "
                          + "WHERE warehouse_id = ? AND generator_id = ? AND status = 'IN_STOCK' "
                          + "ORDER BY created_at LIMIT ?")) {
                        serPs.setInt(1, srcWh);
                        serPs.setInt(2, genId);
                        serPs.setInt(3, totalQty);
                        try (ResultSet serRs = serPs.executeQuery()) {
                            List<String> picked = new ArrayList<>();
                            while (serRs.next()) picked.add(serRs.getString("serial_number"));

                            try (PreparedStatement upSerPs = conn.prepareStatement(
                                    "UPDATE inventory SET warehouse_id = ?, status = 'IN_STOCK' "
                                  + "WHERE serial_number = ? AND warehouse_id = ? AND status = 'IN_STOCK'")) {
                                for (String serial : picked) {
                                    upSerPs.setInt(1, dstWh);
                                    upSerPs.setString(2, serial);
                                    upSerPs.setInt(3, srcWh);
                                    upSerPs.addBatch();
                                }
                                upSerPs.executeBatch();
                            }
                        }
                    }
                }

                // Tinh quantity_after theo COUNT(inventory WHERE IN_STOCK) cho kho nguon va kho dich
                int srcQtyAfter = 0;
                int dstQtyAfter = 0;
                try (PreparedStatement qtyPs = conn.prepareStatement(
                        "SELECT "
                      + "  (SELECT COUNT(*) FROM inventory WHERE warehouse_id = ? AND generator_id = ? AND status = 'IN_STOCK') AS src_after, "
                      + "  (SELECT COUNT(*) FROM inventory WHERE warehouse_id = ? AND generator_id = ? AND status = 'IN_STOCK') AS dst_after")) {
                    qtyPs.setInt(1, srcWh);
                    qtyPs.setInt(2, genId);
                    qtyPs.setInt(3, dstWh);
                    qtyPs.setInt(4, genId);
                    try (ResultSet qtyRs = qtyPs.executeQuery()) {
                        if (qtyRs.next()) {
                            srcQtyAfter = qtyRs.getInt("src_after");
                            dstQtyAfter = qtyRs.getInt("dst_after");
                        }
                    }
                }

                // Ghi stock_card: TRANSFER_OUT
                try (PreparedStatement insOutPs = conn.prepareStatement(
                        "INSERT INTO stock_card (warehouse_id, generator_id, receipt_id, "
                      + "transaction_type, quantity_change, quantity_after, reference_note, "
                      + "created_at, created_by) VALUES (?, ?, NULL, 'TRANSFER_OUT', ?, ?, ?, ?, ?)")) {
                    insOutPs.setInt(1, srcWh);
                    insOutPs.setInt(2, genId);
                    insOutPs.setInt(3, -totalQty);
                    insOutPs.setInt(4, srcQtyAfter);
                    insOutPs.setString(5, "Phieu luan chuyen " + transferId);
                    insOutPs.setTimestamp(6, Timestamp.valueOf(LocalDateTime.now()));
                    insOutPs.setInt(7, finalReviewerId);
                    insOutPs.executeUpdate();
                }

                // Ghi stock_card: TRANSFER_IN
                try (PreparedStatement insInPs = conn.prepareStatement(
                        "INSERT INTO stock_card (warehouse_id, generator_id, receipt_id, "
                      + "transaction_type, quantity_change, quantity_after, reference_note, "
                      + "created_at, created_by) VALUES (?, ?, NULL, 'TRANSFER_IN', ?, ?, ?, ?, ?)")) {
                    insInPs.setInt(1, dstWh);
                    insInPs.setInt(2, genId);
                    insInPs.setInt(3, totalQty);
                    insInPs.setInt(4, dstQtyAfter);
                    insInPs.setString(5, "Phieu luan chuyen " + transferId);
                    insInPs.setTimestamp(6, Timestamp.valueOf(LocalDateTime.now()));
                    insInPs.setInt(7, finalReviewerId);
                    insInPs.executeUpdate();
                }
            }

            int compRows;
            try (PreparedStatement compPs = conn.prepareStatement(
                    "UPDATE transfer SET status = 'COMPLETED', "
                  + "final_reviewed_by = ?, final_reviewed_at = ?, "
                  + "executed_at = ?, updated_at = ? "
                  + "WHERE transfer_id = ? AND status = 'PENDING_MANAGER' "
                  + "AND ceo_reviewed_at IS NOT NULL AND final_reviewed_at IS NULL")) {
                compPs.setInt(1, finalReviewerId);
                compPs.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
                compPs.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
                compPs.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
                compPs.setInt(5, transferId);
                compRows = compPs.executeUpdate();
            }

            if (compRows == 0) {
                conn.rollback();
                return "Trang thai phieu khong hop le de hoan tat";
            }

            conn.commit();
            return null;
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
            return "Loi he thong: " + e.getMessage();
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException ignored) {
            }
        }
    }

    @Override
    public Transfer getFromResultSet(ResultSet rs) throws SQLException {
        Transfer t = new Transfer();
        t.setTransferId(rs.getInt("transfer_id"));
        t.setTransferCode(rs.getString("transfer_code"));
        t.setSourceWarehouseId(rs.getInt("source_warehouse_id"));
        t.setDestWarehouseId(rs.getInt("dest_warehouse_id"));
        t.setStatus(rs.getString("status"));
        t.setCreatedBy(rs.getInt("created_by"));
        t.setManagerNote(rs.getString("manager_note"));
        t.setCeoNote(rs.getString("ceo_note"));
        Timestamp mra = rs.getTimestamp("manager_reviewed_at");
        if (mra != null) t.setManagerReviewedAt(mra.toLocalDateTime());
        Timestamp cra = rs.getTimestamp("ceo_reviewed_at");
        if (cra != null) t.setCeoReviewedAt(cra.toLocalDateTime());
        Timestamp fra = rs.getTimestamp("final_reviewed_at");
        if (fra != null) t.setFinalReviewedAt(fra.toLocalDateTime());
        Timestamp exa = rs.getTimestamp("executed_at");
        if (exa != null) t.setExecutedAt(exa.toLocalDateTime());
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) t.setCreatedAt(ca.toLocalDateTime());
        Timestamp ua = rs.getTimestamp("updated_at");
        if (ua != null) t.setUpdatedAt(ua.toLocalDateTime());
        int mrb = rs.getInt("manager_reviewed_by");
        if (!rs.wasNull()) t.setManagerReviewedBy(mrb);
        int crb = rs.getInt("ceo_reviewed_by");
        if (!rs.wasNull()) t.setCeoReviewedBy(crb);
        int frb = rs.getInt("final_reviewed_by");
        if (!rs.wasNull()) t.setFinalReviewedBy(frb);
        try { t.setSourceWarehouseName(rs.getString("source_warehouse_name")); } catch (SQLException ignored) {}
        try { t.setDestWarehouseName(rs.getString("dest_warehouse_name")); } catch (SQLException ignored) {}
        try { t.setCreatedByName(rs.getString("created_by_name")); } catch (SQLException ignored) {}
        try { t.setManagerReviewedByName(rs.getString("manager_reviewed_by_name")); } catch (SQLException ignored) {}
        try { t.setCeoReviewedByName(rs.getString("ceo_reviewed_by_name")); } catch (SQLException ignored) {}
        try { t.setFinalReviewedByName(rs.getString("final_reviewed_by_name")); } catch (SQLException ignored) {}
        t.setNote(rs.getString("note"));
        return t;
    }
}