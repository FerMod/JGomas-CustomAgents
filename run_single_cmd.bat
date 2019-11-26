@echo off
cls

set AGENTS=default
rem set AGENTS=task
rem set AGENTS=task5

@cd /D %~dp0
@cd bin\mas

start /B agents\%AGENTS%\jgomas_manager.bat agents\%AGENTS%
timeout 5 > nul
start /B agents\%AGENTS%\jgomas_launcher.bat agents\%AGENTS%

cd ..\render\w32\
timeout 5 > nul
start /B run_jgomasrender.bat
