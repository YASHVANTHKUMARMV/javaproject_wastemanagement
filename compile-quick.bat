@echo off
REM Quick compile script

setlocal enabledelayedexpansion

set CLASSES_DIR=c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps\WEB-INF\classes
set JDBC_JAR=c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps\WEB-INF\lib\mysql-connector-j-9.6.0.jar
set SERVLET_JAR=c:\Program Files\Apache Software Foundation\Tomcat 9.0\lib\servlet-api.jar

echo Changing to %CLASSES_DIR%
cd /d "%CLASSES_DIR%"

echo.
echo Compiling Utility Classes...
javac -cp "%JDBC_JAR%;%SERVLET_JAR%" com\wastemanagement\util\DBConnection.java com\wastemanagement\util\Constants.java
if errorlevel 1 goto error

echo Compiling Model Classes...
javac -cp "%JDBC_JAR%;%SERVLET_JAR%" com\wastemanagement\model\User.java com\wastemanagement\model\WasteRecord.java
if errorlevel 1 goto error

echo Compiling DAO Classes...
javac -cp "%JDBC_JAR%;%SERVLET_JAR%" com\wastemanagement\dao\UserDAO.java com\wastemanagement\dao\WasteDAO.java
if errorlevel 1 goto error

echo Compiling Servlet Classes...
javac -cp "%JDBC_JAR%;%SERVLET_JAR%" com\wastemanagement\controller\LoginServlet.java com\wastemanagement\controller\RegisterServlet.java com\wastemanagement\controller\LogoutServlet.java com\wastemanagement\controller\WasteServlet.java
if errorlevel 1 goto error

echo.
echo ✓ All classes compiled successfully!
echo.
echo Verifying .class files:
dir /s /b *.class
echo.
goto end

:error
echo.
echo ✗ Compilation FAILED!
pause
exit /b 1

:end
echo.
echo Ready to start Tomcat!
echo.
pause
