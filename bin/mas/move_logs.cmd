@echo off

SET folder_path=logs\
:loop
IF NOT "%1"=="" (
    IF "%1"=="--path" (
        SET folder_path=%2
        SHIFT
    )
    SHIFT
    GOTO :loop
)

move APDescription.txt %folder_path%\
move JGOMAS_Statistics.txt %folder_path%\
move MTPs-Main-Container.txt %folder_path%\
move agente.log %folder_path%\
del /Q agente.log.*
