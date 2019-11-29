@echo off

setlocal EnableDelayedExpansion
set current_path=%cd%
set agent_path=%~dp0.
set rel_path=!agent_path:*%current_path%\=!

set agents=
for /f "delims== tokens=1,2" %%x in (%rel_path%\launcher.cfg) do (
    set "agents=!agents!%%x:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%rel_path%\%%y);"
)

java -classpath "lib\jade.jar;lib\jadeTools.jar;lib\Base64.jar;lib\http.jar;lib\iiop.jar;lib\beangenerator.jar;lib\jgomas.jar;lib\jason.jar;lib\JasonJGomas.jar;classes;." jade.Boot -container -host localhost "%agents%"
