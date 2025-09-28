@echo off
chcp 65001
setlocal EnableDelayedExpansion
if not defined NA_TMP set NA_TMP=%TEMP%\
set NA_curl_HEAD=User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)
set curl_proxy=

REM 有登录Cookie下直接跳转
REM if exist login_info_cookie.txt goto login_page

REM 登录和验证

set /p NA_nmb_email=邮箱：
echo>nul
set /p NA_nmb_passwd=密码：
call :curl-get https://www.nmbxd1.com/Member/User/Index/verify.html --output "v.png"
start "" v.png
set /p v_c=验证码:

echo.
echo.正在登录......
echo.
call :curl-post https://www.nmbxd1.com/Member/User/Index/login.html ^
-F "email=\"!NA_nmb_email!\"" ^
-F "password=\"!NA_nmb_passwd!\"" ^
-F "verify=\"%V_C%\"" >nul

REM 获取cookie
:login_page
echo.正在获取饼干信息......
echo.
call :curl-post https://www.nmbxd1.com/Member/User/Cookie/index.html --output "%NA_TMP%cookie_list.html"

REM 饼干名称列表
echo.饼干
echo.______________________
echo.
set NA_cookie_num=0
for /f "delims=*" %%s in ('type ^"%NA_TMP%cookie_list.html^" ^| tidy -q -asxml -numeric 2^>nul ^| xq -x ^"//table/tbody/tr/td[3]/a/text^(^)^"') do (
	set /a NA_cookie_num+=1
	echo [!NA_cookie_num!] %%s
)

if "!NA_cookie_num!"=="0" echo [x] 饼干未检测到，请检测账户是否登录错误！ &goto out_end

REM 饼干应用链接
set NA_cookie_link=0
for /f "delims=*" %%s in ('type ^"%NA_TMP%cookie_list.html^" ^| tidy -q -asxml -numeric 2^>nul ^| xq -x ^"//table/tbody/tr/td[6]/div/div/a[1]/@href^"') do (
	set /a NA_cookie_link+=1
	set NA_cookie_link_!NA_cookie_link!=%%s
)

REM 设置饼干
echo.
:set_cookie
set /p NA_cookie_set_num=选择应用的饼干：
if not defined NA_cookie_link_!NA_cookie_set_num! goto set_cookie

echo.正在设定饼干......
call :curl-get https://www.nmbxd1.com!NA_cookie_link_%NA_cookie_set_num%! >nul

for /f "eol=# tokens=1,6,7 delims=	" %%a in (cookies.txt) do (
	if /i "%%a"=="www.nmbxd1.com" (
		if /i "%%b"=="userhash" (
			echo.www.nmbxd.com	FALSE	/	FALSE	1764252682	userhash	%%c>>cookies.txt
			echo.api.nmb.best	FALSE	/	FALSE	1764252682	userhash	%%c>>cookies.txt
		)
	)
)

echo.完毕！

:out_end
pause
exit /b



:curl-get
	set val=%*
	set val=%val:#S#=^^^&%
	curl -X GET -L --compressed -H "%NA_curl_HEAD%" -b cookies.txt -c cookies.txt --proxy "%NA_proxy%" -s %val%
exit /b



:curl-post
	set val=%*
	set val=%val:#S#=^^^&%
	curl -X POST -L --compressed -H "%NA_curl_HEAD%" -b cookies.txt -c cookies.txt --proxy "%NA_proxy%" -s %val%
exit /b