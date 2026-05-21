USE wastemanagement;

-- Create collection_sessions table
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

-- Create redemptions table
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

-- Create complaints table
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

-- Create indexes
CREATE INDEX idx_session_citizen ON collection_sessions(citizen_id);
CREATE INDEX idx_session_worker ON collection_sessions(worker_id);
CREATE INDEX idx_redemption_citizen ON redemptions(citizen_id);
CREATE INDEX idx_complaint_citizen ON complaints(citizen_id);
CREATE INDEX idx_complaint_status ON complaints(status);

SHOW TABLES;
