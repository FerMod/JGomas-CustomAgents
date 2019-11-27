@echo off 

set NUM_AGENTS=4
set MAP=map_01
set REFRESH_RATE=125
set MATCH_TIME=5 

java -classpath "lib\jade.jar;lib\jadeTools.jar;lib\Base64.jar;lib\http.jar;lib\iiop.jar;lib\beangenerator.jar;lib\jgomas.jar;lib\jason.jar;lib\JasonJGomas.jar;classes;." jade.Boot -gui "Manager:es.upv.dsic.gti_ia.jgomas.CManager(%NUM_AGENTS%, %MAP%, %REFRESH_RATE%, %MATCH_TIME%)"
