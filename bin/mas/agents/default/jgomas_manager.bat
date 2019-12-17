@echo off

setlocal EnableDelayedExpansion
set current_path=%cd%
set agent_path=%~dp0.
set rel_path=!agent_path:*%current_path%\=!

set params=
for /f "delims== tokens=2" %%x in (%rel_path%\manager.cfg) do (
    set "params=!params!%%x,"
)
set params=%params:~0,-1%

java -classpath "lib\jade.jar;lib\jadeTools.jar;lib\Base64.jar;lib\http.jar;lib\iiop.jar;lib\beangenerator.jar;lib\jgomas.jar;lib\jason.jar;lib\JasonJGomas.jar;classes;." jade.Boot -gui "Manager:es.upv.dsic.gti_ia.jgomas.CManager(%params%)"
