@echo off
setlocal enabledelayedexpansion
set READ_VER=0.1.0

if /i "%1"=="/help" (
	set hpfn=%temp%\RD-HP-%random%.txt
	echo READ V!READ_VER!>!hpfn!
	echo.>>!hpfn!
	echo.CALL READ.CMD ^<Str:File_Path^>>>!hpfn!
	echo.CALL READ.CMD ^<Str:File_Path^> /TF ^<Num:Print_Line^> ^<Num:Start_Line^>>>!hpfn!
	echo.>>!hpfn!
	echo.>>!hpfn!
	echo KEY:>>!hpfn!
	echo.>>!hpfn!
	echo.     ^|/^|\^|        ^| ^| ^|>>!hpfn!
	echo.     ^| ^| ^|  UP    ^|\^|/^|   DOWN>>!hpfn!
	echo.>>!hpfn!
	echo.     Roller      Page>>!hpfn!
	echo.       V>>!hpfn!
	echo.    _______     ^|PAGE^|>>!hpfn!
	echo.   /   ^|   \    ^|UP  ^|     Exit>>!hpfn!
	echo.   \  ^|=^|  />>!hpfn!
	echo.   /\  -  /\    ^|PAGE^|    ^| Q  ^|>>!hpfn!
	echo.   ^|       ^|    ^|DOWN^|    ^|    ^|>>!hpfn!
	echo.   \_______/>>!hpfn!
	CALL "%~nx0" !hpfn!
	exit /b
)


set pag=25
set npag=0
set fp=1
set tfile=%1
set msg=[===READ===]

if /i "%2"=="-tf" (
	set pmsg=false
	set pag=%3
	set npag=%4
	call :flash
	exit /b
)

if /i "%2"=="/tf" (
	set pmsg=false
	set pag=%3
	set npag=%4
	call :flash
	exit /b
)

title [Move mouse OR enter key]
call :flash
:h 
for /f "tokens=1-5" %%1 in ('mk.exe /s 1') do (
	title %tfile%
	
	
	if "%%4"=="7864320" (
		set flash=true
		if not "!npag!"=="0" (
			set /a npag=!npag!-%fp%
		) else (
		set msg=====HEAD====)
	)
	if "%%3"=="38" (
		set flash=true
		if not "!npag!"=="0" (
			set /a npag=!npag!-%fp%
		) else (
		set msg=====HEAD====
		)
	)
		if "%%3"=="33" (
		set flash=true
		if not "!npag!"=="0" (
			set /a npag=!npag!-%pag%
			set msg=====READ====
		) else (
			set msg=====HEAD====
		)
	)
	if "%%4"=="-7864320" (
		set flash=true
		set /a npag=!npag!+%fp%
		set msg=====READ====
	)
	if "%%3"=="40" (
		set flash=true
		set /a npag=!npag!+%fp%
		set msg=====READ====
	)
	if "%%3"=="34" (
		set flash=true
		set /a npag=!npag!+%pag%
		set msg=====READ====
	)
	if "%%3"=="81" CLS &echo ====EXIT==== & exit /b

	

	
	if /i "%flash%"=="true" cls & call :flash & set flash=false
)
	
goto h

:flash
	if "%tfile%"=="" set msg=====EMPTY====
	for /l %%n in (0,1,%pag%) do (
		set /a tpag=!npag!+%%n
		call :rtf !tpag!
		echo>nul
	)

	if /i not "%pmsg%"=="false" echo !msg!
goto :eof

:rtf
	set /a READSKIP=%1+2
	if not exist "%tfile%" (echo [91m ^<"%tfile%" FILE NOT FOUND^> [0m ) else (

		if not !READSKIP! LSS 0 (
			for /f "skip=%READSKIP% tokens=1* delims=[]" %%a in ('find /n /v "" %tfile%') do (
			REM for /f "skip=%READSKIP% tokens=1* delims=:" %%a in ('findstr /n .* %tfile%') do (
				set /a linenum=%1+1
				echo.%%b
				goto :eof
			)
		)
		
		set /a linenum=%1+1
		echo.
	)
goto :eof
