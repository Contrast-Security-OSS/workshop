@echo off
forfiles /p templates /m *.template /C "cmd /c copy @file ..\@fname.bat"
set /p org_uuid="Enter org_uuid:"
set /p api_key="Enter api_key:"
set /p authorization_key="Enter authorization_key:"
set /p service_key="Enter service_key:"
set /p username="Enter username:"

forfiles /p templates /m *.template /S /C "CMD /C ..\replace.bat {org_uuid} %org_uuid% @file > ..\@fname.1"
forfiles /M *.1 /S /C "CMD /C replace.bat {api_key} %api_key% @file > @fname.2"
forfiles /M *.2 /S /C "CMD /C replace.bat {authorization_key} %authorization_key% @file > @fname.3"
forfiles /M *.3 /S /C "CMD /C replace.bat {service_key} %service_key% @file > @fname.4"
forfiles /M *.4 /S /C "CMD /C replace.bat {username} %username% @file > @fname.bat"

del *.1 *.2 *.3 *.4
