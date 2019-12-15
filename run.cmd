@echo off
setlocal EnableDelayedExpansion
:: Set console codification
chcp 1252 > NUL
cls
pushd %~dp0

:::::::::::::::::::::
:: Agents folder name that contains their configuration
set agent_config=default

:: Enable or disable render on launch
set run_render=1

:: JGomas host
set jgomas_host=localhost

:: Render listened server
set render_server=localhost

:: Render listened port
set render_port=8001

:: Get parameters values
:loop
IF NOT "%1"=="" (
    IF "%1"=="--config" (
        SET agent_config=%2
        SHIFT
    )
    IF "%1"=="--run-render" (
        SET run_render=%2
        SHIFT
    )
    IF "%1"=="--jgomas-host" (
        SET jgomas_host=%2
        SHIFT
    )
    IF "%1"=="--render-server" (
        SET render_server=%2
        SHIFT
    )
    IF "%1"=="--render-port" (
        SET render_port=%2
        SHIFT
    )
    SHIFT
    GOTO :loop
)

echo.
echo Runing agent config '%agent_config%'.
echo JGomas host: '%jgomas_host%'
echo Run render: %run_render%
echo Render server: '%render_server%'
echo Render port: '%render_port%'
echo.
:::::::::::::::::::::

pushd .\bin\mas

:: Set the logs folder and create one if none exists
set logs_path=.\logs\%agent_config%
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
start /b java -classpath "lib\jade.jar;lib\jadeTools.jar;lib\Base64.jar;lib\http.jar;lib\iiop.jar;lib\beangenerator.jar;lib\jgomas.jar;lib\jason.jar;lib\JasonJGomas.jar;classes;." jade.Boot -container -host "%jgomas_host%" "%agents%" > "%logs_path%\%agent_config%_launcher.log"

popd

if %run_render% == 1 then (
    pushd .\bin\render\w32\
    timeout 5 > nul
    :: Run the jgomas renderer
    start /b run_jgomasrender.bat --server %render_server% --port %render_port%
    popd
)

popd
