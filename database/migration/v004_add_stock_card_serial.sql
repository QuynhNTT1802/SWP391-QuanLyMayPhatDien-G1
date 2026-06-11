-- Migration v004: thêm bảng stock_card_serial để lưu serial từng máy
-- Nghiệp vụ: từng máy (mỗi receipt_detail) có 1 serial, ghi vào stock_card_serial

CREATE TABLE stock_card_serial (
    stock_card_serial_id INT NOT NULL AUTO_INCREMENT,
    stock_card_id INT NOT NULL,
    serial_number VARCHAR(100) NOT NULL,
    PRIMARY KEY (stock_card_serial_id),
    UNIQUE KEY uk_sc_serial (stock_card_id, serial_number),
    KEY idx_sc_serial_serial (serial_number),
    CONSTRAINT fk_sc_serial_card FOREIGN KEY (stock_card_id)
        REFERENCES stock_card (stock_card_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
