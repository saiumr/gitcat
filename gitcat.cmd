@echo off
set repodir=.git
set command=%1

if not defined command goto Start
set cmd_firstchar=%command:~0,1%
set cmd_secondchar=%command:~1,1%

if "%cmd_firstchar%"=="-" (
  if not defined cmd_secondchar goto CatDizzy
  if "%cmd_secondchar%"=="-" (goto CatCommand) else (goto CatShortCommand)
) else (
  goto CatDizzy
)

:CatCommand
set whole_cmd=%command:~2%
if not defined whole_cmd   goto CatDizzy
if "%whole_cmd%"=="update" goto CatUpdate
if "%whole_cmd%"=="check"  goto CatCheck
if "%whole_cmd%"=="log"    goto CatEatLog
if "%whole_cmd%"=="switch" goto CatSwitch
if "%whole_cmd%"=="restore" goto CatRestore
if "%whole_cmd%"=="help"   goto Help
goto CatDizzy

:CatShortCommand
set short_cmd=%command:~1%
if not defined short_cmd goto CatDizzy
if "%short_cmd%"=="u"    goto CatUpdate
if "%short_cmd%"=="c"    goto CatCheck
if "%short_cmd%"=="l"    goto CatEatLog
if "%short_cmd%"=="s"    goto CatSwitch
if "%short_cmd%"=="r"    goto CatRestore
if "%short_cmd%"=="h"    goto Help
goto CatDizzy

:CatEatLog
chcp 65001
echo.

set lastversion_file=version.txt
set newversion_file=version_new.txt
set chlist_file=ChangeListDraft.txt
if exist %newversion_file% type nul>%newversion_file%
if exist %chlist_file% type nul>%chlist_file%
echo Change List:>>%chlist_file%

if exist %lastversion_file% (
  echo Generate %newversion_file%:[repo_name -^> current branch]
  echo ^|
  for /f "delims=" %%a in ('type "%lastversion_file%"') do (
    for /f "tokens=1,2,3 delims= " %%i in ("%%a") do (
      rem echo i = %%i
      rem echo j = %%j
      rem echo k = %%k

      if exist %%i (
        cd %%i
        for /f "delims=" %%b in ('git branch --show-current') do (
          if "%%b"=="%%j" (
            for /f "delims=" %%c in ('git log -1 --format^="%%H"') do (
              echo %%i %%b %%c>>..\%newversion_file%
              
              echo #%%i#>>..\%chlist_file%
              for /f "delims=" %%d in ('git log --oneline %%k..HEAD --format^="%%s"') do (
                echo %%d>>..\%chlist_file%
              )
              echo.>>..\%chlist_file%
              
            )
            echo ^|-[✓] %%i -^> %%b
          ) else (
            cd ..
            echo **************************************************************
            echo ^|-[✗] %%i -^> %%b, the main branch is %%j, checkout please
            echo **************************************************************

            if exist %newversion_file% del %newversion_file%
            if exist %chlist_file% del %chlist_file%
            echo.
            echo [!] Failed to generate %newversion_file% and %chlist_file%, use `.\gitcat -c` to check status

            goto Exit
          )
        )
        cd ..
      )
    )
  )
  echo.
  echo [!] Successfully generated %newversion_file% and %chlist_file%

) else (
  echo [!] Need `version.txt`
  echo If version.txt is available here, you can directly use '.\gitcat -l ' generates "version_new.txt"
  echo.
  echo The content of version.txt includes one or more line like:
  echo [repository name] [main branch name] [last recorded commit hash]
  echo.
  echo e.g. version.txt content is:
  echo 3Dmath master 9874sdf166517bh5h32...^(it should be complete^)
  echo openssl master 8923khskjf...
  echo ...
  echo 3Dmath and openssl are git repositories in the path: "%CD%"
)
goto Exit

:CatCheck
echo GitCat found these git repos: Repo ^-^> Current branch [!status tag]
echo ^|
for /d %%i in (*) do (
  cd %%i
  if exist %repodir% (
    set /p="|- %%i -> "<nul
    
    for /f "delims=" %%b in ('git branch --show-current') do (
      echo %%b | find "master" >nul
      if not errorlevel 1 (
        set /p="%%b "<nul
      ) else (
        set /p="%%b [!Not master] "<nul
      )
    )
    
    for /f "delims=" %%c in ('git status') do (
      echo %%c | find "Changes not staged for commit" >nul
      if not errorlevel 1 (
        set /p=" [!Changes] " <nul
      )
      echo %%c | find "Untracked files" >nul
      if not errorlevel 1 (
        set /p=" [!Untracked] " <nul
      )
    )

    echo.
  )
  cd ..
)
goto Exit

:CatUpdate
echo GitCat will update all git repos:
for /d %%i in (*) do (
  cd %%i
  if exist %repodir% (
    echo ******** [Update %%i] **************************************
    call git pull
    echo ******** [Updte %%i End] ***********************************

    echo.
  )
  cd ..
)
echo ******** !!!WATCH OUT!!! ***************************************
echo Check updates please. Maybe you need to `stash` your modification or `switch` to specified branch. Use `.\gitcat -c` to checkout status.
echo.
goto Exit

