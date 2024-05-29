@ECHO *****************************************************
@ECHO * https://www.cnblogs.com/linyfeng/p/8072002.html   *
@ECHO * Learn bat script from Beng Dou's blog, thank you. *
@ECHO *****************************************************

@set arg1=%1
@set arg2=%2
@set arg3=%3
@if not defined arg2 (
  echo "no arg2"
) else (
  echo "arg2 is %arg2%"
)
@if not defined arg3 (
  echo "no arg3"
) else (
  echo "arg2 is %arg3%"
)
@if not defined arg1 (goto exit)
@if "%arg1%"=="-e" (goto proc) else if "%arg1%"=="-c" (goto proc2) else (goto exit)

:proc
@ECHO %DATE%-%TIME% at:
@ECHO %CD% print random number %RANDOM%
@ECHO errorlevel: %ERRORLEVEL%

@ECHO.
@SET  hello="Hello BAT!"
@ECHO set variable and print: %hello% (Watch Out! No Space at [here]=[here]!)

@ECHO.
@REM echo %var:~n,k%  strip string(%var%) as %var%[n,k)
@ECHO OFF
set  str=superhero
echo str = %str%, stripping it.
echo str:~0,5 = %str:~0,5%
echo str:~3 = %str:~3%
echo str:~-3 = %str:~-3%
echo str:~0,-3 = %str:~0,-3%
PAUSE

@ECHO.
@REM %var:old_str=new_str%  replace part of %var% old_str by new_str
set str2=hello world!
echo str2 = %str2%, replacing it.
set temp=%str2:hello=good%
echo %temp%
PAUSE
@ECHO ON

@REM echo content > file.txt -> override write
@REM echo content >> file.txt -> add content
@REM IF, FOR refer to link.

:proc2
@echo off
set /p choice=Do you want to continue?(Y/n default N): || set "choice=N"
@REM if "%choice%"=="Y" goto continue
@REM if "%choice%"=="y" goto continue
@REM if "%choice%"=="N" goto cancel
@REM if "%choice%"=="n" goto cancel
if /I "%choice%"=="Y" goto continue
if /I "%choice%"=="N" goto cancel

:continue
echo Continuing with the operation...
@REM 执行继续操作的代码
pause
goto exit

:cancel
echo Operation canceled.
pause
goto exit
@echo on

:exit
@ECHO Good Bye!

