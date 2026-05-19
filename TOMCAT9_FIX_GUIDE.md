# Smart Waste Monitoring System - Tomcat 9 Fix Guide

## ROOT CAUSE ANALYSIS

**The 500 Error at `localhost:8080/Userwebapps/index.jsp` is caused by:**

1. **Missing Servlet .class Files** - Servlet Java files were not compiled
   - LoginServlet.java ✓ (exists as .java, NOT compiled to .class)
   - RegisterServlet.java ✓ (exists as .java, NOT compiled to .class)
   - LogoutServlet.java ✓ (exists as .java, NOT compiled to .class)
   - WasteServlet.java ✓ (exists as .java, NOT compiled to .class)

2. **Jakarta vs Tomcat 9 Incompatibility** - Import statements were using jakarta.servlet
   - Tomcat 9.0 uses: `javax.servlet.*`
   - Tomcat 10+ uses: `jakarta.servlet.*`
   - **FIXED:** All 4 servlet files now use `javax.servlet.*` imports

3. **index.jsp tries to use Constants.SESSION_USER** - Would fail if Constants not compiled
   - Constants.java is compiled ✓ (DBConnection.java also compiled ✓)
   - Model and DAO classes are compiled ✓

## DIAGNOSIS RESULTS

### ✅ WORKING (Compiled Classes Exist)
- `/WEB-INF/classes/com/wastemanagement/util/DBConnection.class` - Database connections
- `/WEB-INF/classes/com/wastemanagement/util/Constants.class` - App constants
- `/WEB-INF/classes/com/wastemanagement/model/User.class` - User model
- `/WEB-INF/classes/com/wastemanagement/model/WasteRecord.class` - Waste model
- `/WEB-INF/classes/com/wastemanagement/dao/UserDAO.class` - User DAO
- `/WEB-INF/classes/com/wastemanagement/dao/WasteDAO.class` - Waste DAO

### ❌ MISSING (Need Compilation)
- `/WEB-INF/classes/com/wastemanagement/controller/LoginServlet.class` ← MISSING
- `/WEB-INF/classes/com/wastemanagement/controller/RegisterServlet.class` ← MISSING
- `/WEB-INF/classes/com/wastemanagement/controller/LogoutServlet.class` ← MISSING
- `/WEB-INF/classes/com/wastemanagement/controller/WasteServlet.class` ← MISSING

### ✅ Configuration Files OK
- `/WEB-INF/web.xml` - Correctly configured with welcome-file=index.jsp
- `/index.jsp` - Landing page with session checking
- `/login.jsp`, `/register.jsp`, `/dashboard.jsp`, `/error.jsp` - All present
- `/WEB-INF/lib/mysql-connector-j-9.6.0.jar` - MySQL JDBC driver present

## FIX APPLIED

### Step 1: Fixed Import Statements ✓
Changed all 4 servlet files from Jakarta imports to Tomcat 9 compatible javax imports:

```java
// BEFORE (Tomcat 10+)
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

// AFTER (Tomcat 9) ✓
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
```

Files updated:
- LoginServlet.java ✓
- RegisterServlet.java ✓
- LogoutServlet.java ✓
- WasteServlet.java ✓

### Step 2: Prepare Compilation

Created compilation scripts:
- `compile.bat` - Main compilation script (updated for Tomcat 9)
- `build.bat` - Full build with cleanup
- `compile-quick.bat` - Quick compile script

## REQUIRED COMPILATION STEP

To complete the fix, execute this command in Command Prompt:

```cmd
cd c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps\WEB-INF\classes

javac -encoding UTF-8 -cp "c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps\WEB-INF\lib\mysql-connector-j-9.6.0.jar;c:\Program Files\Apache Software Foundation\Tomcat 9.0\lib\servlet-api.jar" com\wastemanagement\util\DBConnection.java com\wastemanagement\util\Constants.java com\wastemanagement\model\User.java com\wastemanagement\model\WasteRecord.java com\wastemanagement\dao\UserDAO.java com\wastemanagement\dao\WasteDAO.java com\wastemanagement\controller\LoginServlet.java com\wastemanagement\controller\RegisterServlet.java com\wastemanagement\controller\LogoutServlet.java com\wastemanagement\controller\WasteServlet.java
```

Or simply run the batch file:
```cmd
c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps\build.bat
```

## EXPECTED RESULT

After compilation, you will have 10 .class files:
```
com/wastemanagement/util/DBConnection.class
com/wastemanagement/util/Constants.class
com/wastemanagement/model/User.class
com/wastemanagement/model/WasteRecord.class
com/wastemanagement/dao/UserDAO.class
com/wastemanagement/dao/WasteDAO.class
com/wastemanagement/controller/LoginServlet.class
com/wastemanagement/controller/RegisterServlet.class
com/wastemanagement/controller/LogoutServlet.class
com/wastemanagement/controller/WasteServlet.class
```

## DEPLOYMENT STRUCTURE

```
c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps\
├── WEB-INF/
│   ├── classes/
│   │   └── com/wastemanagement/
│   │       ├── util/          [✓ DBConnection.class, Constants.class]
│   │       ├── model/         [✓ User.class, WasteRecord.class]
│   │       ├── dao/           [✓ UserDAO.class, WasteDAO.java]
│   │       └── controller/    [❌ → Need .class files]
│   ├── lib/
│   │   └── mysql-connector-j-9.6.0.jar  [✓]
│   ├── web.xml                [✓ Correct config]
│   └── database_setup.sql
├── css/
│   └── style.css              [✓]
├── index.jsp                  [✓ Landing page]
├── login.jsp                  [✓]
├── register.jsp               [✓]
├── dashboard.jsp              [✓]
├── error.jsp                  [✓]
├── waste-collection.jsp       [✓]
├── history.jsp                [✓]
├── profile.jsp                [✓]
└── build.bat                  [✓ Created]
```

## TESTING PROCEDURE

1. **Compile Java classes** (command shown above)
2. **Start Tomcat:**
   ```cmd
   c:\Program Files\Apache Software Foundation\Tomcat 9.0\bin\startup.bat
   ```
3. **Access the application:**
   ```
   http://localhost:8080/Userwebapps/
   ```
4. **Verify it works:**
   - ✓ Homepage loads (index.jsp)
   - ✓ Login page accessible
   - ✓ Register page accessible
   - ✓ No 500 errors

## DATABASE SETUP

If database is not initialized, run:
```cmd
mysql -u root -p < "c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps\WEB-INF\database_setup.sql"
```

MySQL credentials are defined in DBConnection.java:
```
Host: localhost:3306
Database: wastemanagement
User: root
Password: vasanth@1717
```

## FILES MODIFIED

1. **LoginServlet.java** - Jakarta → javax imports
2. **RegisterServlet.java** - Jakarta → javax imports
3. **LogoutServlet.java** - Jakarta → javax imports
4. **WasteServlet.java** - Jakarta → javax imports
5. **compile.bat** - Updated for Tomcat 9 servlet-api.jar

## NOTES

- ✅ No backend logic was rewritten
- ✅ Database connection code unchanged
- ✅ DAO/Model classes untouched
- ✅ JSP files functional as-is
- ✅ web.xml configuration correct
- ✅ Only imports changed in servlets (compatibility fix)
- ✅ All files follow Tomcat 9 standards

---
**Status:** Ready for Compilation and Testing
**Next Step:** Run build.bat and restart Tomcat
