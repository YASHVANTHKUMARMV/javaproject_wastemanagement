# Smart Waste Monitoring System - Architecture Overview

## Complete System Architecture

```
┌────────────────────────────────────────────────────────────────────────────┐
│                            TOMCAT 9.0 CONTAINER                            │
│  http://localhost:8080/Userwebapps/                                       │
└────────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────────┐
│                          PRESENTATION LAYER (JSP)                          │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  index.jsp   │  │  login.jsp   │  │ register.jsp │  │ error.jsp    │  │
│  │  (Public)    │  │  (Public)    │  │  (Public)    │  │  (Error)     │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘  │
│                                                                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │dashboard.jsp │  │ waste-coll..│  │ history.jsp  │  │ profile.jsp  │  │
│  │ (Protected)  │  │ (Protected)  │  │ (Protected)  │  │ (Protected)  │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘  │
│                                                                            │
│  css/style.css → Responsive Modern Design                                 │
└────────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────────┐
│                     CONTROLLER LAYER (Java Servlets)                       │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  ┌────────────────────────┐  ┌────────────────────────┐                 │
│  │  LoginServlet          │  │ RegisterServlet        │                 │
│  │  POST /login           │  │ POST /register         │                 │
│  │  Authenticate user     │  │ Validate & create user │                 │
│  └────────────────────────┘  └────────────────────────┘                 │
│                                                                            │
│  ┌────────────────────────┐  ┌────────────────────────┐                 │
│  │  LogoutServlet         │  │ WasteServlet           │                 │
│  │  GET /logout           │  │ POST /waste            │                 │
│  │  Invalidate session    │  │ Record waste entry     │                 │
│  └────────────────────────┘  └────────────────────────┘                 │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
                                     │
                                     │ DAO methods call
                                     ↓
┌────────────────────────────────────────────────────────────────────────────┐
│                    MODEL & DATA ACCESS LAYER (DAO)                         │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  ┌─────────────────────────┐          ┌─────────────────────────┐       │
│  │     UserDAO             │          │    WasteDAO             │       │
│  ├─────────────────────────┤          ├─────────────────────────┤       │
│  │ registerUser()          │          │ addWasteRecord()        │       │
│  │ authenticateUser()      │          │ getRecordsByUserId()    │       │
│  │ emailExists()           │          │ getTotalWasteByType()   │       │
│  │ getUserById()           │          │ getTotalWaste()         │       │
│  │ updateUser()            │          │ deleteRecord()          │       │
│  └─────────────────────────┘          └─────────────────────────┘       │
│                                                                            │
│  Uses:                                                                     │
│  ┌─────────────────────────┐          ┌─────────────────────────┐       │
│  │     User (POJO)         │          │  WasteRecord (POJO)     │       │
│  ├─────────────────────────┤          ├─────────────────────────┤       │
│  │ id, name, email         │          │ id, userId, wasteType   │       │
│  │ password, createdAt     │          │ quantity, location, ...│       │
│  └─────────────────────────┘          └─────────────────────────┘       │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
                                     │
                                     │ Prepare SQL queries
                                     ↓
┌────────────────────────────────────────────────────────────────────────────┐
│              UTILITY LAYER (Database & Configuration)                      │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  ┌──────────────────────────────┐  ┌──────────────────────────────┐    │
│  │  DBConnection                │  │  Constants                   │    │
│  ├──────────────────────────────┤  ├──────────────────────────────┤    │
│  │ getConnection()              │  │ SESSION_USER                 │    │
│  │ closeConnection()            │  │ SESSION_EMAIL                │    │
│  │                              │  │ SESSION_ID                   │    │
│  │ URL: jdbc:mysql://localhost  │  │ SUCCESS / ERROR              │    │
│  │ USER: root                   │  │ WASTE_TYPES[]                │    │
│  │ PASSWORD: vasanth@1717       │  │                              │    │
│  │ DRIVER: mysql-connector-j    │  │                              │    │
│  └──────────────────────────────┘  └──────────────────────────────┘    │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
                                     │
                                     │ JDBC Prepared Statements
                                     │ Prevent SQL Injection
                                     ↓
┌────────────────────────────────────────────────────────────────────────────┐
│                         MYSQL DATABASE LAYER                               │
│                      localhost:3306/wastemanagement                        │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  ┌──────────────────────────┐  ┌──────────────────────────┐             │
│  │    users TABLE           │  │  waste_collection TABLE  │             │
│  ├──────────────────────────┤  ├──────────────────────────┤             │
│  │ id (PK)                  │  │ id (PK)                  │             │
│  │ name                     │  │ user_id (FK) → users.id  │             │
│  │ email (UNIQUE)           │  │ waste_type               │             │
│  │ password                 │  │ quantity                 │             │
│  │ created_at               │  │ unit                     │             │
│  │ updated_at               │  │ location                 │             │
│  │                          │  │ date                     │             │
│  │ Indexes:                 │  │ notes                    │             │
│  │ - email                  │  │ created_at               │             │
│  │                          │  │                          │             │
│  │                          │  │ Indexes:                 │             │
│  │                          │  │ - user_id                │             │
│  │                          │  │ - date                   │             │
│  │                          │  │ - waste_type             │             │
│  └──────────────────────────┘  └──────────────────────────┘             │
│                                                                            │
│  ┌──────────────────────────┐                                            │
│  │   waste_logs TABLE       │                                            │
│  ├──────────────────────────┤                                            │
│  │ id (PK)                  │                                            │
│  │ user_id (FK) → users.id  │                                            │
│  │ action                   │                                            │
│  │ description              │                                            │
│  │ created_at               │                                            │
│  └──────────────────────────┘                                            │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

---

## Request-Response Flow Diagram

### Login Flow

```
User Browser                 Tomcat Server              MySQL Database
     │                            │                           │
     │  1. GET /login.jsp         │                           │
     ├──────────────────────────→ │                           │
     │                            │                           │
     │  2. Return login.jsp       │                           │
     │ ←──────────────────────────┤                           │
     │                            │                           │
     │  3. User enters email/pwd  │                           │
     │  4. POST /login            │                           │
     ├──────────────────────────→ │ LoginServlet.doPost()     │
     │                            │  - Validate input         │
     │                            │ 5. authenticateUser()     │
     │                            ├──────────────────────────→│
     │                            │ Query: SELECT * FROM users│
     │                            │ WHERE email=? AND pwd=?   │
     │                            │ 6. ResultSet returned     │
     │                            │←──────────────────────────┤
     │                            │  - User found             │
     │                            │  - Create session         │
     │                            │  - Set attributes         │
     │  7. Redirect /dashboard    │                           │
     │ ←──────────────────────────┤                           │
     │                            │                           │
     │  8. GET /dashboard.jsp     │                           │
     ├──────────────────────────→ │                           │
     │   (with session cookie)    │                           │
     │                            │ Check session exists      │
     │  9. Return dashboard.jsp   │                           │
     │ ←──────────────────────────┤                           │
     │                            │                           │
