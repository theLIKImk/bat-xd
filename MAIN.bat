@echo off
CHCP 65001
setlocal EnableDelayedExpansion
set PATH=%PATH%;%~dp0
set BAT-XD_VER=0.0.3
set nmd_VER=!BAT_NA_VER!
set nmd_title=[WWW.NMBXD.COM][V!BAT-XD_VER!]
set nmd_page_forumlist=
set nmd_page_showf=
set nmd_page_thread=


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:notice

	call nmbxd.bat notice
	cls
	title !nmd_title! 公告
	more "%NA_TMP%\!showfile!"
	pause >nul

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:getForumList

	cls
	title !nmd_title! 版面列表
	call :loading_text
	call nmbxd.bat getForumList
	cls
	more "%NA_TMP%\!showfile!"

:cf_id_act
	set /p user_input=[ #^<Num:ID^> ^| ref ^| pu ^| pd ]:
	if /i "!user_input:~0,1!"=="#" set showf_id=!user_input:~1! & goto :showf
	if /i "!user_input!"=="ref" goto :getForumList
	goto :cf_id_act

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:showf
	set user_input=
	if not defined nmd_page_showf set nmd_page_showf=1
	cls
	title !nmd_title! 串串列表        第!nmd_page_showf!页
	call :loading_text
	call nmbxd.bat showf !showf_id! !nmd_page_showf!
	if not "!errorlevel!"=="0" echo.失败！ & pause & goto :getForumList
	cls
	
	more "%NA_TMP%\!showfile!"

:th_id_act
	set /p user_input=[ #^<Num:ID^> ^| send ^<Num:ID^> ^| ref ^| back ^| pu ^| pd ^| page + ^| page - ^| page ^<Num:page^>]:
	if /i "!user_input:~0,1!"=="#" set th_id=!user_input:~1! & goto :thread
	if /i "!user_input!"=="ref" goto :showf
	if /i "!user_input!"=="back" goto :getForumList
	if /i "!user_input:~0,4!"=="send" (call nmbxd.bat send !user_input:~5! & pause & goto :showf)
	if /i "!user_input:~0,4!"=="page" (
		if /i "!user_input:~5!"=="+" set /a nmd_page_showf+=1 & goto :showf
		if /i "!user_input:~5!"=="-" if not "!nmd_page_showf!"=="1" set /a nmd_page_showf-=1 & goto :showf
		if not "!user_input:~5!" LSS "1" set nmd_page_showf=!user_input:~5! & goto :showf
	)

	goto :th_id_act
	
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:thread
	set user_input=
	if not defined nmd_page_thread set nmd_page_thread=1
	
	cls
	title !nmd_title!串 !user_input!        第!nmd_page_thread!页
	call :loading_text
	call nmbxd.bat thread !th_id! !nmd_page_thread!
	cls
	
	more "%NA_TMP%\!showfile!"

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
	
	goto :th_act
	

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:loading_text
	echo.少女祈祷中......
exit /b

:readtxt
goto :eof

	
