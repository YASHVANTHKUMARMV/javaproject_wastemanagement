@echo off
REM Compilation script for Smart Waste Monitoring System
REM This script compiles all Java classes needed for the application

setlocal enabledelayedexpansion

echo ========================================
echo Smart Waste Monitoring System
echo Java Compilation Script
echo ========================================

REM Set paths
set CLASSES_DIR=%~dp0WEB-INF\classes
set LIB_DIR=%~dp0WEB-INF\lib
set JDBC_JAR=%LIB_DIR%\mysql-connector-j-9.6.0.jar
set CATALINA_HOME=c:\Program Files\Apache Software Foundation\Tomcat 9.0
set SERVLET_JAR=%CATALINA_HOME%\lib\servlet-api.jar

echo.
echo Checking directories...

if not exist "%CLASSES_DIR%" (
    echo ERROR: Classes directory not found at %CLASSES_DIR%
    pause
    exit /b 1
)

if not exist "%JDBC_JAR%" (
    echo ERROR: MySQL JDBC JAR not found at %JDBC_JAR%
    pause
    exit /b 1
)

if not exist "%SERVLET_JAR%" (
    echo ERROR: Tomcat 9 servlet-api.jar not found at %SERVLET_JAR%
    pause
    exit /b 1
)

echo Directories OK
echo Tomcat 9.0 detected
echo.

REM Change to classes directory
cd /d "%CLASSES_DIR%"

set CLASSPATH=.\;%JDBC_JAR%;%SERVLET_JAR%

echo Current directory: %CD%
echo.

echo ========================================
echo STEP 1: Compiling Utility Classes
echo ========================================

javac -cp "%CLASSPATH%" ^
  com/wastemanagement/util/DBConnection.java ^
  com/wastemanagement/util/Constants.java

if errorlevel 1 (
    echo ERROR: Failed to compile utility classes
    pause
    exit /b 1
)

echo ✓ Utility classes compiled successfully
echo.

echo ========================================
echo STEP 2: Compiling Model Classes
echo ========================================

javac -cp "%CLASSPATH%" ^
  com/wastemanagement/model/User.java ^
  com/wastemanagement/model/WasteRecord.java ^
  com/wastemanagement/model/CollectionSession.java ^
  com/wastemanagement/model/Redemption.java ^
  com/wastemanagement/model/Complaint.java

if errorlevel 1 (
    echo ERROR: Failed to compile model classes
    pause
    exit /b 1
)

echo ✓ Model classes compiled successfully
echo.

echo ========================================
echo STEP 3: Compiling DAO Classes
echo ========================================

javac -cp "%CLASSPATH%" ^
  com/wastemanagement/dao/UserDAO.java ^
  com/wastemanagement/dao/WasteDAO.java ^
  com/wastemanagement/dao/CollectionDAO.java ^
  com/wastemanagement/dao/RedemptionDAO.java ^
  com/wastemanagement/dao/ComplaintsDAO.java

if errorlevel 1 (
    echo ERROR: Failed to compile DAO classes
    pause
    exit /b 1
)

echo ✓ DAO classes compiled successfully
echo.

echo ========================================
echo STEP 4: Compiling Servlet Classes
echo ========================================

javac -cp "%CLASSPATH%" ^
  com/wastemanagement/controller/LoginServlet.java ^
  com/wastemanagement/controller/RegisterServlet.java ^
  com/wastemanagement/controller/LogoutServlet.java ^
  com/wastemanagement/controller/WasteServlet.java ^
  com/wastemanagement/controller/CollectionServlet.java ^
  com/wastemanagement/controller/RedemptionServlet.java ^
  com/wastemanagement/controller/ComplaintsServlet.java

if errorlevel 1 (
    echo ERROR: Failed to compile servlet classes
    pause
    exit /b 1
)

echo ✓ Servlet classes compiled successfully
echo.

echo ========================================
echo COMPILATION COMPLETE
echo ========================================

echo.
echo Compiled files:
dir /s /b *.class | find /c ":"

echo.
echo Next steps:
echo 1. Start MySQL server
echo 2. Create database: mysql -u root -p < "..\..\database_setup.sql"
echo 3. Start Tomcat: cd ..\..\..\..\bin ^& startup.bat
echo 4. Access application at http://localhost:8080/Userwebapps/
echo.

pause
