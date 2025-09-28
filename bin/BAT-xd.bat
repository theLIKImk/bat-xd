@echo off
CHCP 65001
setlocal EnableDelayedExpansion
set PATH=%PATH%;%~dp0

if not exist "!PIDMD_ROOT!config.ini" call :config
echo.载入设定......
call loadcfg %PIDMD_ROOT%config.INI
if /i not "%BAT_XD_COOKIE%"=="#Login" call nmbxd cookie !BAT_XD_COOKIE!
call pid

set BAT_XD_OUTTIME=6000
set BAT_XD_WAIT=0
set BAT_XD_VER=0.1.8
set BAT_XD_NOW_READ=0

if not defined BAT_XD_TMPDIR (
	set BAT_XD_TMP=!PIDMD_ROOT!TMP\
	set NA_TMP=!PIDMD_ROOT!TMP\
) else (
	set BAT_XD_TMP=!BAT_XD_TMPDIR!
	set NA_TMP=!BAT_XD_TMPDIR!
)

set /p BAT_XD_THIS_PID=<"!PIDMD_ROOT!SYS\PRID\!PIDMD_PRID!"
set PIDMD_RELY_ON=!BAT_XD_THIS_PID!
if not defined PIDMD_PRID set PIDMD_PRID= / - / - / - / & set BAT_XD_THIS_PID= / 
if defined BAT_XD_NA_PROXY (
	set NA_PROXY=%BAT_XD_NA_PROXY%
	set /a BAT_XD_OUTTIME=%BAT_XD_OUTTIME% * 2
)

set nmd_VER=!BAT_XD_VER!
set nmd_title=[!PIDMD_PRID!] [!BAT_XD_THIS_PID!] [WWW.NMBXD.COM] [V!BAT_XD_VER!]
set nmd_page_forumlist=
set nmd_page_showf=
set nmd_page_thread=
del /f /s /q "%BAT_XD_TMP%na_task\*" >nul 2 >nul

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::




::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:notice

	call nmbxd.bat notice
	cls
	title !nmd_title! 公告  
	call !BAT_XD_USE_READ! %BAT_XD_TMP%nmb-notice.txt -tf 18 0
	pause >nul

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:getForumList

	cls
	title !nmd_title! 版面列表
	set BAT_XD_NOW_READ=0
	call :loading_text
	
	if exist "%BAT_XD_TMP%NA_TASK\task_get_gf" goto getForumList-show
	del /f /s /q "%BAT_XD_TMP%platelist.txt" >nul

	call pid /start solo hiderun.cmd nmbxd.bat getForumList

:getForumList-show
	if not exist "%BAT_XD_TMP%platelist.txt" goto :getForumList-show
	cls
	call !BAT_XD_USE_READ! %BAT_XD_TMP%platelist.txt -tf !BAT_XD_READ_LINE! !BAT_XD_NOW_READ!

