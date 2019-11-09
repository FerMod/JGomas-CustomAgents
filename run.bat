@echo off

cd /D %~dp0
cd bin\mas

start /B jgomas_manager.bat
timeout 5 > nul
start jgomas_launcher.bat
