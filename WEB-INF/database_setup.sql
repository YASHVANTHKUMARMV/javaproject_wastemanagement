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
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

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
CREATE INDEX idx_user_email ON users(email);
CREATE INDEX idx_waste_user ON waste_collection(user_id);
CREATE INDEX idx_waste_date ON waste_collection(date);
CREATE INDEX idx_waste_type ON waste_collection(waste_type);
CREATE INDEX idx_logs_user ON waste_logs(user_id);

-- ===== Sample Data (Optional - for testing) =====
-- Uncomment the below lines to insert test data
/*
INSERT INTO users (name, email, password) VALUES
('John Doe', 'john@example.com', 'password123'),
('Jane Smith', 'jane@example.com', 'password456');

INSERT INTO waste_collection (user_id, waste_type, quantity, location, date, notes) VALUES
(1, 'Plastic', 5.5, 'Building A, Floor 2', '2026-05-19', 'Plastic bottles and bags'),
(1, 'Paper', 3.2, 'Office Desk', '2026-05-19', 'Office papers'),
(2, 'Organic', 2.8, 'Kitchen', '2026-05-19', 'Food waste'),
(2, 'Glass', 1.5, 'Recycling Center', '2026-05-19', 'Glass bottles');
*/

-- ===== Display Table Structures =====
SHOW TABLES;
DESC users;
DESC waste_collection;
DESC waste_logs;
