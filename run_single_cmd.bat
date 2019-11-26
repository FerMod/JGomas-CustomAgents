@echo off
cls

set AGENTS_PATH="agents\default\"
rem set AGENTS="agents\task"
rem set AGENTS="agents\task5"

@cd /D %~dp0
@cd bin\mas

start /B "%AGENTS_PATH%\jgomas_manager.bat"
timeout 5 > nul
start /B "%AGENTS_PATH%\jgomas_launcher.bat"
