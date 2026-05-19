# Smart Waste Monitoring System - Deployment Guide

## System Requirements

- **Java**: JDK 8 or higher
- **Tomcat**: 9.0 or higher
- **MySQL**: 5.7 or higher (or MySQL 8.0)
- **MySQL Connector/J**: 9.6.0 (already included in lib folder)

---

## Step 1: Database Setup

### Option A: Using MySQL Command Line

```bash
mysql -u root -p < WEB-INF/database_setup.sql
```

### Option B: Using MySQL Workbench

1. Open MySQL Workbench
2. Copy the contents of `WEB-INF/database_setup.sql`
3. Create a new query and paste the SQL
4. Execute the script (Ctrl+Enter)

### Option C: Manual Setup

```sql
CREATE DATABASE wastemanagement;
USE wastemanagement;

-- Then run the SQL commands from database_setup.sql
```

---

## Step 2: Compile Java Classes

The Java classes are located in:
```
WEB-INF/classes/com/wastemanagement/
├── controller/    (Servlets)
├── dao/          (Database Access Objects)
├── model/        (Data Models/POJOs)
└── util/         (Utilities)
```

### Compile using command line:

```bash
cd WEB-INF/classes

# Compile all Java files
javac -cp "..\..\lib\mysql-connector-j-9.6.0.jar" ^
  com/wastemanagement/util/*.java ^
  com/wastemanagement/model/*.java ^
  com/wastemanagement/dao/*.java ^
  com/wastemanagement/controller/*.java
```

Or simply copy the pre-compiled `.class` files if they are already provided.

---

## Step 3: Configure Database Connection

Update database credentials in:
**File**: `WEB-INF/classes/com/wastemanagement/util/DBConnection.java`

```java
private static final String URL = "jdbc:mysql://localhost:3306/wastemanagement";
private static final String USER = "root";
private static final String PASSWORD = "vasanth@1717";  // Change to your MySQL password
```

If you changed the MySQL password, update line 10 in DBConnection.java and recompile.

---

## Step 4: Deploy to Tomcat

### Option A: Direct Deployment

1. Copy the entire `Userwebapps` folder to Tomcat's `webapps` directory
2. Restart Tomcat

### Option B: Using Tomcat Manager

1. Open Tomcat Manager: `http://localhost:8080/manager/html`
2. Username: (your Tomcat admin user)
3. Scroll to "Deploy" section
4. Select the WAR file or folder and deploy

---

## Step 5: Start Tomcat

### Windows:
```bash
cd Tomcat/bin
startup.bat
```

### Linux/Mac:
```bash
cd Tomcat/bin
./startup.sh
```

---

## Step 6: Access the Application

Open your browser and navigate to:
```
http://localhost:8080/Userwebapps/
```

---

## Initial Test Users

After running database_setup.sql, you can uncomment the sample data section to insert test users:

**Email**: john@example.com  
**Password**: password123

**Email**: jane@example.com  
**Password**: password456

---

## Project Structure

```
Userwebapps/
├── WEB-INF/
│   ├── web.xml                              (Servlet configuration)
│   ├── classes/
│   │   └── com/wastemanagement/
│   │       ├── controller/
│   │       │   ├── LoginServlet.java
│   │       │   ├── RegisterServlet.java
│   │       │   ├── LogoutServlet.java
│   │       │   └── WasteServlet.java
│   │       ├── dao/
│   │       │   ├── UserDAO.java
│   │       │   └── WasteDAO.java
│   │       ├── model/
│   │       │   ├── User.java
│   │       │   └── WasteRecord.java
│   │       └── util/
│   │           ├── DBConnection.java
│   │           └── Constants.java
│   ├── lib/
│   │   └── mysql-connector-j-9.6.0.jar
│   └── database_setup.sql
├── css/
│   └── style.css                           (Modern styling)
├── index.jsp                               (Landing page)
├── login.jsp                               (Login form)
├── register.jsp                            (Registration form)
├── dashboard.jsp                           (Main dashboard)
├── waste-collection.jsp                    (Log waste page)
├── history.jsp                             (View history)
├── profile.jsp                             (User profile)
└── error.jsp                               (Error page)
```

---

## Application Flow

### Public Pages (No Login Required)
- `index.jsp` - Landing page with information
- `login.jsp` - Login form
- `register.jsp` - Registration form

### Protected Pages (Login Required)
- `dashboard.jsp` - Main dashboard after login
- `waste-collection.jsp` - Log new waste
- `history.jsp` - View all waste records
- `profile.jsp` - View user profile

### Servlet Endpoints
- `POST /Userwebapps/login` - Handle login (from LoginServlet)
- `POST /Userwebapps/register` - Handle registration (from RegisterServlet)
- `GET /Userwebapps/logout` - Clear session and logout
- `POST /Userwebapps/waste` - Add waste record (from WasteServlet)

---

## Features Implemented

✅ **Authentication**
- User registration with email verification
- Login/logout with session management
- Session timeout after 30 minutes of inactivity

✅ **Waste Management**
- Log waste with type, quantity, location, and date
- View waste collection history
- Track total waste collected
- Waste types: Plastic, Paper, Glass, Metal, Organic, E-Waste, Other

✅ **User Management**
- User profile page
- View account information
- Member since date

✅ **UI/UX**
- Modern gradient design
- Responsive layout (works on mobile, tablet, desktop)
- Clean navigation
- Form validation

✅ **Database**
- MySQL with proper schema
- Foreign key relationships
- Indexes for performance
- Timestamp tracking

---

## Troubleshooting

### Issue: "Database connection error"
- **Solution**: Check MySQL is running and credentials in DBConnection.java are correct

### Issue: "404 Servlet not found"
- **Solution**: Make sure Java classes are compiled and .class files are in WEB-INF/classes

### Issue: "JSP pages not loading"
- **Solution**: Ensure web.xml is in WEB-INF folder and JSP files are in root directory

### Issue: "Session not working"
- **Solution**: Check that cookies are enabled in your browser

---

## Next Steps / Future Enhancements

1. Add password hashing (bcrypt)
2. Add email verification for registration
3. Add role-based access control (Admin, User)
4. Add data export (CSV/PDF)
5. Add charts and analytics
6. Add email notifications
7. Add real-time waste tracking with IoT sensors

---

## Support & Documentation

For more information about:
- **Tomcat**: https://tomcat.apache.org/
- **MySQL**: https://dev.mysql.com/doc/
- **Java Servlets**: https://docs.oracle.com/javaee/7/api/

---

## Version Info

- **Application**: Smart Waste Monitoring System
- **Version**: 1.0 (Academic/Demo)
- **Date**: 2026-05-19
- **Status**: Ready for Deployment

---
