package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.utils.LogModule;
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
                + "  u3.name AS ceo_reviewed_by_name, "
                + "  u4.name AS final_reviewed_by_name, "
                + "  rexp.receipt_code AS export_receipt_code, "
                + "  rimp.receipt_code AS import_receipt_code "
                + "FROM transfer t "
                + "LEFT JOIN warehouse ws ON t.source_warehouse_id = ws.warehouse_id "
                + "LEFT JOIN warehouse wd ON t.dest_warehouse_id = wd.warehouse_id "
                + "LEFT JOIN user u1 ON t.created_by = u1.id "
                + "LEFT JOIN user u3 ON t.ceo_reviewed_by = u3.id "
                + "LEFT JOIN user u4 ON t.final_reviewed_by = u4.id "
                + "LEFT JOIN receipt rexp ON t.export_receipt_id = rexp.receipt_id "
                + "LEFT JOIN receipt rimp ON t.import_receipt_id = rimp.receipt_id "
                + "ORDER BY t.created_at DESC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return list;
    }

    public List<Transfer> findWithPagination(int limit, int offset, String search,
            String status, Integer filterUserId, Integer scopedWarehouseId, int currentUserId) {
        List<Transfer> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT t.*, "
                + "  ws.name AS source_warehouse_name, "
                + "  wd.name AS dest_warehouse_name, "
                + "  u1.name AS created_by_name, "
                + "  u3.name AS ceo_reviewed_by_name, "
                + "  u4.name AS final_reviewed_by_name, "
                + "  rexp.receipt_code AS export_receipt_code, "
                + "  rimp.receipt_code AS import_receipt_code "
                + "FROM transfer t "
                + "LEFT JOIN warehouse ws ON t.source_warehouse_id = ws.warehouse_id "
                + "LEFT JOIN warehouse wd ON t.dest_warehouse_id = wd.warehouse_id "
                + "LEFT JOIN user u1 ON t.created_by = u1.id "
                + "LEFT JOIN user u3 ON t.ceo_reviewed_by = u3.id "
                + "LEFT JOIN user u4 ON t.final_reviewed_by = u4.id "
                + "LEFT JOIN receipt rexp ON t.export_receipt_id = rexp.receipt_id "
                + "LEFT JOIN receipt rimp ON t.import_receipt_id = rimp.receipt_id "
                + "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (status != null && !status.isEmpty()) {
            sql.append("AND t.status = ? ");
            params.add(status);
        }
        if (scopedWarehouseId != null && scopedWarehouseId > 0) {
            sql.append("AND (t.source_warehouse_id = ? OR t.dest_warehouse_id = ? OR t.created_by = ?) ");
            params.add(scopedWarehouseId);
            params.add(scopedWarehouseId);
            params.add(currentUserId);
        } else if (filterUserId != null) {
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
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return list;
    }

    public int countTotal(String search, String status, Integer filterUserId,
                          Integer scopedWarehouseId, int currentUserId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM transfer t WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (status != null && !status.isEmpty()) {
            sql.append("AND t.status = ? ");
            params.add(status);
        }
        if (scopedWarehouseId != null && scopedWarehouseId > 0) {
            sql.append("AND (t.source_warehouse_id = ? OR t.dest_warehouse_id = ? OR t.created_by = ?) ");
            params.add(scopedWarehouseId);
            params.add(scopedWarehouseId);
            params.add(currentUserId);
        } else if (filterUserId != null) {
            sql.append("AND t.created_by = ? ");
            params.add(filterUserId);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND t.transfer_code LIKE ? ");
            params.add("%" + search.trim() + "%");
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return 0;
    }

    public Map<String, Integer> getKpiCounts(Integer filterUserId, Integer scopedWarehouseId, int currentUserId) {
        Map<String, Integer> result = new LinkedHashMap<>();
        StringBuilder sql = new StringBuilder("SELECT status, COUNT(*) AS cnt FROM transfer t WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (scopedWarehouseId != null && scopedWarehouseId > 0) {
            sql.append("AND (t.source_warehouse_id = ? OR t.dest_warehouse_id = ? OR t.created_by = ?) ");
            params.add(scopedWarehouseId);
            params.add(scopedWarehouseId);
            params.add(currentUserId);
        } else if (filterUserId != null) {
            sql.append("AND t.created_by = ? ");
            params.add(filterUserId);
        }
        sql.append("GROUP BY status");
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                result.put(resultSet.getString("status"), resultSet.getInt("cnt"));
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        for (String s : new String[]{"PENDING_CEO", "APPROVED", "EXPORTED",
            "COMPLETED", "REJECTED", "REQUEST_REVISION"}) {
            result.putIfAbsent(s, 0);
        }
        return result;
    }

    public List<Transfer> findReadyForExport(int scopedWarehouseId, int userId) {
        List<Transfer> list = new ArrayList<>();
        String sql = "SELECT t.*, "
                + "  ws.name AS source_warehouse_name, "
                + "  wd.name AS dest_warehouse_name, "
                + "  u1.name AS created_by_name, "
                + "  u3.name AS ceo_reviewed_by_name, "
                + "  u4.name AS final_reviewed_by_name, "
                + "  rexp.receipt_code AS export_receipt_code, "
                + "  rimp.receipt_code AS import_receipt_code "
                + "FROM transfer t "
                + "LEFT JOIN warehouse ws ON t.source_warehouse_id = ws.warehouse_id "
                + "LEFT JOIN warehouse wd ON t.dest_warehouse_id = wd.warehouse_id "
                + "LEFT JOIN user u1 ON t.created_by = u1.id "
                + "LEFT JOIN user u3 ON t.ceo_reviewed_by = u3.id "
                + "LEFT JOIN user u4 ON t.final_reviewed_by = u4.id "
                + "LEFT JOIN receipt rexp ON t.export_receipt_id = rexp.receipt_id "
                + "LEFT JOIN receipt rimp ON t.import_receipt_id = rimp.receipt_id "
                + "WHERE t.status = 'APPROVED' AND t.export_receipt_id IS NULL "
                + "AND (t.source_warehouse_id = ? OR t.created_by = ?) "
                + "ORDER BY t.created_at DESC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, scopedWarehouseId > 0 ? scopedWarehouseId : -1);
            if (scopedWarehouseId > 0) {
                statement.setInt(2, userId);
            } else {
                statement.setInt(2, -1);
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return list;
    }

    public List<Transfer> findReadyForExportFiltered(String search, String fromDate, String toDate,
            int page, int pageSize, int scopedWarehouseId, int userId) {
        List<Transfer> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT t.*, "
            + "  ws.name AS source_warehouse_name, "
            + "  wd.name AS dest_warehouse_name, "
            + "  u1.name AS created_by_name, "
            + "  u3.name AS ceo_reviewed_by_name, "
            + "  u4.name AS final_reviewed_by_name, "
            + "  rexp.receipt_code AS export_receipt_code, "
            + "  rimp.receipt_code AS import_receipt_code "
            + "FROM transfer t "
            + "LEFT JOIN warehouse ws ON t.source_warehouse_id = ws.warehouse_id "
            + "LEFT JOIN warehouse wd ON t.dest_warehouse_id = wd.warehouse_id "
            + "LEFT JOIN user u1 ON t.created_by = u1.id "
            + "LEFT JOIN user u3 ON t.ceo_reviewed_by = u3.id "
            + "LEFT JOIN user u4 ON t.final_reviewed_by = u4.id "
            + "LEFT JOIN receipt rexp ON t.export_receipt_id = rexp.receipt_id "
            + "LEFT JOIN receipt rimp ON t.import_receipt_id = rimp.receipt_id "
            + "WHERE t.status = 'APPROVED' AND t.export_receipt_id IS NULL "
            + "AND (t.source_warehouse_id = ? OR t.created_by = ?) "
        );
        List<Object> params = new ArrayList<>();
        params.add(scopedWarehouseId > 0 ? scopedWarehouseId : -1);
        params.add(scopedWarehouseId > 0 ? userId : -1);

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (t.transfer_code LIKE ? OR u1.name LIKE ?) ");
            String like = "%" + search.trim() + "%";
            params.add(like);
            params.add(like);
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND DATE(t.created_at) >= ? ");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND DATE(t.created_at) <= ? ");
            params.add(toDate);
        }
        sql.append("ORDER BY t.created_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return list;
    }

    public int countReadyForExportFiltered(String search, String fromDate, String toDate,
            int scopedWarehouseId, int userId) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM transfer t "
            + "LEFT JOIN user u1 ON t.created_by = u1.id "
            + "WHERE t.status = 'APPROVED' AND t.export_receipt_id IS NULL "
            + "AND (t.source_warehouse_id = ? OR t.created_by = ?) "
        );
        List<Object> params = new ArrayList<>();
        params.add(scopedWarehouseId > 0 ? scopedWarehouseId : -1);
        params.add(scopedWarehouseId > 0 ? userId : -1);

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (t.transfer_code LIKE ? OR u1.name LIKE ?) ");
            String like = "%" + search.trim() + "%";
            params.add(like);
            params.add(like);
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND DATE(t.created_at) >= ? ");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND DATE(t.created_at) <= ? ");
            params.add(toDate);
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) return resultSet.getInt(1);
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return 0;
    }

    public List<Transfer> findReadyForImport(int scopedWarehouseId, int userId) {
        List<Transfer> list = new ArrayList<>();
        String sql = "SELECT t.*, "
                + "  ws.name AS source_warehouse_name, "
                + "  wd.name AS dest_warehouse_name, "
                + "  u1.name AS created_by_name, "
                + "  u3.name AS ceo_reviewed_by_name, "
                + "  u4.name AS final_reviewed_by_name, "
                + "  rexp.receipt_code AS export_receipt_code, "
                + "  rimp.receipt_code AS import_receipt_code "
                + "FROM transfer t "
                + "LEFT JOIN warehouse ws ON t.source_warehouse_id = ws.warehouse_id "
                + "LEFT JOIN warehouse wd ON t.dest_warehouse_id = wd.warehouse_id "
                + "LEFT JOIN user u1 ON t.created_by = u1.id "
                + "LEFT JOIN user u3 ON t.ceo_reviewed_by = u3.id "
                + "LEFT JOIN user u4 ON t.final_reviewed_by = u4.id "
                + "LEFT JOIN receipt rexp ON t.export_receipt_id = rexp.receipt_id "
                + "LEFT JOIN receipt rimp ON t.import_receipt_id = rimp.receipt_id "
                + "WHERE t.status = 'EXPORTED' AND t.import_receipt_id IS NULL "
                + "AND (t.dest_warehouse_id = ?) "
                + "ORDER BY t.created_at DESC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, scopedWarehouseId > 0 ? scopedWarehouseId : -1);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return list;
    }

    public Transfer findByExportReceiptId(int exportReceiptId) {
        String sql = "SELECT t.*, "
                + "  ws.name AS source_warehouse_name, "
                + "  wd.name AS dest_warehouse_name, "
                + "  u1.name AS created_by_name, "
                + "  u3.name AS ceo_reviewed_by_name, "
                + "  u4.name AS final_reviewed_by_name, "
                + "  rexp.receipt_code AS export_receipt_code, "
                + "  rimp.receipt_code AS import_receipt_code "
                + "FROM transfer t "
                + "LEFT JOIN warehouse ws ON t.source_warehouse_id = ws.warehouse_id "
                + "LEFT JOIN warehouse wd ON t.dest_warehouse_id = wd.warehouse_id "
                + "LEFT JOIN user u1 ON t.created_by = u1.id "
                + "LEFT JOIN user u3 ON t.ceo_reviewed_by = u3.id "
                + "LEFT JOIN user u4 ON t.final_reviewed_by = u4.id "
                + "LEFT JOIN receipt rexp ON t.export_receipt_id = rexp.receipt_id "
                + "LEFT JOIN receipt rimp ON t.import_receipt_id = rimp.receipt_id "
                + "WHERE t.export_receipt_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, exportReceiptId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                Transfer t = getFromResultSet(resultSet);
                TransferDetailDAO dDao = new TransferDetailDAO();
                t.setDetails(dDao.findByTransferId(t.getTransferId()));
                return t;
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return null;
    }

    public Transfer findById(int id) {
        String sql = "SELECT t.*, "
                + "  ws.name AS source_warehouse_name, "
                + "  wd.name AS dest_warehouse_name, "
                + "  u1.name AS created_by_name, "
                + "  u3.name AS ceo_reviewed_by_name, "
                + "  u4.name AS final_reviewed_by_name, "
                + "  rexp.receipt_code AS export_receipt_code, "
                + "  rimp.receipt_code AS import_receipt_code "
                + "FROM transfer t "
                + "LEFT JOIN warehouse ws ON t.source_warehouse_id = ws.warehouse_id "
                + "LEFT JOIN warehouse wd ON t.dest_warehouse_id = wd.warehouse_id "
                + "LEFT JOIN user u1 ON t.created_by = u1.id "
                + "LEFT JOIN user u3 ON t.ceo_reviewed_by = u3.id "
                + "LEFT JOIN user u4 ON t.final_reviewed_by = u4.id "
                + "LEFT JOIN receipt rexp ON t.export_receipt_id = rexp.receipt_id "
                + "LEFT JOIN receipt rimp ON t.import_receipt_id = rimp.receipt_id "
                + "WHERE t.transfer_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                Transfer t = getFromResultSet(resultSet);
                TransferDetailDAO dDao = new TransferDetailDAO();
                t.setDetails(dDao.findByTransferId(id));
                return t;
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return null;
    }

    public Transfer findActiveByWarehousePair(int sourceId, int destId) {
        String sql = "SELECT t.*, "
                + "  ws.name AS source_warehouse_name, "
                + "  wd.name AS dest_warehouse_name, "
                + "  u1.name AS created_by_name "
                + "FROM transfer t "
                + "LEFT JOIN warehouse ws ON t.source_warehouse_id = ws.warehouse_id "
                + "LEFT JOIN warehouse wd ON t.dest_warehouse_id = wd.warehouse_id "
                + "LEFT JOIN user u1 ON t.created_by = u1.id "
                + "WHERE t.source_warehouse_id = ? "
                + "  AND t.dest_warehouse_id = ? "
                + "  AND t.status IN ('PENDING_CEO','REQUEST_REVISION') "
                + "ORDER BY t.created_at DESC LIMIT 1";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, sourceId);
            statement.setInt(2, destId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return null;
    }

    @Override
    public int insert(Transfer t) {
        String insertSql = "INSERT INTO transfer (transfer_code, source_warehouse_id, dest_warehouse_id, "
                + "status, created_by, note, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String checkSql = "SELECT transfer_id FROM transfer "
                + "WHERE source_warehouse_id = ? AND dest_warehouse_id = ? "
                + "  AND status IN ('PENDING_CEO','REQUEST_REVISION') "
                + "LIMIT 1 FOR UPDATE";
        boolean originalAutoCommit = true;
        try {
            connection = getConnection();
            originalAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);

            statement = connection.prepareStatement(checkSql);
            statement.setInt(1, t.getSourceWarehouseId());
            statement.setInt(2, t.getDestWarehouseId());
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                connection.rollback();
                return -2;
            }
            if (resultSet != null) {
                resultSet.close();
                resultSet = null;
            }
            statement.close();
            statement = null;

            statement = connection.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, t.getTransferCode());
            statement.setInt(2, t.getSourceWarehouseId());
            statement.setInt(3, t.getDestWarehouseId());
            statement.setString(4, t.getStatus() == null ? "PENDING_CEO" : t.getStatus());
            statement.setInt(5, t.getCreatedBy());
            if (t.getNote() != null && !t.getNote().trim().isEmpty()) {
                statement.setString(6, t.getNote().trim());
            } else {
                statement.setNull(6, Types.VARCHAR);
            }
            statement.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
            int rows = statement.executeUpdate();
            if (rows > 0) {
                resultSet = statement.getGeneratedKeys();
                if (resultSet.next()) {
                    int newId = resultSet.getInt(1);
                    connection.commit();
                    return newId;
                }
            }
            connection.rollback();
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
            try {
                if (connection != null) {
                    connection.rollback();
                }
            } catch (SQLException ex) {
                // ignore
            }
        } finally {
            try {
                if (connection != null) {
                    connection.setAutoCommit(originalAutoCommit);
                }
            } catch (SQLException ex) {
                // ignore
            }
            closeResources();
        }
        return -1;
    }

    @Override
    public boolean update(Transfer t) {
        return false;
    }

    @Override
    public boolean delete(Transfer t) {
        return false;
    }

    public boolean ceApproveForward(int transferId, int ceoId, String note) {
        return ceApprove(transferId, ceoId, note);
    }

    public boolean ceApprove(int transferId, int ceoId, String note) {
        String sql = "UPDATE transfer SET status = 'APPROVED', "
                + "ceo_reviewed_by = ?, ceo_reviewed_at = ?, ceo_note = ?, updated_at = ? "
                + "WHERE transfer_id = ? AND status = 'PENDING_CEO'";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, ceoId);
            statement.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            if (note != null && !note.trim().isEmpty()) {
                statement.setString(3, note.trim());
            } else {
                statement.setNull(3, Types.VARCHAR);
            }
            statement.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            statement.setInt(5, transferId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean ceReject(int transferId, int ceoId, String note) {
        String sql = "UPDATE transfer SET status = 'REJECTED', "
                + "ceo_reviewed_by = ?, ceo_reviewed_at = ?, ceo_note = ?, updated_at = ? "
                + "WHERE transfer_id = ? AND status = 'PENDING_CEO'";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, ceoId);
            statement.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            if (note != null && !note.trim().isEmpty()) {
                statement.setString(3, note.trim());
            } else {
                statement.setNull(3, Types.VARCHAR);
            }
            statement.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            statement.setInt(5, transferId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean ceRequestRevision(int transferId, int ceoId, String note) {
        String sql = "UPDATE transfer SET status = 'REQUEST_REVISION', "
                + "ceo_reviewed_by = ?, ceo_reviewed_at = ?, ceo_note = ?, updated_at = ? "
                + "WHERE transfer_id = ? AND status = 'PENDING_CEO'";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, ceoId);
            statement.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            if (note != null && !note.trim().isEmpty()) {
                statement.setString(3, note.trim());
            } else {
                statement.setNull(3, Types.VARCHAR);
            }
            statement.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            statement.setInt(5, transferId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean submitRevision(int transferId, int userId) {
        String sql = "UPDATE transfer SET status = 'PENDING_CEO', updated_at = ? "
                + "WHERE transfer_id = ? AND status = 'REQUEST_REVISION' AND created_by = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            statement.setInt(2, transferId);
            statement.setInt(3, userId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean updateHeader(int transferId, int sourceWarehouseId, int destWarehouseId, String note) {
        String sql = "UPDATE transfer SET source_warehouse_id = ?, dest_warehouse_id = ?, "
                + "note = ?, updated_at = ? WHERE transfer_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, sourceWarehouseId);
            statement.setInt(2, destWarehouseId);
            if (note != null && !note.trim().isEmpty()) {
                statement.setString(3, note.trim());
            } else {
                statement.setNull(3, Types.VARCHAR);
            }
            statement.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            statement.setInt(5, transferId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Kho nguon tao phieu xuat tu phieu de xuat. APPROVED -> EXPORTED.
     */
    public boolean markExportReceiptCreated(int transferId, int exportReceiptId) {
        String sql = "UPDATE transfer SET status = 'EXPORTED', "
                + "export_receipt_id = ?, executed_at = ?, updated_at = ? "
                + "WHERE transfer_id = ? AND status = 'APPROVED' AND export_receipt_id IS NULL";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, exportReceiptId);
            statement.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            statement.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            statement.setInt(4, transferId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Kho dich tao phieu nhap tu phieu xuat. EXPORTED -> COMPLETED.
     */
    public boolean markImportReceiptCreated(int transferId, int importReceiptId, int finalUserId) {
        String sql = "UPDATE transfer SET status = 'COMPLETED', "
                + "import_receipt_id = ?, final_reviewed_by = ?, final_reviewed_at = ?, updated_at = ? "
                + "WHERE transfer_id = ? AND status = 'EXPORTED' AND import_receipt_id IS NULL";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, importReceiptId);
            statement.setInt(2, finalUserId);
            statement.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            statement.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            statement.setInt(5, transferId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return false;
    }

    public int getAvailableQty(int warehouseId, int generatorId) {
        String sql = "SELECT COUNT(*) FROM inventory WHERE warehouse_id = ? AND generator_id = ? AND status = 'IN_STOCK'";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, warehouseId);
            statement.setInt(2, generatorId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return 0;
    }

    public String executeTransfer(int transferId, int finalReviewerId) {
        throw new UnsupportedOperationException("executeTransfer() khong con su dung trong luong moi. "
                + "Vui long tao phieu xuat/nhap rieng.");
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
        Timestamp cra = rs.getTimestamp("ceo_reviewed_at");
        if (cra != null) {
            t.setCeoReviewedAt(cra.toLocalDateTime());
        }
        Timestamp fra = rs.getTimestamp("final_reviewed_at");
        if (fra != null) {
            t.setFinalReviewedAt(fra.toLocalDateTime());
        }
        Timestamp exa = rs.getTimestamp("executed_at");
        if (exa != null) {
            t.setExecutedAt(exa.toLocalDateTime());
        }
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) {
            t.setCreatedAt(ca.toLocalDateTime());
        }
        Timestamp ua = rs.getTimestamp("updated_at");
        if (ua != null) {
            t.setUpdatedAt(ua.toLocalDateTime());
        }
        int crb = rs.getInt("ceo_reviewed_by");
        if (!rs.wasNull()) {
            t.setCeoReviewedBy(crb);
        }
        int frb = rs.getInt("final_reviewed_by");
        if (!rs.wasNull()) {
            t.setFinalReviewedBy(frb);
        }
        try {
            int exr = rs.getInt("export_receipt_id");
            if (!rs.wasNull()) {
                t.setExportReceiptId(exr);
            }
        } catch (SQLException ignored) {
        }
        try {
            int imr = rs.getInt("import_receipt_id");
            if (!rs.wasNull()) {
                t.setImportReceiptId(imr);
            }
        } catch (SQLException ignored) {
        }
        try {
            t.setSourceWarehouseName(rs.getString("source_warehouse_name"));
        } catch (SQLException ignored) {
        }
        try {
            t.setDestWarehouseName(rs.getString("dest_warehouse_name"));
        } catch (SQLException ignored) {
        }
        try {
            t.setCreatedByName(rs.getString("created_by_name"));
        } catch (SQLException ignored) {
        }
        t.setManagerReviewedByName(null);
        try {
            t.setCeoReviewedByName(rs.getString("ceo_reviewed_by_name"));
        } catch (SQLException ignored) {
        }
        try {
            t.setFinalReviewedByName(rs.getString("final_reviewed_by_name"));
        } catch (SQLException ignored) {
        }
        try {
            t.setExportReceiptCode(rs.getString("export_receipt_code"));
        } catch (SQLException ignored) {
        }
        try {
            t.setImportReceiptCode(rs.getString("import_receipt_code"));
        } catch (SQLException ignored) {
        }
        t.setNote(rs.getString("note"));
        return t;
    }
}