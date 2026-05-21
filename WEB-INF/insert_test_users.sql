USE wastemanagement;

-- Create test admin
INSERT INTO users (name, email, password, role, qr_code, points) 
VALUES ('Admin User', 'admin@example.com', 'admin123', 'ADMIN', 'ADMIN-001', 0);

-- Create test worker
INSERT INTO users (name, email, password, role, qr_code, points) 
VALUES ('Worker One', 'worker@example.com', 'worker123', 'WORKER', 'WORKER-001', 0);

SELECT * FROM users;
