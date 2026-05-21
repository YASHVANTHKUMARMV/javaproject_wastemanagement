# Smart Waste Monitoring System - Project Documentation

## Overview

A premium, dynamic Smart Waste Monitoring System built with Java Servlets, JSP, JDBC, and MySQL. It features a modern role-based (Citizen, Sanitation Worker, Admin) workflow, QR-code citizen verification, real-time conveyor belt sorting simulation, automated points calculations, rewards redemptions via UPI, and interactive admin dashboards with data visualization (Chart.js).

---

## Key Features

### 1. Role-Based Authentication & Portal Access
* **Role Options**: Users can register and log in as one of three distinct roles:
  * **Citizen**: Views their unique profile QR Code/ID, waste collection history, rewards balance, and points redemption options.
  * **Sanitation Worker**: Verifies citizens using QR scanning or manual QR ID lookup, logs real-time waste weights, and runs conveyor belt sorting.
  * **Admin**: Monitors ward-wise performance, waste distribution charts, registered citizen and worker directories, and approves/rejects points redemptions.
* **Ward-Wise Registration**: Captures address and ward location for optimized routing and metrics tracking.

### 2. Real-Time QR Verification
* **Citizen QR Profile**: Every citizen gets a unique QR Code image and corresponding alphanumeric QR Code ID generated at registration.
* **Worker lookup**: Sanitation workers enter or scan the citizen's QR Code ID to establish a real-time collection session.

### 3. Waste Sorting Simulation & Database Records
* **Conveyor Belt Animation**: Visualizing conveyor belt sorting when weights are submitted.
* **Segregation Score**: Calculates a dynamic segregation accuracy percentage based on:
  $$\text{Accuracy} = \frac{\text{Organic (Wet)} + \text{Dry}}{\text{Total Collected}} \times 100$$
* **Reward Points**: Rewards are automatically calculated ($1\text{ point per kg of correctly segregated waste}$) and added to the citizen's profile.
* **Collection Database Logging**: Stores worker, citizen, waste type weights, notes, and session dates in the SQL database.

### 4. Reward Redemption & UPI Integration
* **Redemption Portal**: Citizens can redeem accumulated points (e.g. 100 points = ₹10) for public transport vouchers.
* **UPI Checkout**: Interactive GPay/PhonePe simulated checkout overlay where users enter their UPI ID and receive instant virtual payments.
* **Admin Review**: Redemptions are sent as "PENDING" to the Admin dashboard, where the Admin can approve or reject them.

### 5. Interactive Admin Dashboards
* **Aggregated Charts (Chart.js)**:
  * Doughnut chart showing Wet (Organic) vs. Dry vs. Reject waste distribution.
  * Line graph tracking daily collection trends.
  * Bar chart comparing average segregation accuracy by ward.
* **Directories**: Dynamic tabular directories showing all registered Citizens (names, wards, points) and Sanitation Workers.
* **Collection Logs**: Shows recent collection activities with individual segregation scores, wet/dry/reject weights, and points awarded in real-time.

---

## System Architecture

### Technology Stack
* **Frontend**: JSP, HTML5, Vanilla CSS3 (Outfit Google Font, glassmorphism templates, responsive layout).
* **Backend**: Java Servlets (Tomcat 9.0).
* **Database**: MySQL 5.7 / 8.0+.
* **JDBC Driver**: MySQL Connector/J 9.6.0.
* **Pattern**: MVC (Model-View-Controller).

### Project Directory Structure

```
Userwebapps/
├── WEB-INF/
│   ├── classes/
│   │   └── com/wastemanagement/
│   │       ├── controller/        # Servlets (Login, Register, Collection, Redemption, etc.)
│   │       ├── dao/               # Database Queries (UserDAO, CollectionDAO, RedemptionDAO, etc.)
│   │       ├── model/             # Entity Models (User, CollectionSession, Redemption, etc.)
│   │       └── util/              # Database connection helper (DBConnection, Constants)
│   ├── lib/                       # MySQL Connector JAR
│   ├── web.xml                    # Servlet mapping and session configuration
│   └── database_setup.sql         # Table schemas and sample test records
├── css/
│   └── style.css                  # UI theme, animations, dashboards, and responsive layout
├── index.jsp                      # Welcome page
├── login.jsp                      # Login form with role picker
├── register.jsp                   # Multi-field signup form (Ward, Role, Address)
├── citizenDashboard.jsp           # Citizen hub and QR display
├── workerDashboard.jsp            # Worker hub and QR scan page
├── collectionForm.jsp             # Conveyor sorting and weight log
├── redemption.jsp                 # Points cash-out via UPI
├── adminDashboard.jsp             # Main charts, Ward stats, user directories & logs
├── adminRedemptions.jsp           # Approve/reject redemptions
├── complaints.jsp                 # Complaints log
└── profile.jsp                    # Account profile page
```

---

## Database Schema

### 1. `users` Table
Stores registered accounts and profiles:
```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'citizen', -- 'citizen', 'worker', 'admin'
    ward VARCHAR(50),
    address VARCHAR(255),
    qr_code VARCHAR(100) UNIQUE,
    points INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 2. `collection_sessions` Table
Records worker-logged waste collection details:
```sql
CREATE TABLE collection_sessions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    worker_id INT NOT NULL,
    citizen_id INT NOT NULL,
    qr_code VARCHAR(100),
    total_organic DOUBLE NOT NULL DEFAULT 0.0,
    total_dry DOUBLE NOT NULL DEFAULT 0.0,
    total_reject DOUBLE NOT NULL DEFAULT 0.0,
    total_collected DOUBLE NOT NULL DEFAULT 0.0,
    segregation_score DOUBLE NOT NULL DEFAULT 0.0,
    points_awarded INT DEFAULT 0,
    notes TEXT,
    session_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (worker_id) REFERENCES users(id),
    FOREIGN KEY (citizen_id) REFERENCES users(id)
);
```

### 3. `redemptions` Table
Tracks points redemption requests:
```sql
CREATE TABLE redemptions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    points INT NOT NULL,
    upi_id VARCHAR(100) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING', -- 'PENDING', 'APPROVED', 'REJECTED'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

### 4. `complaints` Table
Tracks segregation issues and alerts:
```sql
CREATE TABLE complaints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

---

## Deployment & Setup

### Requirements
1. **Tomcat 9.0** installed on port `8080`.
2. **MySQL Database Server** running on port `3306`.

### Connection Configuration (`DBConnection.java`)
Verify MySQL login credentials match:
```java
private static final String URL = "jdbc:mysql://localhost:3306/wastemanagement";
private static final String USER = "root";
private static final String PASSWORD = "your_mysql_password";
```

### Compilation & Tomcat Deployment
1. Run `build.bat` to compile Java sources and place files in `WEB-INF/classes`.
2. Move/copy the `Userwebapps` folder into Tomcat's `webapps` directory.
3. Start Tomcat using the setup scripts (`start-tomcat.bat` or Tomcat Service manager).
4. Open your browser and navigate to: [http://localhost:8080/Userwebapps/](http://localhost:8080/Userwebapps/)

---

## Testing & Verification

A Python automated integration script (`test_flow.py`) is provided to verify backend flows. Run the script:
```bash
python test_flow.py
```
This script tests:
1. Citizen, Worker, and Admin registration and authentication.
2. QR ID verification and lookups.
3. Collection logging and point increments.
4. Redemption creation, checkout, and approval mechanisms.
