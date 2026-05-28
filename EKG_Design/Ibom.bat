:: Workaround für KiCad 10
::Start in KiCad mit: set INTERACTIVE_HTML_BOM_NO_DISPLAY=1&& set PROJECTNAME=${PROJECTNAME}&& ${KIPRJMOD}\Ibom.bat

::set
"%ProgramFiles%\KiCad\10.0\bin\python.exe" %KICAD10_3RD_PARTY%plugins\org_openscopeproject_InteractiveHtmlBom\generate_interactive_bom.py"" --dest-dir export --name-format %%f --dark-mode --include-tracks --include-nets --no-browser --extra-fields manf# "%KIPRJMOD%\%PROJECTNAME%.kicad_pcb"