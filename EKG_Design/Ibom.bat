@echo off
setlocal

cd /d "%~dp0"

set "INTERACTIVE_HTML_BOM_NO_DISPLAY=1"

if not defined PROJECTNAME set "PROJECTNAME=EKG_Design"

:: Auto-detect KiCad Python - Method 1: read from KiCad's own config
set "KICAD_PY="
for /f "usebackq delims=" %%i in (`powershell -NoProfile -Command "try { (Get-Content (Get-ChildItem $env:APPDATA\kicad -Filter kicad_common.json -Recurse -Depth 2 | Select-Object -First 1).FullName -Raw | ConvertFrom-Json).api.interpreter_path -replace 'pythonw\.exe','python.exe' } catch {}" 2^>nul`) do set "KICAD_PY=%%i"

:: Auto-detect KiCad Python - Method 2: search common install paths
if not defined KICAD_PY (
    for %%D in (C D E F) do (
        if not defined KICAD_PY if exist "%%D:\KiCad\bin\python.exe"                     set "KICAD_PY=%%D:\KiCad\bin\python.exe"
        if not defined KICAD_PY if exist "%%D:\Program Files\KiCad\10.0\bin\python.exe"  set "KICAD_PY=%%D:\Program Files\KiCad\10.0\bin\python.exe"
        if not defined KICAD_PY if exist "%%D:\Program Files\KiCad\9.0\bin\python.exe"   set "KICAD_PY=%%D:\Program Files\KiCad\9.0\bin\python.exe"
    )
)

:: Auto-detect InteractiveHtmlBom plugin (works across any KiCad version folder)
set "IBOM_PY="
for /d %%V in ("%USERPROFILE%\Documents\KiCad\*") do (
    if not defined IBOM_PY if exist "%%V\3rdparty\plugins\org_openscopeproject_InteractiveHtmlBom\generate_interactive_bom.py" (
        set "IBOM_PY=%%V\3rdparty\plugins\org_openscopeproject_InteractiveHtmlBom\generate_interactive_bom.py"
    )
)

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