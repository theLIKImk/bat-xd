@echo off
CHCP 65001
setlocal EnableDelayedExpansion
set PATH=%PATH%;%~dp0
set BAT_XD_VER=0.1.0
set BAT_XD_NOW_READ=0
set BAT_XD_READ_LINE=30
set BAT_XD_READ_PAGE_LINE=3
set nmd_VER=!BAT_XD_VER!
set nmd_title=[WWW.NMBXD.COM][V!BAT_XD_VER!]
set nmd_page_forumlist=
set nmd_page_showf=
set nmd_page_thread=
call pid

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:notice

	call nmbxd.bat notice
	cls
	title !nmd_title! 公告  
	more "!PIDMD_ROOT!TMP\nmb-notice.txt"
	pause >nul

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:getForumList

	cls
	title !nmd_title! 版面列表
	set BAT_XD_NOW_READ=0
	call :loading_text

	del /f /s /q "!PIDMD_ROOT!TMP\platelist.txt" >nul

	call pid /start solo nmbxd.bat getForumList

:getForumList-show
	if not exist "!PIDMD_ROOT!TMP\platelist.txt" goto :getForumList-show
	cls
	call read !PIDMD_ROOT!TMP\platelist.txt -tf !BAT_XD_READ_LINE! !BAT_XD_NOW_READ!

:cf_id_act
	set /p user_input=[ #^<Num:ID^> ^| ref ^| pu ^| pd ]:
	if /i "!user_input:~0,1!"=="#" set showf_id=!user_input:~1!& goto :showf
	if /i "!user_input!"=="ref" goto :getForumList
	if /i "!user_input!"=="pu" set /a BAT_XD_NOW_READ=!BAT_XD_NOW_READ! - !BAT_XD_READ_PAGE_LINE! & GOTO :getForumList-show
	if /i "!user_input!"=="pd" set /a BAT_XD_NOW_READ=!BAT_XD_NOW_READ! + !BAT_XD_READ_PAGE_LINE! & GOTO :getForumList-show
	goto :cf_id_act

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:showf
	
	cls
	set user_input=
	set BAT_XD_NOW_READ=0
	if not defined nmd_page_showf set nmd_page_showf=1
	set BAT_XD_SHOWF_FILE=showf_id_!showf_id!_page_!nmd_page_showf!_list.txt
	title !nmd_title! 串串列表        第!nmd_page_showf!页
	call :loading_text
	
	del /f /s /q "!PIDMD_ROOT!TMP\!BAT_XD_SHOWF_FILE!" >nul
	call pid /start solo nmbxd.bat showf !showf_id! !nmd_page_showf!

:showf-show
	REM if not "!errorlevel!"=="0" echo.失败！ & pause & goto :getForumList
	if not exist "!PIDMD_ROOT!TMP\!BAT_XD_SHOWF_FILE!" goto :showf-show
	cls
	call read !PIDMD_ROOT!TMP\!BAT_XD_SHOWF_FILE! -tf !BAT_XD_READ_LINE! !BAT_XD_NOW_READ!

:th_id_act
	set /p user_input=[ #^<Num:ID^> ^| send ^<Num:ID^> ^| ref ^| back ^| pu ^| pd ^| page + ^| page - ^| page ^<Num:page^>]:
	if /i "!user_input:~0,1!"=="#" set th_id=!user_input:~1!& goto :thread
	if /i "!user_input!"=="ref" goto :showf
	if /i "!user_input!"=="back" goto :getForumList
	if /i "!user_input:~0,4!"=="send" (call nmbxd.bat send !user_input:~5! & pause & goto :showf)
	if /i "!user_input:~0,4!"=="page" (
		if /i "!user_input:~5!"=="+" set /a nmd_page_showf+=1 & goto :showf
		if /i "!user_input:~5!"=="-" if not "!nmd_page_showf!"=="1" set /a nmd_page_showf-=1 & goto :showf
		if not "!user_input:~5!" LSS "1" set nmd_page_showf=!user_input:~5! & goto :showf
	)
	if /i "!user_input!"=="pu" set /a BAT_XD_NOW_READ=!BAT_XD_NOW_READ! - !BAT_XD_READ_PAGE_LINE! & GOTO :showf-show
	if /i "!user_input!"=="pd" set /a BAT_XD_NOW_READ=!BAT_XD_NOW_READ! + !BAT_XD_READ_PAGE_LINE! & GOTO :showf-show
	goto :th_id_act
	
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:thread
	set user_input=
	set BAT_XD_NOW_READ=0
	if not defined nmd_page_thread set nmd_page_thread=1
	set BAT_XD_THREAD_FILE=thread_!th_id!_page_!nmd_page_thread!_list.txt

	cls
	title !nmd_title!串 !user_input!        第!nmd_page_thread!页
	call :loading_text
	
	del /f /s /q "!PIDMD_ROOT!TMP\!BAT_XD_THREAD_FILE!" >nul
	call pid /start solo nmbxd.bat thread !th_id! !nmd_page_thread!
	
:thread-show
	if not exist "!PIDMD_ROOT!TMP\!BAT_XD_THREAD_FILE!" goto :thread-show
	cls
	call read !PIDMD_ROOT!TMP\!BAT_XD_THREAD_FILE! -tf !BAT_XD_READ_LINE! !BAT_XD_NOW_READ!


:th_act
	set /p user_input=[send ^<Num:ID^> ^| ref ^| back ^| pu ^| pd ^| page + ^| page - ^| page ^<Num:page^>]:
	if /i "!user_input!"=="ref" goto :thread
	if /i "!user_input!"=="back" goto :showf
	if /i "!user_input:~0,4!"=="send" (call nmbxd.bat send !user_input:~5! & pause & goto :thread)
	if /i "!user_input:~0,4!"=="page" (
		if /i "!user_input:~5!"=="+" set /a nmd_page_thread+=1 & goto :thread
		if /i "!user_input:~5!"=="-" if not "!nmd_page_thread!"=="1" set /a nmd_page_thread-=1 & goto :thread
		if not "!user_input:~5!" LSS "1" set nmd_page_thread=!user_input:~5! & goto :thread
	)
	if /i "!user_input!"=="pu" set /a BAT_XD_NOW_READ=!BAT_XD_NOW_READ! - !BAT_XD_READ_PAGE_LINE! & GOTO :thread-show
	if /i "!user_input!"=="pd" set /a BAT_XD_NOW_READ=!BAT_XD_NOW_READ! + !BAT_XD_READ_PAGE_LINE! & GOTO :thread-show
	goto :th_act
	

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:loading_text
	echo.少女祈祷中......
exit /b

:readtxt
goto :eof

	