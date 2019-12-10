@echo off
setlocal EnableDelayedExpansion
cls
pushd %~dp0

:::::::
:: Agents folders where their configurations should be
REM set agent_config=task5
REM set agent_config=tasks
REM set agent_config=default
set agent_config=homework4

:: Enable or disable render on launch
set run_render=0

echo.
echo Runing agent config '%agent_config%'.
echo Render match: %run_render%
echo.
:::::::

pushd .\bin\mas

:: Set the logs folder and create one if none exists
set logs_path=.\logs
if not exist "%logs_path%" mkdir %logs_path%

:: Load the agents parameters from the config file
set agents_path=.\agents\%agent_config%
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
start /b java -classpath "lib\jade.jar;lib\jadeTools.jar;lib\Base64.jar;lib\http.jar;lib\iiop.jar;lib\beangenerator.jar;lib\jgomas.jar;lib\jason.jar;lib\JasonJGomas.jar;classes;." jade.Boot -gui "Manager:es.upv.dsic.gti_ia.jgomas.CManager(%params%)" > "%logs_path%\%agent_config%_manager.log"
:: Wait some seconds, to let the manager to finish the initial setup
timeout 5 > nul
:: Run the jgomas launcher
start /b java -classpath "lib\jade.jar;lib\jadeTools.jar;lib\Base64.jar;lib\http.jar;lib\iiop.jar;lib\beangenerator.jar;lib\jgomas.jar;lib\jason.jar;lib\JasonJGomas.jar;classes;." jade.Boot -container -host localhost "%agents%" > "%logs_path%\%agent_config%_launcher.log"

popd

if %run_render% eq 1 then (
    pushd .\bin\render\w32\
    timeout 5 > nul
    :: Run the jgomas renderer
    start /b run_jgomasrender.bat
    popd
)

popd
