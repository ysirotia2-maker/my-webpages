@echo off
:: Usage: scripts\new_post.cmd "My post title"
:: Creates a new post file in _posts with today's date and a slugified filename.
:: Requires PowerShell for slug and timestamp formatting.
setlocal enabledelayedexpansion
if "%~1"=="" (
  echo Usage: new_post "Post Title"
  exit /b 1
)
set TITLE=%~1
for /f "usebackq" %%D in (`powershell -NoProfile -Command "(Get-Date).ToString('yyyy-MM-dd')"`) do set DATE=%%D
for /f "usebackq" %%S in (`powershell -NoProfile -Command "$t='%TITLE%'; $t = $t.ToLower() -replace '[^a-z0-9\s-]','' -replace '\s+','-'; Write-Output $t"`) do set SLUG=%%S
set FILENAME=%DATE%-%SLUG%.md
set OUTPATH=_posts\%FILENAME%
if exist %OUTPATH% (
  echo Post already exists: %OUTPATH%
  exit /b 1
)
mkdir _posts 2>nul
copy templates\blog-post-template.md %OUTPATH% >nul
powershell -NoProfile -Command "(Get-Content '%OUTPATH%') -replace 'date: 2026-09-11 10:00:00 \+0530', 'date: ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss K') | Set-Content '%OUTPATH%'"
rem Replace title placeholder
call :replace_in_file "%OUTPATH%" "Your post title here" "%TITLE%"
echo Created: %OUTPATH%
exit /b 0

:replace_in_file
set FILE=%~1
set SEARCH=%~2
set REPL=%~3
powershell -NoProfile -Command "(Get-Content '%FILE%') -replace [regex]::Escape('%SEARCH%'), '%REPL%' | Set-Content '%FILE%'"
exit /b 0