```

### Waste Logging Flow

```
User Browser                 Tomcat Server              MySQL Database
     │                            │                           │
     │  1. GET /waste-coll.jsp    │                           │
     ├──────────────────────────→ │                           │
     │                            │ Check session             │
     │  2. Return form            │                           │
     │ ←──────────────────────────┤                           │
     │                            │                           │
     │  3. User fills & submits   │                           │
     │     POST /waste            │                           │
     ├──────────────────────────→ │ WasteServlet.doPost()     │
     │                            │  - Validate session       │
     │                            │  - Validate data          │
     │                            │  - Create WasteRecord     │
     │                            │ 4. addWasteRecord()       │
     │                            ├──────────────────────────→│
     │                            │ INSERT INTO waste_collection
     │                            │ (user_id, waste_type, qty,│
     │                            │  location, date, notes)   │
     │                            │ VALUES (?, ?, ?, ?, ?, ?) │
     │                            │                           │
     │                            │ 5. Success result         │
     │                            │←──────────────────────────┤
     │  6. Show success msg       │                           │
     │ ←──────────────────────────┤                           │
     │                            │                           │
```

---

## Session Management Architecture

```
┌─────────────────────────────────────────────────────────┐
│              HTTP Session Management                    │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Session Created:                                       │
│  ┌─────────────────────────────────────────────────┐   │
│  │ When: After successful login                   │   │
│  │ Where: LoginServlet line ~60                   │   │
│  │ How: HttpSession session = request.getSession()│   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  Session Attributes Stored:                             │
│  ┌──────────────────────────────────────────────────┐  │
│  │ user       → "John Doe"                         │  │
│  │ email      → "john@example.com"                 │  │
│  │ userId     → 1                                  │  │
│  │                                                 │  │
│  │ (Defined in Constants.java)                    │  │
│  └──────────────────────────────────────────────────┘  │
│                                                         │
│  Session Timeout:                                       │
│  ┌──────────────────────────────────────────────────┐  │
│  │ Duration: 30 minutes (configurable in web.xml)  │  │
│  │ Cookie: JSESSIONID (HttpOnly, Secure)          │  │
│  │ Tracking: COOKIE mode (set in web.xml)         │  │
│  └──────────────────────────────────────────────────┘  │
│                                                         │
│  Session Access in JSP:                                 │
│  ┌──────────────────────────────────────────────────┐  │
│  │ Object userSession =                            │  │
│  │   session.getAttribute(Constants.SESSION_USER); │  │
│  │                                                 │  │
│  │ if (userSession == null) {                      │  │
│  │     // Not logged in → redirect to login       │  │
│  │     response.sendRedirect("login.jsp");         │  │
│  │ }                                               │  │
│  └──────────────────────────────────────────────────┘  │
│                                                         │
│  Session Invalidation:                                  │
│  ┌──────────────────────────────────────────────────┐  │
│  │ When: User clicks logout button                 │  │
│  │ Where: LogoutServlet                           │  │
│  │ How: session.invalidate()                       │  │
│  │ Result: All attributes cleared                  │  │
│  └──────────────────────────────────────────────────┘  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Database Query Examples

