@echo off
set Launcher_ver=0.0.3
title Launcher %Launcher_ver%

SET BAT_XD_INDIR=%~dp0
SET BAT_XD_INDIR=%BAT_XD_INDIR%
SET BAT_XD_INDIR=%BAT_XD_INDIR:!= %
SET BAT_XD_INDIR=%BAT_XD_INDIR:"= %
SET BAT_XD_INDIR=%BAT_XD_INDIR:(= %
SET BAT_XD_INDIR=%BAT_XD_INDIR:)= %
CALL :puth_cut %BAT_XD_INDIR%

IF defined puth_cut_2 echo 请不要把我放在带有空格/括号/感叹号的路径下面！& pause  & exit /b 1001

IF exist "%windir%\system32\winecfg.exe" echo.无法兼容于WINE环境！& pause  & exit /b 1002

cd "%~dp0bin"
pid /start solo BAT-xd.bat
exit /b

:puth_cut
	set puth_cut_1=%1
	set puth_cut_2=%2
exit /b
