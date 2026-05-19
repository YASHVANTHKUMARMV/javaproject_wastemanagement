# Smart Waste Monitoring System - Project Documentation

## Overview

A lightweight, academic-level Smart Waste Monitoring System built with Java Servlets, JSP, MySQL, and JDBC. Designed for learning and demonstration purposes.

## System Architecture

### Technology Stack
- **Frontend**: JSP, HTML5, CSS3
- **Backend**: Java Servlets (Tomcat 9.0)
- **Database**: MySQL 5.7+
- **JDBC Driver**: MySQL Connector/J 9.6.0
- **Pattern**: MVC (Model-View-Controller)

### Project Structure

#### 1. Model Layer (`com.wastemanagement.model`)
**Purpose**: Data representation objects

- **User.java**: Represents a user in the system
  - Properties: id, name, email, password, createdAt
  - Methods: Getters/Setters

- **WasteRecord.java**: Represents a waste collection entry
  - Properties: id, userId, wasteType, quantity, unit, location, date, notes
  - Methods: Getters/Setters

#### 2. Data Access Layer (`com.wastemanagement.dao`)
**Purpose**: Database operations and queries

- **UserDAO.java**: Handles user-related database operations
  - `registerUser()`: Insert new user
  - `authenticateUser()`: Validate login credentials
  - `emailExists()`: Check if email is already registered
  - `getUserById()`: Retrieve user profile
  - `updateUser()`: Update user information

- **WasteDAO.java**: Handles waste record operations
  - `addWasteRecord()`: Insert new waste entry
  - `getRecordsByUserId()`: Fetch all records for a user
  - `getTotalWasteByType()`: Get waste statistics by type
  - `getTotalWaste()`: Get total waste collected
  - `deleteRecord()`: Remove a waste entry

#### 3. Controller Layer (`com.wastemanagement.controller`)
**Purpose**: Handle HTTP requests and business logic

- **LoginServlet.java**: Handles user login
  - Endpoint: POST `/login`
  - Validates email and password
  - Creates session on successful login
  - Redirects to dashboard

- **RegisterServlet.java**: Handles user registration
  - Endpoint: POST `/register`
  - Validates input and checks for duplicate emails
  - Creates new user account
  - Redirects to login page

- **LogoutServlet.java**: Handles user logout
  - Endpoint: GET `/logout`
  - Invalidates user session
  - Redirects to home page

- **WasteServlet.java**: Handles waste logging
  - Endpoint: POST `/waste`
  - Requires active session
  - Validates waste data
  - Stores record in database

#### 4. Utility Layer (`com.wastemanagement.util`)
**Purpose**: Shared utilities and configurations

- **DBConnection.java**: Database connection management
  - Static method: `getConnection()` - Returns new MySQL connection
  - Static method: `closeConnection()` - Safely closes connection
  - Centralized credentials and driver configuration

- **Constants.java**: Application-wide constants
  - Session attribute names
  - Error/success messages
  - Waste type options

### View Layer (JSP Pages)

#### Public Pages (No Authentication)
- **index.jsp**: Landing page with features overview
- **login.jsp**: User login form
- **register.jsp**: User registration form
- **error.jsp**: Error handling page

#### Protected Pages (Requires Login)
- **dashboard.jsp**: Main dashboard with navigation options
- **waste-collection.jsp**: Form to log waste
- **history.jsp**: View all waste records with statistics
- **profile.jsp**: User profile and account information

### Styling

- **css/style.css**: Modern, responsive design
  - Gradient color scheme (purple/blue)
  - Mobile-first approach
  - Flexbox and Grid layouts
  - Hover effects and transitions
  - Print-friendly styles

---

## Database Schema

### Table: users
```sql
id INT PRIMARY KEY AUTO_INCREMENT
name VARCHAR(100) NOT NULL
email VARCHAR(100) UNIQUE NOT NULL
password VARCHAR(255) NOT NULL
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
```

### Table: waste_collection
```sql
id INT PRIMARY KEY AUTO_INCREMENT
user_id INT NOT NULL (FOREIGN KEY)
waste_type VARCHAR(50) NOT NULL
quantity DOUBLE NOT NULL
unit VARCHAR(20) DEFAULT 'kg'
location VARCHAR(200) NOT NULL
date DATE NOT NULL
notes TEXT
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

### Table: waste_logs
```sql
id INT PRIMARY KEY AUTO_INCREMENT
user_id INT NOT NULL (FOREIGN KEY)
action VARCHAR(100) NOT NULL
description TEXT
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

---

## Data Flow

### Registration Flow
```
User fills form
    ↓
POST /register
    ↓
RegisterServlet validates input
    ↓
Check email not duplicate (UserDAO.emailExists)
    ↓
Create User object
    ↓
UserDAO.registerUser() - Insert into DB
    ↓
Success → Redirect to login.jsp
Error → Show error message
```

### Login Flow
```
User enters credentials
    ↓
POST /login
    ↓
LoginServlet validates input
    ↓
UserDAO.authenticateUser() - Query database
    ↓
Match found → Create session
    ↓
Redirect to dashboard.jsp
```

