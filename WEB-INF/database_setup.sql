-- Smart Waste Monitoring System - Database Setup Script
-- Run this script on your MySQL server to create the database and tables

-- Create Database
CREATE DATABASE IF NOT EXISTS wastemanagement;
USE wastemanagement;

-- ===== Users Table =====
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'CITIZEN',
    qr_code VARCHAR(100) UNIQUE,
    points INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Ensure schema updates for older deployments
ALTER TABLE users ADD COLUMN IF NOT EXISTS role VARCHAR(20) NOT NULL DEFAULT 'CITIZEN';
ALTER TABLE users ADD COLUMN IF NOT EXISTS qr_code VARCHAR(100) UNIQUE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS points INT NOT NULL DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- ===== Waste Collection Table =====
CREATE TABLE IF NOT EXISTS waste_collection (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    waste_type VARCHAR(50) NOT NULL,
    quantity DOUBLE NOT NULL,
    unit VARCHAR(20) DEFAULT 'kg',
    location VARCHAR(200) NOT NULL,
    date DATE NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ===== Collection Sessions Table =====
CREATE TABLE IF NOT EXISTS collection_sessions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    worker_id INT NOT NULL,
    citizen_id INT NOT NULL,
    qr_code VARCHAR(100) NOT NULL,
    total_organic DOUBLE NOT NULL,
    total_dry DOUBLE NOT NULL,
    total_reject DOUBLE NOT NULL,
    total_collected DOUBLE NOT NULL,
    segregation_score DOUBLE NOT NULL,
    points_awarded INT NOT NULL,
    notes TEXT,
    session_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (worker_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (citizen_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ===== Redemptions Table =====
CREATE TABLE IF NOT EXISTS redemptions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    citizen_id INT NOT NULL,
    points_requested INT NOT NULL,
    reward_type VARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (citizen_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ===== Complaints Table =====
CREATE TABLE IF NOT EXISTS complaints (
    id INT PRIMARY KEY AUTO_INCREMENT,
    citizen_id INT NOT NULL,
    worker_id INT NOT NULL,
    session_id INT NOT NULL,
    complaint_type VARCHAR(50) NOT NULL DEFAULT 'LOW_SEGREGATION',
    segregation_score DOUBLE NOT NULL,
    description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    admin_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (citizen_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (worker_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (session_id) REFERENCES collection_sessions(id) ON DELETE CASCADE
);

-- ===== Waste Logs Table (for audit trail) =====
CREATE TABLE IF NOT EXISTS waste_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    action VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ===== Create Indexes for Better Performance =====
CREATE INDEX IF NOT EXISTS idx_user_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_waste_user ON waste_collection(user_id);
CREATE INDEX IF NOT EXISTS idx_waste_date ON waste_collection(date);
CREATE INDEX IF NOT EXISTS idx_waste_type ON waste_collection(waste_type);
CREATE INDEX IF NOT EXISTS idx_logs_user ON waste_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_session_worker ON collection_sessions(worker_id);
CREATE INDEX IF NOT EXISTS idx_session_citizen ON collection_sessions(citizen_id);
CREATE INDEX IF NOT EXISTS idx_redemption_citizen ON redemptions(citizen_id);
CREATE INDEX IF NOT EXISTS idx_complaint_citizen ON complaints(citizen_id);
CREATE INDEX IF NOT EXISTS idx_complaint_status ON complaints(status);
CREATE INDEX IF NOT EXISTS idx_complaint_created ON complaints(created_at);

-- ===== Sample Data (Optional - for testing) =====
-- Uncomment the below lines to insert test accounts and sample collections
/*
INSERT INTO users (name, email, password, role, qr_code, points) VALUES
('City Admin', 'admin@example.com', 'admin123', 'ADMIN', 'ADMIN-0001', 0),
('Worker One', 'worker@example.com', 'worker123', 'WORKER', 'WORKER-0001', 0),
('Citizen One', 'citizen@example.com', 'citizen123', 'CITIZEN', 'CITIZEN-0001', 10);

INSERT INTO collection_sessions (worker_id, citizen_id, qr_code, total_organic, total_dry, total_reject, total_collected, segregation_score, points_awarded, notes, session_date) VALUES
(2, 3, 'CITIZEN-0001', 2.5, 1.0, 0.2, 3.7, 95.95, 8, 'Test pickup', '2026-05-19');

INSERT INTO redemptions (citizen_id, points_requested, reward_type, status) VALUES
(3, 5, 'UPI Voucher', 'APPROVED');
*/

-- ===== Display Table Structures =====
SHOW TABLES;
DESC users;
DESC waste_collection;
DESC collection_sessions;
DESC redemptions;
DESC waste_logs;