### Registration (INSERT)
```sql
INSERT INTO users(name, email, password, created_at)
VALUES(?, ?, ?, NOW())

Parameters:
? = "John Doe"
? = "john@example.com"
? = "password123"
```

### Login (SELECT)
```sql
SELECT id, name, email FROM users
WHERE email = ? AND password = ?

Parameters:
? = "john@example.com"
? = "password123"
```

### Add Waste Record (INSERT)
```sql
INSERT INTO waste_collection
(user_id, waste_type, quantity, unit, location, date, notes)
VALUES(?, ?, ?, ?, ?, ?, ?)

Parameters:
? = 1           (user_id)
? = "Plastic"   (waste_type)
? = 5.5         (quantity)
? = "kg"        (unit)
? = "Building A"(location)
? = "2026-05-19"(date)
? = "Plastic bottles"(notes)
```

### Get Waste History (SELECT)
```sql
SELECT id, user_id, waste_type, quantity, unit, location, date, notes
FROM waste_collection
WHERE user_id = ?
ORDER BY date DESC

Parameters:
? = 1 (user_id)
```

### Get Total Waste (AGGREGATE)
```sql
SELECT SUM(quantity) as total
FROM waste_collection
WHERE user_id = ?

Parameters:
? = 1 (user_id)
```

---

## Error Handling Architecture

```
┌─────────────────────────────────────────────────────┐
│           Error Handling Strategy                   │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Try-Catch Blocks:                                  │
│  ┌───────────────────────────────────────────────┐ │
│  │ try {                                        │ │
│  │   // Database operation                     │ │
│  │ } catch (SQLException e) {                  │ │
│  │   System.out.println("DB Error: " + e);     │ │
│  │   return false;                             │ │
│  │ } finally {                                 │ │
│  │   closeResources(con, ps, rs);              │ │
│  │ }                                           │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
│  User Feedback:                                     │
│  ┌───────────────────────────────────────────────┐ │
│  │ request.setAttribute("error",                │ │
│  │   Constants.DB_ERROR);                       │ │
│  │ request.getRequestDispatcher("page.jsp")     │ │
│  │   .forward(request, response);               │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
│  Error Page:                                        │
│  ┌───────────────────────────────────────────────┐ │
│  │ <error-page>                                 │ │
│  │   <error-code>404</error-code>              │ │
│  │   <location>/error.jsp</location>           │ │
│  │ </error-page>                               │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Security Architecture

```
┌──────────────────────────────────────────────────────┐
│          Security Layers Implementation             │
├──────────────────────────────────────────────────────┤
│                                                      │
│  Layer 1: SQL Injection Prevention                   │
│  ┌──────────────────────────────────────────────┐   │
│  │ ✓ Prepared Statements used everywhere       │   │
│  │ ✓ Parameters bound separately (?)           │   │
│  │ ✓ No string concatenation in queries        │   │
│  │                                              │   │
│  │ Example:                                     │   │
│  │ ps.setString(1, email);    // Safe          │   │
│  │ ps.setString(2, password); // Safe          │   │
│  └──────────────────────────────────────────────┘   │
│                                                      │
│  Layer 2: Session Security                          │
│  ┌──────────────────────────────────────────────┐   │
│  │ ✓ HttpOnly cookies (XSS prevention)         │   │
│  │ ✓ 30-minute timeout (session hijacking)     │   │
│  │ ✓ Session invalidation on logout            │   │
│  │ ✓ Session check on protected pages          │   │
│  └──────────────────────────────────────────────┘   │
│                                                      │
│  Layer 3: Input Validation                          │
│  ┌──────────────────────────────────────────────┐   │
│  │ ✓ Check null/empty inputs                   │   │
│  │ ✓ Parse numeric types (catch NumberFormat)  │   │
│  │ ✓ Email format validation (HTML5)           │   │
│  │ ✓ Password confirmation check               │   │
│  └──────────────────────────────────────────────┘   │
│                                                      │
│  Layer 4: Data Validation                           │
│  ┌──────────────────────────────────────────────┐   │
│  │ ✓ Check email doesn't already exist         │   │
│  │ ✓ Validate user exists before operations    │   │
│  │ ✓ Verify data integrity in queries          │   │
│  └──────────────────────────────────────────────┘   │
│                                                      │
│  ⚠️  NOT IMPLEMENTED (for production):              │
│  ┌──────────────────────────────────────────────┐   │
│  │ ✗ Password hashing (use bcrypt)            │   │
│  │ ✗ HTTPS/TLS encryption                      │   │
│  │ ✗ CSRF tokens                               │   │
│  │ ✗ Rate limiting                             │   │
│  │ ✗ Role-based access control                 │   │
│  │ ✗ Audit logging                             │   │
│  └──────────────────────────────────────────────┘   │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Component Interaction Diagram