### Waste Logging Flow
```
User fills waste form
    ↓
POST /waste
    ↓
WasteServlet checks session
    ↓
Validate input data
    ↓
Create WasteRecord object
    ↓
WasteDAO.addWasteRecord() - Insert into DB
    ↓
Success → Show confirmation
Error → Show error message
```

### View History Flow
```
User visits /history.jsp
    ↓
Check session (protected page)
    ↓
WasteDAO.getRecordsByUserId() - Fetch records
    ↓
WasteDAO.getTotalWaste() - Get statistics
    ↓
Display records in table with stats
```

---

## Security Considerations

### Current Implementation
- ✅ Session-based authentication
- ✅ Prepared statements (prevent SQL injection)
- ✅ Email uniqueness validation
- ✅ Session timeout (30 minutes)
- ✅ Protected pages (require login)

### Recommended Improvements
- ❌ Passwords stored in plain text (should use bcrypt/hashing)
- ❌ No HTTPS enforcement (should use in production)
- ❌ No input sanitization (add validation libraries)
- ❌ No CSRF protection (add CSRF tokens)

---

## Key Features

### 1. Authentication System
- User registration with validation
- Email/password login
- Session management
- Logout functionality
- "Remember session" across pages

### 2. Waste Management
- Log waste with multiple categories
- Track quantity and location
- Add notes and descriptions
- View complete history
- Calculate total waste collected

### 3. Dashboard
- Quick navigation to features
- User welcome message
- Quick statistics
- Action buttons for main tasks

### 4. Responsive Design
- Works on desktop, tablet, mobile
- Touch-friendly buttons
- Optimized forms
- Flexible grid layouts

---

## Configuration

### Database Connection (DBConnection.java)
```java
URL = "jdbc:mysql://localhost:3306/wastemanagement"
USER = "root"
PASSWORD = "vasanth@1717"
DRIVER = "com.mysql.cj.jdbc.Driver"
```

### Session Timeout (web.xml)
```xml
<session-config>
    <timeout>30</timeout>  <!-- 30 minutes -->
</session-config>
```

---

## Deployment Checklist

- [ ] MySQL database created
- [ ] Database tables created
- [ ] Java classes compiled
- [ ] WAR file created or deployed to Tomcat
- [ ] Database credentials configured
- [ ] MySQL JDBC driver in lib folder
- [ ] Tomcat started
- [ ] Application accessible at http://localhost:8080/Userwebapps/
- [ ] Test registration and login
- [ ] Test waste logging and history

---

## File Locations

```
c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps\
├── WEB-INF/
│   ├── classes/com/wastemanagement/
│   ├── lib/mysql-connector-j-9.6.0.jar
│   ├── web.xml
│   └── database_setup.sql
├── css/style.css
├── *.jsp files
├── DEPLOYMENT_GUIDE.md
└── README.md
```

---

## Testing

### Manual Testing Steps

1. **Registration Test**
   - Navigate to `/register`
   - Fill in name, email, password
   - Submit and verify success message
   - Check database for new user

2. **Login Test**
   - Navigate to `/login`
   - Use registered email and password
   - Verify redirect to dashboard

3. **Waste Logging Test**
   - Log in successfully
   - Go to "Log Waste" page
   - Fill in waste details
   - Submit and verify entry in history

4. **Session Test**
   - Log in and keep browser open for 31 minutes
   - Try to access protected page
   - Verify automatic redirect to login

5. **Logout Test**
   - Click logout button
   - Verify redirect to home page
   - Try to access protected page without logging in
   - Verify redirect to login page

---

## Performance Optimization

### Implemented
- Index on user.email (fast lookups)
- Index on waste_collection.user_id (fast history queries)
- Connection pooling (via DBConnection utility)
- Prepared statements (faster execution)

### Potential Improvements
- Add connection pooling library (HikariCP)
- Cache frequently accessed data
- Add pagination for large history lists
- Compress CSS and minimize JS
- Add database query optimization

---

## Browser Compatibility

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+
- Mobile browsers (iOS Safari, Chrome Mobile)

---

## Known Limitations

1. No password hashing (plain text storage)
2. No email verification on registration
3. No role-based access control (single user type)
4. No file upload capability
5. No real-time notifications
6. No data export functionality
7. Limited analytics/reporting

---

## Future Enhancement Ideas

1. **Advanced Features**
   - Password recovery via email
   - Two-factor authentication
   - Admin dashboard
   - User management panel
   - Bulk waste entry via CSV import

2. **Analytics**
   - Waste trends chart
   - Department-wise statistics
   - Monthly/yearly reports
   - Comparative analysis

3. **Integration**
   - IoT sensor integration
   - SMS notifications
   - Email notifications
   - API for mobile app

4. **Performance**
   - Caching layer (Redis)
   - Database query optimization
   - Async request processing
   - Image/file storage

---

## Support & Maintenance

### Regular Tasks
- Monitor database performance
- Check error logs
- Update dependencies
- Backup database regularly
- Review user activity

### Troubleshooting Guide
See DEPLOYMENT_GUIDE.md for common issues and solutions.

---

## License & Credits

- **Project**: Smart Waste Monitoring System
- **Version**: 1.0 Academic Edition
- **Created**: 2026-05-19
- **Purpose**: Educational and Demonstration

---

**Last Updated**: 2026-05-19
**Status**: Production Ready (Academic Level)
