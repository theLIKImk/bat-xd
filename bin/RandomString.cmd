@echo off
set RandomString_VER=0.0.1
set RandomString_FILE=rs.txt
set /a RandomString_MIN=0

if not exist "%RandomString_FILE%" echo.请输入文本>"%RandomString_FILE%"

REM 获取文件最大行
for /F "delims=:" %%a in ('findstr /n . "%RandomString_FILE%"') do set RandomString_MAX=%%a
set /a RandomString_MAX=%RandomString_MAX% - 1

REM 设定随机数范围
set /a RandomString_RD=( %RANDOM% %% ( %RandomString_MAX% - %RandomString_MIN% + 1 ) ) + %RandomString_MIN%


REM 读取行输出
if "%RandomString_RD%"=="0" (
	for /F "delims=" %%t in (%RandomString_FILE%) do (
		echo %%t
		goto :out-read
	)
) else (
	for /F "skip=%RandomString_RD% delims=" %%t in (%RandomString_FILE%) do (
		echo %%t
		goto :out-read
	)
)

:out-read
setlocal DisableDelayedExpansion
exit /b