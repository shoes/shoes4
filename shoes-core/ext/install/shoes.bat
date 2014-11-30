@setlocal enableextensions enabledelayedexpansion
@echo off

REM If we're running from source, bin/shoes.bat will have set bin_dir already.
if not defined bin_dir set bin_dir=%~dp0

if not exist !bin_dir!\shoes-backend (
  REM TODO: Can we get rid of jruby in some way here? My Windows box didn't
  REM have a global ruby installed by just installing jruby :(
  jruby --1.9 !bin_dir!\shoes-picker !bin_dir!
)

set /p command=<!bin_dir!/shoes-backend
call !command! %*
endlocal
