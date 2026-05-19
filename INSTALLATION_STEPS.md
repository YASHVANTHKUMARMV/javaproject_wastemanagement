# Installation & Compilation Steps for Tomcat 9

## QUICK START

### Step 1: Compile Java Classes (REQUIRED)

**Option A: Using provided batch file (EASIEST)**
```cmd
cd /d c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps
build.bat
```

**Option B: Manual compilation (if batch fails)**
```cmd
cd /d c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps\WEB-INF\classes

javac -encoding UTF-8 -cp "c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps\WEB-INF\lib\mysql-connector-j-9.6.0.jar;c:\Program Files\Apache Software Foundation\Tomcat 9.0\lib\servlet-api.jar" com\wastemanagement\util\DBConnection.java com\wastemanagement\util\Constants.java com\wastemanagement\model\User.java com\wastemanagement\model\WasteRecord.java com\wastemanagement\dao\UserDAO.java com\wastemanagement\dao\WasteDAO.java com\wastemanagement\controller\LoginServlet.java com\wastemanagement\controller\RegisterServlet.java com\wastemanagement\controller\LogoutServlet.java com\wastemanagement\controller\WasteServlet.java
```

**Wait for:** "✓ Compilation successful!" message

---

### Step 2: Verify Compiled Classes

After compilation, you should see these files created:
```
WEB-INF\classes\com\wastemanagement\controller\LoginServlet.class
WEB-INF\classes\com\wastemanagement\controller\RegisterServlet.class
WEB-INF\classes\com\wastemanagement\controller\LogoutServlet.class
WEB-INF\classes\com\wastemanagement\controller\WasteServlet.class
```

Check with:
```cmd
dir /s c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps\WEB-INF\classes\com\wastemanagement\controller\*.class
```

---

### Step 3: Setup Database (If Not Already Done)

```cmd
mysql -u root -p < "c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps\WEB-INF\database_setup.sql"
```

When prompted, enter MySQL password: `vasanth@1717`

---

### Step 4: Start Tomcat

```cmd
c:\Program Files\Apache Software Foundation\Tomcat 9.0\bin\startup.bat
```

Wait for: "Server startup in X ms"

---

### Step 5: Access the Application

Open browser and navigate to:
```
http://localhost:8080/Userwebapps/
```

### Expected Result:
✅ Homepage loads with "Smart Waste Monitoring System"
✅ No 500 errors
✅ Navigation menu shows
✅ Login/Register buttons visible

---

## TROUBLESHOOTING

### Issue: "404 Not Found" for /Userwebapps/
**Solution:** Check Tomcat is running and wait 10 seconds for deployment

### Issue: "500 Error: ClassNotFoundException"
**Solution:** Compilation failed. Run build.bat again or use Option B manual command

### Issue: "Connection refused" to MySQL
**Solution:** Start MySQL server:
```cmd
mysql -u root -p
```
Then setup database as shown in Step 3

### Issue: "Cannot find servlet-api.jar"
**Solution:** Check Tomcat 9 installation at:
```
c:\Program Files\Apache Software Foundation\Tomcat 9.0\lib\servlet-api.jar
```

---

## WHAT WAS FIXED

### Problem:
- Servlet files were using Jakarta imports (Tomcat 10+)
- Tomcat 9 uses javax.servlet
- This prevented compilation of 4 servlet files

### Solution Applied:
1. ✅ Updated LoginServlet.java imports
2. ✅ Updated RegisterServlet.java imports
3. ✅ Updated LogoutServlet.java imports
4. ✅ Updated WasteServlet.java imports
5. ✅ Created build.bat script for easy compilation

### What Remains Unchanged:
- ✅ Database logic intact
- ✅ DAO classes unchanged
- ✅ Model classes unchanged
- ✅ JSP pages functional
- ✅ web.xml configuration correct

---

## VERIFICATION CHECKLIST

- [ ] Java compilation completed without errors
- [ ] 4 .class files created in com/wastemanagement/controller/
- [ ] Database created in MySQL
- [ ] Tomcat started successfully
- [ ] http://localhost:8080/Userwebapps/ loads
- [ ] No 500 errors on homepage
- [ ] Login page accessible
- [ ] Register page accessible

---

## FILE STRUCTURE

```
Userwebapps/
├── WEB-INF/
│   ├── classes/com/wastemanagement/
│   │   ├── controller/   [4 new .class files after build]
│   │   ├── dao/         [DAO classes]
│   │   ├── model/       [Model classes]
│   │   └── util/        [Utility classes]
│   ├── lib/
│   │   └── mysql-connector-j-9.6.0.jar
│   ├── web.xml
│   └── database_setup.sql
├── css/
│   └── style.css
├── *.jsp files
└── build.bat            [NEW - Run this first!]
```

---

## NEXT STEPS

1. Run **build.bat**
2. Start Tomcat
3. Test at http://localhost:8080/Userwebapps/
4. Register a test account
5. Login and use dashboard

---

**Status:** Ready to Deploy
**Last Updated:** 2026-05-19
**Tomcat Version Required:** 9.0+
