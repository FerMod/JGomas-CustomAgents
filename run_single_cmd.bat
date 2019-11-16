@echo off
cls

@cd /D %~dp0
@cd bin\mas

start /B jgomas_manager.bat
timeout 5 > nul
start /B jgomas_launcher.bat
