-- ============================================
-- Gan TOAN BO permission cho role admin
-- ============================================

-- Buoc 1: Kiem tra admin role_id
SELECT id, name FROM roles;

-- Buoc 2: Kiem tra permission hien co
SELECT * FROM permissions ORDER BY resource, action;

-- Buoc 3: Gan TAT CA permission trong bang permissions cho admin
INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name = 'admin';

-- Buoc 4: Kiem tra ket qua - admin co bao nhieu quyen?
SELECT r.name AS role_name, COUNT(rp.permission_id) AS total_permissions
FROM roles r
LEFT JOIN role_permissions rp ON r.id = rp.role_id
GROUP BY r.id, r.name
ORDER BY r.id;

-- Buoc 5: Xem chi tiet quyen cua admin
SELECT r.name AS role, p.resource, p.action, p.description
FROM roles r
JOIN role_permissions rp ON r.id = rp.role_id
JOIN permissions p ON rp.permission_id = p.id
WHERE r.name = 'admin'
ORDER BY p.resource, p.action;
