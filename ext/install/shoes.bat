@setlocal enableextensions enabledelayedexpansion
@echo off

REM If we're running from source, bin/shoes.bat will have set bin_dir already.
if not defined bin_dir set bin_dir=%~dp0

set command=jruby --1.9 !bin_dir!/ruby-shoes %*
call !command!
endlocal
