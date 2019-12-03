@echo off
setlocal EnableDelayedExpansion
cls
pushd %~dp0

:::::::
:: Agents folders where their configurations should be
REM set agent_config=task5
REM set agent_config=tasks
REM set agent_config=default
REM set agent_config=homework4
set agent_config=test


echo.
echo Runing agent config '%agent_config%'.
echo.
:::::::

pushd .\bin\mas
set agents_path=.\agents\%agent_config%

:: Load the agents parameters from the config file
set num_agents=0
set agents=
for /f "delims== tokens=1,2" %%x in (%agents_path%\launcher.cfg) do (
    set "agents=!agents!%%x:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%agents_path%\%%y);"
    set /a num_agents=num_agents+1
)

:: Load the manager parameters from the config file
set "params=%num_agents%,"
for /f "delims== tokens=2" %%x in (%agents_path%\manager.cfg) do (
    set "params=!params!%%x,"
)
:: Remove the last char. In this case the comma added in the for loop
set params=%params:~0,-1%


:: Run the jgomas manager
start /b java -classpath "lib\jade.jar;lib\jadeTools.jar;lib\Base64.jar;lib\http.jar;lib\iiop.jar;lib\beangenerator.jar;lib\jgomas.jar;lib\jason.jar;lib\JasonJGomas.jar;classes;." jade.Boot -gui "Manager:es.upv.dsic.gti_ia.jgomas.CManager(%params%)"
:: Wait some seconds, to let the manager to finish the initial setup
timeout 5 > nul
:: Run the jgomas launcher
start /b java -classpath "lib\jade.jar;lib\jadeTools.jar;lib\Base64.jar;lib\http.jar;lib\iiop.jar;lib\beangenerator.jar;lib\jgomas.jar;lib\jason.jar;lib\JasonJGomas.jar;classes;." jade.Boot -container -host localhost "%agents%"

popd

pushd .\bin\render\w32\
timeout 5 > nul
:: Run the jgomas renderer
start /b run_jgomasrender.bat
popd

popd