:CatSwitch
set branch=%2
if not defined branch (
  echo GitCat found following branches of your git repos:
  echo ^|
  for /d %%i in (*) do (
    cd %%i
    if exist %repodir% (
      echo ^|^-%%i
      for /f "delims=" %%b in ('git branch') do (
        echo ^| +- %%b
      )
    )
    cd ..
  )
  echo.
  echo Specify a branch to switch, like '.\gitcat.cmd -s dev'.
  echo.
) else (
  echo GitCat switches your local git repos branch:
  echo ^|
  for /d %%i in (*) do (
    cd %%i
    if exist %repodir% (
      set /p="|-%%i: "<nul
      for /f "delims=" %%c in ('git branch --show-current') do (
        call git switch %branch% 2>&1 | findstr "fatal" >nul
        if not errorlevel 1 (
          echo Fatal
          echo ^| +- ^( No specified branch "%branch%", current branch is "%%c" ^)
        ) else (
          echo Succecced
          echo ^| +- [%%c]-^>[%branch%]
        )
      )
    )
    cd ..
  )
  echo.
  echo Switch done. Execute '.\gitcat.cmd -c' check the result.
  echo.
)
goto Exit

:CatRestoreAll
set /p choice=Do you want to continue? ( y/n, 'y' continue and default 'n' ): || set "choice=n"
if /I "%choice%"=="y" (
  echo ^|
  for /d %%i in (*) do (
    cd %%i
    if exist %repodir% (
      echo ^|^-%%i
      call git checkout -- *
    )
    cd ..
  )
  echo.
  echo Restore done. Execute '.\gitcat.cmd -c' check your git repos status.
  echo.
) else (
  if /I "%choice%"=="n" (
    echo Do nothing.
  ) else (
    goto CatRestoreAll
  )
)
goto Exit

:CatRestoreSome
set /p=^|^- <nul
set args=%*
for %%i in (%args:~3%) do (
  set /p=%%i <nul
)
echo.
:CatRestoreSomeAgain
set /p choice=Do you want to continue? ( y/n, 'y' continue and default 'n' ): || set "choice=n"
if /I "%choice%"=="y" (
  echo ^|
  for %%i in (%args:~3%) do (
    >nul 2>&1 cd %%i
    if not errorlevel 1 (
      if exist %repodir% (
        echo ^|^-%%i
        call git checkout -- *
      ) else (
        echo ^|^-^("%%i" is not git repo^)
      )
      cd ..
    ) else (
      echo ^|^-^(No directory "%%i"^)
    )
  )
  echo.
  echo Restore done. Execute '.\gitcat.cmd -c' check your git repos status.
  echo.
) else (
  if /I "%choice%"=="n" (
    echo Do nothing.
  ) else (
    goto CatRestoreSomeAgain
  )
)
goto Exit

:CatRestore
set arg2=%2
if not defined arg2 (
  echo GitCat will restore your modifications in all of the repos:
  goto CatRestoreAll
) else (
  echo GitCat will restore your modifications in repos:
  goto CatRestoreSome
)
goto Exit

:CatDizzy
echo Do not find any command as '%command%'
echo Use '.\gitcat -h/--help' look out usage.
goto Exit

:Help
echo Usage: .\gitcat [option]
echo Gitcat helps you manage git repositories easily.
echo Check repositories status and extract git log to files.
echo.
echo short options / long options:
echo   -c, --check     check all git repositories, check their status.
echo                   the [!status tag] are [!Not master], [!Changes] and [!Untracked].
echo                   [!Not master] means current branch may be not main branch.
echo                   [!Changes] means there is(are) file(s) modified or deleted.
echo                   [!Untracked] means there is(are) file(s) untracked.
echo   -h, --help      display this help and exit.
echo   -l, --log       need file of name is `version.txt`, generate `version_new.txt` and `ChangeListDraft.txt`
echo   -u, --update    update all git repositories.
echo   -r [dir1] [dir2]..., --restore [dir1] [dir2]...
echo                   1. restore modifications in [dir1] [dir2]...
echo                   2. if it is not specified any [dir], restore modification in all of the git repos.
echo   -s [branch], --switch [branch]
echo                   1. switch the current branch of all repositories to [branch].
echo                   2. if there is no [branch] then gitcat checks all local branches of every repository.
goto Exit

:Start
echo          Copyright (C) 2023 saiumr
echo  /\_/\   
echo ( o.o )  This program is free software: you can redistribute it
echo  ^> ^^ ^<   and/or modify it under the terms of the GNU General
echo          Public License as published by the Free Software Foundation,
echo either version 3 of the License, or (at your option) any later version.
echo.
echo Use '.\gitcat' or '.\gitcat -h/--help' look out usage.
echo And do you want to feed gitcat? See: https://github.com/saiumr/gitcat/tree/master
echo.
goto Help

:Exit
echo on

