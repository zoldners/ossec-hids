@echo off
REM "OSSEC Windows agent install script"
IF EXIST "c:\Program Files (x86)\ossec-agent" (GOTO VERIFYIP) ELSE (GOTO INSTALL) 

:VERIFYIP
findstr /I /C:"OSSEC server IP" "c:\Program Files (x86)\ossec-agent\ossec.conf"
IF ERRORLEVEL 1 (GOTO REINSTALL) ELSE (GOTO FINDKEY)

:INSTALL
\\server\share\ossec-agent-win32-2.9.3-2912.exe /S
timeout /t 30 /nobreak
ECHO ^<ossec_config^> >> "C:\Program Files (x86)\ossec-agent\ossec.conf"
ECHO ^<client^> >> "C:\Program Files (x86)\ossec-agent\ossec.conf"
ECHO ^<server-ip^>OSSEC server IP^</server-ip^> >> "C:\Program Files (x86)\ossec-agent\ossec.conf"
ECHO ^</client^> >> "C:\Program Files (x86)\ossec-agent\ossec.conf"
ECHO ^</ossec_config^> >> "C:\Program Files (x86)\ossec-agent\ossec.conf"
findstr /I /C:"%COMPUTERNAME% " \\server\share\hosts.txt
IF ERRORLEVEL 1 (echo %COMPUTERNAME%>> \\server\share\hosts.txt) ELSE (GOTO FINDKEY)

:REINSTALL
"c:\Program Files (x86)\ossec-agent\uninstall.exe" /S
timeout /t 10 /nobreak
\\server\share\ossec-agent-win32-2.9.3-2912.exe /S
timeout /t 30 /nobreak
ECHO ^<ossec_config^> >> "C:\Program Files (x86)\ossec-agent\ossec.conf"
ECHO ^<client^> >> "C:\Program Files (x86)\ossec-agent\ossec.conf"
ECHO ^<server-ip^>OSSEC server IP^</server-ip^> >> "C:\Program Files (x86)\ossec-agent\ossec.conf"
ECHO ^</client^> >> "C:\Program Files (x86)\ossec-agent\ossec.conf"
ECHO ^</ossec_config^> >> "C:\Program Files (x86)\ossec-agent\ossec.conf"
findstr /I /C:"%COMPUTERNAME% " \\server\share\hosts.txt
IF ERRORLEVEL 1 (echo %COMPUTERNAME%>> \\server\share\hosts.txt) ELSE (GOTO FINDKEY)

:FINDKEY 
IF NOT EXIST "c:\Program Files (x86)\ossec-agent\client.keys" (GOTO GETKEY) ELSE (GOTO END)

:GETKEY
findstr /I /C:"%COMPUTERNAME% " \\server\share\client.keys
IF ERRORLEVEL 1 (GOTO END) ELSE (findstr /I /C:"%COMPUTERNAME% " \\server\share\client.keys > "C:\Program Files (x86)\ossec-agent\client.keys"
NET START OSSECSVC
)

:END
EXIT
