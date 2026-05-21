@echo off
REM Clean and recompile all Java classes

setlocal enabledelayedexpansion

set CLASSES_DIR=c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps\WEB-INF\classes
set JDBC_JAR=c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps\WEB-INF\lib\mysql-connector-j-9.6.0.jar
set SERVLET_JAR=c:\Program Files\Apache Software Foundation\Tomcat 9.0\lib\servlet-api.jar

echo ========================================
echo Smart Waste Monitoring - Tomcat 9 Build
echo ========================================
echo.

echo Changing to %CLASSES_DIR%
cd /d "%CLASSES_DIR%"
if errorlevel 1 (
    echo ERROR: Cannot change to classes directory
    pause
    exit /b 1
)

echo Cleaning old .class files...
for /r %%f in (*.class) do del "%%f"
echo ✓ Old classes cleaned

echo.
echo Compiling all Java source files...
echo Classpath: %JDBC_JAR%;%SERVLET_JAR%
echo.

javac -encoding UTF-8 -cp "%JDBC_JAR%;%SERVLET_JAR%" ^
  com\wastemanagement\util\DBConnection.java ^
  com\wastemanagement\util\Constants.java ^
  com\wastemanagement\model\User.java ^
  com\wastemanagement\model\WasteRecord.java ^
  com\wastemanagement\model\CollectionSession.java ^
  com\wastemanagement\model\Redemption.java ^
  com\wastemanagement\model\Complaint.java ^
  com\wastemanagement\dao\UserDAO.java ^
  com\wastemanagement\dao\WasteDAO.java ^
  com\wastemanagement\dao\CollectionDAO.java ^
  com\wastemanagement\dao\RedemptionDAO.java ^
  com\wastemanagement\dao\ComplaintsDAO.java ^
  com\wastemanagement\controller\LoginServlet.java ^
  com\wastemanagement\controller\RegisterServlet.java ^
  com\wastemanagement\controller\LogoutServlet.java ^
  com\wastemanagement\controller\WasteServlet.java ^
  com\wastemanagement\controller\CollectionServlet.java ^
  com\wastemanagement\controller\RedemptionServlet.java ^
  com\wastemanagement\controller\AdminRedemptionServlet.java ^
  com\wastemanagement\controller\ComplaintsServlet.java


if errorlevel 1 (
    echo.
    echo ✗ COMPILATION FAILED
    echo Please check errors above
    pause
    exit /b 1
)

echo.
echo ✓ Compilation successful!
echo.
echo Verifying compiled classes:
for /r %%f in (*.class) do (
    echo   %%~nf
)
echo.
pause