:cf_id_act
	set /p user_input=[ #^<Num:ID^> ^| ref ^| pu ^| pd ^| help ^| config ^| license ^| login ]:
	if /i "!user_input:~0,1!"=="#" set showf_id=!user_input:~1!& goto :showf
	if /i "!user_input!"=="ref" goto :getForumList
	if /i "!user_input!"=="pu" set /a BAT_XD_NOW_READ=!BAT_XD_NOW_READ! - !BAT_XD_READ_PAGE_LINE! & GOTO :getForumList-show
	if /i "!user_input!"=="pd" set /a BAT_XD_NOW_READ=!BAT_XD_NOW_READ! + !BAT_XD_READ_PAGE_LINE! & GOTO :getForumList-show
	if /i "!user_input!"=="help" cls & chcp 936 & call BAT-XD_help.bat & chcp 65001 & GOTO :getForumList-show
	if /i "!user_input!"=="license" call licenses.bat & cd /d "%PIDMD_ROOT%" & GOTO :getForumList-show
	if /i "!user_input!"=="config" start "" "!PIDMD_ROOT!config.ini" & GOTO :getForumList-show
	if /i "!user_input!"=="login" del /f /s /q cookies.txt >nul & cls & call nmbxd-login & GOTO :getForumList-show
	goto :cf_id_act

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:showf-getNAME
	call loadcfg "%BAT_XD_TMP%platein.ini"
	set plate_id=!%1!
	set /A BAT_XD_WAIT=0
	call loadcfg "%BAT_XD_TMP%plate_!plate_id!_!showf_id!_msg.ini"
exit /b

:showf
	
	cls
	set user_input=
	set BAT_XD_NOW_READ=0
	if not defined nmd_page_showf set nmd_page_showf=1
	set BAT_XD_SHOWF_FILE=showf_id_!showf_id!_page_!nmd_page_showf!_list.txt
	
	call :showf-getNAME !showf_id!
	set show_id_name=!NAME!
	
	title !nmd_title!  !NAME!板块     第!nmd_page_showf!页
	call :loading_text
	
	if exist "%BAT_XD_TMP%NA_TASK\task_get_sf_!showf_id!_page_!nmd_page_showf!" goto showf-show
	del /f /s /q "%BAT_XD_TMP%!BAT_XD_SHOWF_FILE!" >nul
	call pid /start solo hiderun.cmd nmbxd.bat showf !showf_id! !nmd_page_showf!

:showf-show
	set /a BAT_XD_WAIT+=1
	if "%BAT_XD_WAIT%"=="%BAT_XD_OUTTIME%" echo.失败,请检测是否输入正确ID！ & pause & goto :getForumList
	if not exist "%BAT_XD_TMP%!BAT_XD_SHOWF_FILE!" goto :showf-show
	cls
	call !BAT_XD_USE_READ! %BAT_XD_TMP%!BAT_XD_SHOWF_FILE! -tf !BAT_XD_READ_LINE! !BAT_XD_NOW_READ!

:th_id_act
	set /p user_input=[ #^<Num:ID^> ^| send ^<Num:ID^> ^| send-m ^<Num:ID^> ^|  ref ^| back ^| pu ^| pd ^| page + ^| page - ^| page ^<Num:page^> ^| openweb ^| openimg ^<Num:ID^> ]:
	if /i "!user_input:~0,1!"=="#" set th_id=!user_input:~1!& goto :thread
	if /i "!user_input!"=="ref" goto :showf
	if /i "!user_input!"=="back" goto :getForumList
	if /i "!user_input:~0,6!"=="send-m" (call nmbxd.bat send-m !user_input:~7! & pause & goto :showf)
	if /i "!user_input:~0,4!"=="send" (call nmbxd.bat send !user_input:~5! & pause & goto :showf)
	if /i "!user_input:~0,4!"=="page" (
		if /i "!user_input:~5!"=="+" set /a nmd_page_showf+=1 & goto :showf
		if /i "!user_input:~5!"=="-" if not "!nmd_page_showf!"=="1" set /a nmd_page_showf-=1 & goto :showf
		if not "!user_input:~5!" LSS "1" set nmd_page_showf=!user_input:~5!& goto :showf
	)
	if /i "!user_input!"=="pu" set /a BAT_XD_NOW_READ=!BAT_XD_NOW_READ! - !BAT_XD_READ_PAGE_LINE! & GOTO :showf-show
	if /i "!user_input!"=="pd" set /a BAT_XD_NOW_READ=!BAT_XD_NOW_READ! + !BAT_XD_READ_PAGE_LINE! & GOTO :showf-show
	if /i "!user_input!"=="openweb" start https://www.nmbxd1.com/f/!show_id_name!?page=!nmd_page_showf! & GOTO :showf-show
	if /i "!user_input:~0,7!"=="openimg" start "" cmd /c nmbxd.bat openimg !user_input:~8! & GOTO :showf-show
	goto :th_id_act
	
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:thread
	set user_input=
	set /A BAT_XD_WAIT=0
	set BAT_XD_NOW_READ=0
	if not defined nmd_page_thread set nmd_page_thread=1
	set BAT_XD_THREAD_FILE=thread_!th_id!_page_!nmd_page_thread!_list.txt

	cls
	title !nmd_title!  NO.!th_id!    第!nmd_page_thread!页
	call :loading_text
	
	if exist "%BAT_XD_TMP%NA_TASK\task_get_thrd_!th_id!_page_!nmd_page_thread!" goto thread-show
	del /f /s /q "%BAT_XD_TMP%!BAT_XD_THREAD_FILE!" >nul
	call pid /start solo hiderun.cmd nmbxd.bat thread !th_id! !nmd_page_thread!
	
:thread-show
	set /a BAT_XD_WAIT+=1
	if "%BAT_XD_WAIT%"=="%BAT_XD_OUTTIME%" echo.失败,请检测是否输入正确ID！ & pause & goto :showf
	if not exist "%BAT_XD_TMP%!BAT_XD_THREAD_FILE!" goto :thread-show
	cls
	call !BAT_XD_USE_READ! %BAT_XD_TMP%!BAT_XD_THREAD_FILE! -tf !BAT_XD_READ_LINE! !BAT_XD_NOW_READ!


:th_act
	set /p user_input=[send ^<Num:ID^> ^| send-m ^<Num:ID^> ^| ref ^| back ^| pu ^| pd ^| page + ^| page - ^| page ^<Num:page^> ^| openweb ^| openimg ^<Num:ID^> ]:
	if /i "!user_input!"=="ref" goto :thread
	if /i "!user_input!"=="back" goto :showf
	if /i "!user_input:~0,6!"=="send-m" (call nmbxd.bat send-m !user_input:~7! & pause & goto :thread)
	if /i "!user_input:~0,4!"=="send" (call nmbxd.bat send !user_input:~5! & pause & goto :thread)
	if /i "!user_input:~0,4!"=="page" (
		if /i "!user_input:~5!"=="+" set /a nmd_page_thread+=1 & goto :thread
		if /i "!user_input:~5!"=="-" if not "!nmd_page_thread!"=="1" set /a nmd_page_thread-=1 & goto :thread
		if not "!user_input:~5!" LSS "1" set nmd_page_thread=!user_input:~5!& goto :thread
	)
	if /i "!user_input!"=="pu" set /a BAT_XD_NOW_READ=!BAT_XD_NOW_READ! - !BAT_XD_READ_PAGE_LINE! & GOTO :thread-show
	if /i "!user_input!"=="pd" set /a BAT_XD_NOW_READ=!BAT_XD_NOW_READ! + !BAT_XD_READ_PAGE_LINE! & GOTO :thread-show
	if /i "!user_input!"=="openweb" start https://www.nmbxd1.com/t/!th_id!?page=!nmd_page_thread! & GOTO :thread-show
	if /i "!user_input:~0,7!"=="openimg" start "" cmd /c nmbxd.bat openimg !user_input:~8! & GOTO :thread-show
	goto :th_act
	

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:loading_text
	CALL RandomString
exit /b

:CONFIG
	echo.Create setting......
	echo.[BAT_XD]>"!PIDMD_ROOT!config.ini"
	echo.USE_READ=read_test>>"!PIDMD_ROOT!config.ini"
	echo.READ_PAGE_LINE=010>>"!PIDMD_ROOT!config.ini"
	echo.READ_LINE=30>>"!PIDMD_ROOT!config.ini"
	echo.TMPDIR=%%PIDMD_ROOT%%\TMP\>>"!PIDMD_ROOT!config.ini"
	echo.>>"!PIDMD_ROOT!config.ini"
	echo.# 代理范例:>>"!PIDMD_ROOT!config.ini"
	echo.#>>"!PIDMD_ROOT!config.ini"
	echo.# http://user:pwd@127.0.0.1:1234>>"!PIDMD_ROOT!config.ini"
	echo.# http://127.0.0.1:1234>>"!PIDMD_ROOT!config.ini"
	echo.NA_PROXY=>>"!PIDMD_ROOT!config.ini"
	echo.>>"!PIDMD_ROOT!config.ini"
	echo.# Cookie导入时请把每一个 %% 重复4遍>>"!PIDMD_ROOT!config.ini"
	echo.# 值为"#Login"只会按照登陆脚本写入的饼干登录>>"!PIDMD_ROOT!config.ini"
	echo.COOKIE=#Login>>"!PIDMD_ROOT!config.ini"
goto :eof

	