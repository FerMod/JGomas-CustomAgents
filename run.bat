@echo off
cls

rem set AGENTS=task5
rem set AGENTS=tasks
rem set AGENTS=default
set AGENTS=homework4

set AGENTS_PATH=.\agents\%AGENTS%

@cd /D %~dp0
@cd .\bin\mas

start /B %AGENTS_PATH%\jgomas_manager.bat %AGENTS_PATH%
timeout 5 > nul
start /B %AGENTS_PATH%\jgomas_launcher.bat %AGENTS_PATH%

cd ..\render\w32\
timeout 5 > nul
start /B run_jgomasrender.bat
