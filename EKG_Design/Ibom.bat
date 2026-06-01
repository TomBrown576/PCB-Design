@echo off
setlocal

cd /d "%~dp0"

set "INTERACTIVE_HTML_BOM_NO_DISPLAY=1"

if not defined PROJECTNAME set "PROJECTNAME=EKG_Design"

set "KICAD_PY=%ProgramFiles%\KiCad\10.0\bin\python.exe"
set "IBOM_PY=%KICAD10_3RD_PARTY%plugins\org_openscopeproject_InteractiveHtmlBom\generate_interactive_bom.py"
set "PCB_FILE=%~dp0%PROJECTNAME%.kicad_pcb"
set "OUT_DIR=%~dp0export"

if not exist "%KICAD_PY%" (
    echo KiCad Python not found:
    echo "%KICAD_PY%"
    pause
    exit /b 1
)

if not exist "%IBOM_PY%" (
    echo InteractiveHtmlBom script not found:
    echo "%IBOM_PY%"
    pause
    exit /b 1
)

if not exist "%PCB_FILE%" (
    echo PCB file not found:
    echo "%PCB_FILE%"
    pause
    exit /b 1
)

if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"

"%KICAD_PY%" "%IBOM_PY%" ^
  --dest-dir "%OUT_DIR%" ^
  --group-fields "Value,Footprint" ^
  --name-format "%%f" ^
  --dark-mode ^
  --include-tracks ^
  --include-nets ^
  --no-browser ^
  --extra-fields "manf#" ^
  --show-fields "Value,manf#,Footprint" ^
  --dnp-field "kicad_dnp" ^
  --checkboxes "Placed" ^
  --extra-data-file "%PCB_FILE%" ^
  "%PCB_FILE%"

pause