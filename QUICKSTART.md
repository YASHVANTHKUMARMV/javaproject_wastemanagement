# Smart Waste Monitoring System - Quick Start Guide

## ⚡ 5-Minute Setup

### Prerequisites
- MySQL Server running
- Tomcat 9.0 installed
- JDK 8+ installed

### Step 1: Create Database (2 minutes)

Open MySQL Command Line or MySQL Workbench and run:

```sql
CREATE DATABASE wastemanagement;
USE wastemanagement;

-- Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Waste Collection Table
CREATE TABLE waste_collection (
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

-- Waste Logs Table
CREATE TABLE waste_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    action VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### Step 2: Compile Java Classes (1 minute)

Open Command Prompt and navigate to:
```bash
cd "c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps\WEB-INF\classes"
```

Run:
```bash
javac -cp "..\lib\mysql-connector-j-9.6.0.jar" ^
  com/wastemanagement/util/DBConnection.java ^
  com/wastemanagement/util/Constants.java ^
  com/wastemanagement/model/User.java ^
  com/wastemanagement/model/WasteRecord.java ^
  com/wastemanagement/dao/UserDAO.java ^
  com/wastemanagement/dao/WasteDAO.java ^
  com/wastemanagement/controller/LoginServlet.java ^
  com/wastemanagement/controller/RegisterServlet.java ^
  com/wastemanagement/controller/LogoutServlet.java ^
  com/wastemanagement/controller/WasteServlet.java
```

### Step 3: Start Application (1 minute)

Start Tomcat:
```bash
cd "c:\Program Files\Apache Software Foundation\Tomcat 9.0\bin"
startup.bat
```

Wait for server to start, then open:
```
http://localhost:8080/Userwebapps/
```

### Step 4: Test Login (1 minute)

**Option A**: Use test data (uncomment in database_setup.sql)
- Email: john@example.com
- Password: password123

**Option B**: Create new account
- Click "Register"
- Fill in details
- Submit

---

## 🔍 Directory Structure

```
Userwebapps/
│
├── WEB-INF/
│   ├── classes/
│   │   └── com/wastemanagement/
│   │       ├── controller/     (4 Servlets)
│   │       ├── dao/           (2 DAO classes)
│   │       ├── model/         (2 POJOs)
│   │       └── util/          (2 Utilities)
│   │
│   ├── lib/
│   │   └── mysql-connector-j-9.6.0.jar
│   │
│   ├── web.xml                (Servlet config)
│   └── database_setup.sql     (Database creation)
│
├── css/
│   └── style.css             (Modern styling)
│
├── JSP Pages (8 files):
│   ├── index.jsp             (Home page)
│   ├── login.jsp             (Login form)
│   ├── register.jsp          (Registration form)
│   ├── dashboard.jsp         (Main dashboard)
│   ├── waste-collection.jsp  (Log waste)
│   ├── history.jsp           (View history)
│   ├── profile.jsp           (User profile)
│   └── error.jsp             (Error page)
│
└── Documentation:
    ├── README.md             (Full documentation)
    ├── DEPLOYMENT_GUIDE.md   (Deployment steps)
    ├── ARCHITECTURE.md       (This file)
    └── QUICKSTART.md
```

---

## 📊 Data Flow Diagram

### User Registration Flow
```
┌─────────────────────────┐
│ User fills Register    │
│ Form                   │
└────────┬────────────────┘
         │
         ↓
┌─────────────────────────────────────┐
│ POST /register                      │
│ (RegisterServlet)                   │
└────────┬────────────────────────────┘
         │
         ├─→ Validate input
         │
         ├─→ Check email exists
         │   (UserDAO.emailExists)
         │
         ├─→ Create User object
         │
         ├─→ Insert to DB
         │   (UserDAO.registerUser)
         │
         ├─→ Success
         │
         └─→ Redirect to login.jsp
```

### User Login Flow
```
┌──────────────────────┐
│ User enters         │
│ Email + Password    │
└─────────┬───────────┘
          │
          ↓
┌───────────────────────────────────┐
│ POST /login                       │
│ (LoginServlet)                    │
└─────────┬────────────────────────┘
          │
          ├─→ Validate input
          │
          ├─→ Query database
          │   (UserDAO.authenticateUser)
          │
          ├─→ Match found?
          │   YES → Create session
          │   NO  → Show error
          │
          ├─→ Set session attributes:
          │   - SESSION_USER
          │   - SESSION_EMAIL
          │   - SESSION_ID
          │
          └─→ Redirect to dashboard.jsp
```

### Waste Logging Flow
```
┌──────────────────────────┐
│ User fills waste        │
│ collection form         │
└─────────┬───────────────┘
          │
          ↓
┌────────────────────────────────┐
│ POST /waste                    │
│ (WasteServlet)                 │
└─────────┬───────────────────────┘
          │
          ├─→ Check session exists
          │
          ├─→ Validate data
          │
          ├─→ Create WasteRecord
          │
          ├─→ Insert to DB
          │   (WasteDAO.addWasteRecord)
          │
          ├─→ Success
          │
          └─→ Show confirmation
```

### Protected Page Access
```
┌──────────────────────────┐
│ User accesses           │
│ dashboard.jsp           │
└─────────┬───────────────┘
          │
          ↓
