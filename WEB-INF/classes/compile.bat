@echo off
cd /d "c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps\WEB-INF\classes"

echo Cleaning existing .class files...
for /r com\wastemanagement %%f in (*.class) do del "%%f" 2>nul
echo Cleanup complete.

echo.
echo Compiling Java source files...
javac -encoding UTF-8 -cp "c:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\Userwebapps\WEB-INF\lib\mysql-connector-j-9.6.0.jar;c:\Program Files\Apache Software Foundation\Tomcat 9.0\lib\servlet-api.jar" com\wastemanagement\util\DBConnection.java com\wastemanagement\util\Constants.java com\wastemanagement\model\User.java com\wastemanagement\model\WasteRecord.java com\wastemanagement\dao\UserDAO.java com\wastemanagement\dao\WasteDAO.java com\wastemanagement\controller\LoginServlet.java com\wastemanagement\controller\RegisterServlet.java com\wastemanagement\controller\LogoutServlet.java com\wastemanagement\controller\WasteServlet.java

echo.
if %ERRORLEVEL% EQU 0 (
    echo Compilation completed successfully!
    echo.
    echo Verifying compiled .class files...
    setlocal enabledelayedexpansion
    set count=0
    for /r com\wastemanagement %%f in (*.class) do (
        set /a count+=1
        echo   - %%f
    )
    echo.
    echo Total .class files created: !count!
    echo.
    echo *** COMPILATION SUCCESSFUL ***
) else (
    echo *** COMPILATION FAILED with exit code %ERRORLEVEL% ***
)
pause
