@ECHO *****************************************************
@ECHO * https://www.cnblogs.com/linyfeng/p/8072002.html   *
@ECHO * Learn bat script from Beng Dou's blog, thank you. *
@ECHO *****************************************************

@set command=%1
@if not defined command (goto exit)
@if %command%==-e (goto proc)

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

:exit
@ECHO Good Bye!