┌──────────────────────────────┐
│ Check session                │
│ (Constants.SESSION_USER)     │
└─────────┬────────────────────┘
          │
      ┌───┴───┐
      │       │
   YES│       │NO
      ↓       ↓
  ┌────┐   ┌─────────────┐
  │Show│   │Redirect to  │
  │page│   │login.jsp    │
  └────┘   └─────────────┘
```

---

## 🔐 Session Management

### Session Creation
- **When**: After successful login
- **Where**: LoginServlet line ~60
- **Duration**: 30 minutes (configurable in web.xml)
- **Attributes Stored**:
  - `user` → User name
  - `email` → User email
  - `userId` → User ID

### Session Validation
```java
// In protected JSP pages
<%
    Object userSession = session.getAttribute(Constants.SESSION_USER);
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
```

### Session Termination
- **Method**: GET `/logout` (LogoutServlet)
- **Action**: `session.invalidate()`
- **Redirect**: Back to index.jsp

---

## 🗄️ Database Connection Flow

```
Application
    ↓
DBConnection.getConnection()
    ↓
Load JDBC Driver
    ↓
DriverManager.getConnection()
    ↓
MySQL Server (localhost:3306)
    ↓
Database: wastemanagement
    ↓
Return Connection object
    ↓
DAO uses Connection
    ↓
Execute Query
    ↓
Process ResultSet
    ↓
Close resources
    ↓
closeConnection()
```

---

## 📝 Example: Adding a Waste Record

### Request
```
POST /Userwebapps/waste
Content-Type: application/x-www-form-urlencoded

wasteType=Plastic&quantity=5.5&location=Building A&notes=Plastic bottles
```

### Processing
```java
// 1. WasteServlet receives request
String wasteType = request.getParameter("wasteType");
double quantity = Double.parseDouble(request.getParameter("quantity"));

// 2. Create WasteRecord object
WasteRecord record = new WasteRecord(
    userId,              // From session
    wasteType,           // "Plastic"
    quantity,            // 5.5
    location,            // "Building A"
    LocalDate.now()      // Current date
);

// 3. Insert into database via DAO
WasteDAO wasteDAO = new WasteDAO();
boolean success = wasteDAO.addWasteRecord(record);

// 4. Execute SQL
// INSERT INTO waste_collection
// (user_id, waste_type, quantity, unit, location, date, notes)
// VALUES (1, "Plastic", 5.5, "kg", "Building A", "2026-05-19", "...")

// 5. Response
if (success) {
    request.setAttribute("success", "Record added!");
    request.getRequestDispatcher("waste-collection.jsp").forward(...);
}
```

---

## 🎯 Key Endpoints

| Endpoint | Method | Handler | Purpose |
|----------|--------|---------|---------|
| `/` | GET | index.jsp | Home page |
| `/login.jsp` | GET | JSP | Login form |
| `/login` | POST | LoginServlet | Process login |
| `/register.jsp` | GET | JSP | Register form |
| `/register` | POST | RegisterServlet | Process registration |
| `/logout` | GET | LogoutServlet | End session |
| `/dashboard.jsp` | GET | JSP | Main dashboard |
| `/waste-collection.jsp` | GET | JSP | Waste form |
| `/waste` | POST | WasteServlet | Record waste |
| `/history.jsp` | GET | JSP | View history |
| `/profile.jsp` | GET | JSP | User profile |
| `/error.jsp` | GET | JSP | Error page |

---

## ⚙️ Configuration Files

### web.xml
Located: `WEB-INF/web.xml`
- Application display name
- Session timeout: 30 minutes
- Welcome file: index.jsp
- Error pages: 404, 500
- Servlet auto-detection via @WebServlet

### DBConnection.java
Located: `WEB-INF/classes/com/wastemanagement/util/DBConnection.java`
```java
URL = "jdbc:mysql://localhost:3306/wastemanagement"
USER = "root"
PASSWORD = "vasanth@1717"
```

---

## ✅ Verification Checklist

After setup, verify:

- [ ] MySQL database created and running
- [ ] All 3 tables created (users, waste_collection, waste_logs)
- [ ] Java classes compiled to `.class` files
- [ ] MySQL JDBC driver in WEB-INF/lib
- [ ] Tomcat server started
- [ ] Can access http://localhost:8080/Userwebapps/
- [ ] Can register new user
- [ ] Can login with registered credentials
- [ ] Can log waste after login
- [ ] Can view waste history
- [ ] Session persists across pages
- [ ] Logout clears session
- [ ] Protected pages redirect to login

---

## 🚀 Performance Tips

1. **Database**: Add indexes on frequently searched columns
2. **Caching**: Implement result caching for user lookups
3. **Pooling**: Use HikariCP for connection pooling
4. **Compression**: Enable GZIP compression in Tomcat
5. **CDN**: Serve CSS/JS from CDN in production

---

## 🐛 Debug Mode

Add debug logging to see request flow:

```java
// In LoginServlet
System.out.println("Login attempt: " + email);
System.out.println("User found: " + (user != null));
System.out.println("Session created: " + session.getId());
```

Check Tomcat logs:
```
c:\Program Files\Apache Software Foundation\Tomcat 9.0\logs\catalina.out
```

---

## 📞 Support

For issues, check:
1. DEPLOYMENT_GUIDE.md → Troubleshooting section
2. MySQL error logs
3. Tomcat catalina.out log
4. Browser developer console (F12)

---

**Last Updated**: 2026-05-19  
**Version**: 1.0  
**Status**: Ready for Use
