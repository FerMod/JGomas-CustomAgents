
set MAS_PATH="..\..\"

set NUM_AGENTS=14
set MAP="map_04"
set REFRESH_RATE=125
set MATCH_TIME=10 

java -classpath "%MAS_PATH%lib\jade.jar;%MAS_PATH%lib\jadeTools.jar;%MAS_PATH%lib\Base64.jar;%MAS_PATH%lib\http.jar;%MAS_PATH%lib\iiop.jar;%MAS_PATH%lib\beangenerator.jar;%MAS_PATH%lib\jgomas.jar;%MAS_PATH%lib\jason.jar;%MAS_PATH%lib\JasonJGomas.jar;%MAS_PATH%classes;%MAS_PATH%." jade.Boot -gui "Manager:es.upv.dsic.gti_ia.jgomas.CManager(%NUM_AGENTS%, %MAP%, %REFRESH_RATE%, %MATCH_TIME%)"
