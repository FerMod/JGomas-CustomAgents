@echo off

SET server=localhost
SET port=8001
:: OpenSceneGraph data folder
SET OSG_FILE_PATH=../../data

:loop
IF NOT "%1"=="" (
    IF "%1"=="--server" (
        SET server=%2
        SHIFT
    )
    IF "%1"=="--port" (
        SET port=%2
        SHIFT
    )
    IF "%1"=="--data" (
        SET data=%2
        SHIFT
    )
    SHIFT
    GOTO :loop
)

CALL JGOMAS_Render.exe --server "%server%" --port "%port%"
