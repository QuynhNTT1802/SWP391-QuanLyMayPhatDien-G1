@echo off
REM Build script: compile Java sources into the exploded WAR that Tomcat runs.
REM Usage: run this after editing any .java file, then refresh browser (no restart needed).

setlocal

set PROJECT_ROOT=%~dp0
set CLASSES_DIR=%PROJECT_ROOT%target\Test\WEB-INF\classes
set LIB_DIR=%PROJECT_ROOT%target\Test\WEB-INF\lib
set SRC_DIR=%PROJECT_ROOT%src\main\java

if not exist "%CLASSES_DIR%" (
    echo [ERROR] %CLASSES_DIR% not found. Build the project first.
    exit /b 1
)

REM Build classpath from all jars in WEB-INF\lib
set CP=
for %%f in ("%LIB_DIR%\*.jar") do (
    set CP=!CP!;%%f
)
set CP=%CLASSES_DIR%;%CP:~1%

echo [INFO] Compiling Java sources from %SRC_DIR%...
dir /S /B "%SRC_DIR%\*.java" > "%TEMP%\java_sources.txt"
javac -encoding UTF-8 -cp "%CP%" -d "%CLASSES_DIR%" @"%TEMP%\java_sources.txt"
if errorlevel 1 (
    echo [ERROR] Compilation failed.
    exit /b 1
)

echo [INFO] Triggering Tomcat context reload by touching web.xml...
powershell -NoProfile -Command "(Get-Item '%CLASSES_DIR%\..\web.xml').LastWriteTime = Get-Date"

echo [OK] Build complete. Refresh your browser (Ctrl+F5).
endlocal
