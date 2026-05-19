@echo off
REM Compilation script for Smart Waste Monitoring System - Tomcat 9
REM Fixed for Tomcat 9 with javax.servlet imports

setlocal enabledelayedexpansion

echo ========================================
echo Smart Waste Monitoring System
echo Java Compilation Script (Tomcat 9)
echo ========================================

REM Set paths
set CLASSES_DIR=%~dp0WEB-INF\classes
set LIB_DIR=%~dp0WEB-INF\lib
set JDBC_JAR=%LIB_DIR%\mysql-connector-j-9.6.0.jar
set CATALINA_HOME=c:\Program Files\Apache Software Foundation\Tomcat 9.0

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

if not exist "%CATALINA_HOME%\lib\servlet-api.jar" (
    echo ERROR: Tomcat servlet-api.jar not found
    echo Looking for: %CATALINA_HOME%\lib\servlet-api.jar
    pause
    exit /b 1
)

echo Directories OK
echo.

REM Get servlet-api from Tomcat 9
set SERVLET_JAR=%CATALINA_HOME%\lib\servlet-api.jar

echo Current directory: %CD%
echo.

echo ========================================
echo STEP 1: Compiling Utility Classes
echo ========================================

cd /d "%CLASSES_DIR%"

javac -cp "%JDBC_JAR%;%SERVLET_JAR%" ^
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

javac -cp "%JDBC_JAR%;%SERVLET_JAR%" ^
  com/wastemanagement/model/User.java ^
  com/wastemanagement/model/WasteRecord.java

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

javac -cp "%JDBC_JAR%;%SERVLET_JAR%" ^
  com/wastemanagement/dao/UserDAO.java ^
  com/wastemanagement/dao/WasteDAO.java

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

javac -cp "%JDBC_JAR%;%SERVLET_JAR%" ^
  com/wastemanagement/controller/LoginServlet.java ^
  com/wastemanagement/controller/RegisterServlet.java ^
  com/wastemanagement/controller/LogoutServlet.java ^
  com/wastemanagement/controller/WasteServlet.java

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
echo Compiled files created:
dir /s /b *.class 2>nul | find /c ":"

echo.
echo Next steps:
echo 1. Start Tomcat: "%CATALINA_HOME%\bin\startup.bat"
echo 2. Access application at http://localhost:8080/Userwebapps/
echo 3. Check logs in "%CATALINA_HOME%\logs\" for any errors
echo.

pause