```
┌────────────────────────────────────────────────────────────┐
│                    USER INTERACTION                        │
└────────────────────────────────────────────────────────────┘

Browser → HTML/CSS/JSP
   ↓
   ├─→ index.jsp (Public)
   ├─→ login.jsp (Public) ─→ Form submission ─→ LoginServlet
   ├─→ register.jsp (Public) ─→ Form submission ─→ RegisterServlet
   │
   ├─→ Dashboard (Protected) ─→ Session check ─→ dashboard.jsp
   ├─→ Waste Form (Protected) ─→ Session check ─→ waste-collection.jsp
   │                            → Form submission ─→ WasteServlet
   ├─→ History (Protected) ─→ Session check ─→ history.jsp
   │                       → Fetch data ─→ WasteDAO
   │                       → Display table
   │
   ├─→ Profile (Protected) ─→ Session check ─→ profile.jsp
   │                       → Fetch user ─→ UserDAO.getUserById()
   │
   └─→ logout ─→ LogoutServlet ─→ Invalidate session ─→ Redirect home

Servlet Components:
   ├─→ LoginServlet ─→ UserDAO.authenticateUser()
   ├─→ RegisterServlet ─→ UserDAO.registerUser()
   ├─→ LogoutServlet ─→ session.invalidate()
   └─→ WasteServlet ─→ WasteDAO.addWasteRecord()

DAO Layer:
   ├─→ UserDAO
   │   ├─→ registerUser() → INSERT
   │   ├─→ authenticateUser() → SELECT (Login)
   │   ├─→ emailExists() → SELECT (Validation)
   │   ├─→ getUserById() → SELECT (Profile)
   │   └─→ updateUser() → UPDATE
   │
   └─→ WasteDAO
       ├─→ addWasteRecord() → INSERT
       ├─→ getRecordsByUserId() → SELECT
       ├─→ getTotalWaste() → SELECT (Aggregate)
       ├─→ getTotalWasteByType() → SELECT (Group)
       └─→ deleteRecord() → DELETE

Database:
   ├─→ users table (CRUD)
   ├─→ waste_collection table (CRU)
   └─→ waste_logs table (C)
```

---

## Technology Stack Summary

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **View** | JSP | Dynamic web pages |
| | CSS | Styling & responsive design |
| | HTML5 | Page structure |
| **Controller** | Java Servlets | Request handling |
| | @WebServlet | Automatic URL mapping |
| **Model** | Java POJOs | Data representation |
| **Persistence** | JDBC | Database access |
| | PreparedStatement | Parameterized queries |
| | MySQL Driver | Database connectivity |
| **Infrastructure** | Tomcat 9.0 | Application server |
| | MySQL 5.7+ | Database server |
| | JDK 8+ | Java runtime |

---

**Architecture Version**: 1.0  
**Last Updated**: 2026-05-19  
**Status**: Complete and Documented
