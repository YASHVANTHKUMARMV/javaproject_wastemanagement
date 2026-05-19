@echo off
REM Verify Java and Tomcat environment
echo.
echo ========================================
echo Environment Verification
echo ========================================
echo.

echo Java Version:
javac -version
echo.

echo Tomcat Location:
echo c:\Program Files\Apache Software Foundation\Tomcat 9.0\lib\servlet-api.jar exists:
if exist "c:\Program Files\Apache Software Foundation\Tomcat 9.0\lib\servlet-api.jar" (
    echo YES ✓
) else (
    echo NO ✗
)
echo.

echo MySQL Connector exists:
if exist "c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps\WEB-INF\lib\mysql-connector-j-9.6.0.jar" (
    echo YES ✓
) else (
    echo NO ✗
)
echo.

echo Classes Directory:
echo c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps\WEB-INF\classes\com\wastemanagement\controller\
if exist "c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps\WEB-INF\classes\com\wastemanagement\controller\" (
    echo Exists ✓
    echo Contents:
    dir /b "c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps\WEB-INF\classes\com\wastemanagement\controller\"
) else (
    echo Does not exist ✗
)
echo.

pause
