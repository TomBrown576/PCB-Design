@echo off
setlocal

cd /d "%~dp0"

set "INTERACTIVE_HTML_BOM_NO_DISPLAY=1"
set "PROJECTNAME=EKG_Design"
set "KICAD_PY=C:\Program Files\KiCad\10.0\bin\python.exe"
set "IBOM_PY=%KICAD10_3RD_PARTY%\plugins\org_openscopeproject_InteractiveHtmlBom\generate_interactive_bom.py"
set "PCB_FILE=%~dp0%PROJECTNAME%.kicad_pcb"
set "OUT_DIR=%~dp0bom"

if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"

"%KICAD_PY%" "%IBOM_PY%" ^
--dest-dir "%OUT_DIR%" ^
--name-format ibom ^
--dark-mode ^
--no-browser ^
--extra-fields "manf#" ^
"%PCB_FILE%"

endlocal