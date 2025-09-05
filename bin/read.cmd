@echo off
setlocal enabledelayedexpansion

if /i "%1"=="/help" (
	set hpfn=%temp%\RD-HP-%random%.txt
	echo READ HELP>!hpfn!
	echo ____________________________________________>>!hpfn!
	echo..>>!hpfn!
	echo Cmd :>>!hpfn!
	echo         CALL READ.CMD [FILE_PATH]>>!hpfn!
	echo..>>!hpfn!
	echo..>>!hpfn!
	echo KEY:>>!hpfn!
	echo.     [/^|\]        [ ^| ]>>!hpfn!
	echo.     [ ^| ]  UP    [\^|/]   DOWN>>!hpfn!
	echo..>>!hpfn!
	echo.     Roller>>!hpfn!
	echo.       V>>!hpfn!
	echo.    _______     [PAGE]>>!hpfn!
	echo.   ^|   ^|   ^|    [UP  ]  >>!hpfn!
	echo.   ^|__[=]__^|>>!hpfn!
	echo.   ^|       ^|    [PAGE] >>!hpfn!
	echo.   ^|_______^|    [DOWN]   [Q] exit >>!hpfn!
	CALL READ.CMD !hpfn!
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
	if not exist "%tfile%" (echo [91m ^<"%tfile%" FILE NOT FOUND^> [0m ) else (
		if not %1 lss 0 (
			if "%1"=="0" (
				for /f "delims=*" %%i in (%tfile%) do (
					if not "%%i"=="" (echo %%i & goto :eof)
					echo.
					goto :eof
				)
			) else (
				for /f "skip=%1 delims=*" %%i in (%tfile%) do (
					set /a linenum=%1+1
					if not "%%i"=="" (echo %%i & goto :eof)
					echo.
					goto :eof
				)
			)
		) 
		set /a linenum=%1+1
		echo.
	)
goto :eof
