import com.quanlymayphatdien.g1.dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TestDB {
    public static void main(String[] args) {
        DBContext db = new DBContext();
        try {
            Connection conn = db.getConnection();
            String sql = "SELECT warehouse_id, generator_id, status, COUNT(*) FROM serial_number GROUP BY warehouse_id, generator_id, status";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            System.out.println("Warehouse ID | Generator ID | Status | Count");
            while (rs.next()) {
                System.out.println(rs.getInt(1) + " | " + rs.getInt(2) + " | " + rs.getString(3) + " | " + rs.getInt(4));
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
