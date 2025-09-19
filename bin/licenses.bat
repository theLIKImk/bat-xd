@echo off
set LICENSES_DIR=%~dp0licenses\
set ___cd=%cd%

if not exist "%LICENSES_DIR%" echo 未找到许可文件！ & exit /b
cd /d "%LICENSES_DIR%"

:LICENSES_LIST
	title LICENSE LIST
	set LICENSES_PROG=
	cls
	for /r %%f in (.\*) do echo.%%~nxf
	echo.
	
	set /p LICENSES_PROG=[ "/exit" = Exit]:
	if not defined LICENSES_PROG goto LICENSES_LIST
	if exist "%LICENSES_PROG%" goto LICENSES_VIEW
	if /i "%LICENSES_PROG%"=="/exit" exit /b
goto LICENSES_LIST

:LICENSES_VIEW
	cls
	title LICENSE: %LICENSES_PROG%
	more "%LICENSES_PROG%"
	pause >nul
GOTO :LICENSES_LIST