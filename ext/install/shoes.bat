@setlocal enableextensions enabledelayedexpansion
@echo off

REM If we're running from source, bin/shoes.bat will have set bin_dir already.
if not defined bin_dir set bin_dir=%~dp0

if not exist !bin_dir!\shoes-backend (
  REM shoes-picker is directly runnable either from Rubygems stubs or our shims
  call !bin_dir!\shoes-picker !bin_dir!
)

set shoes_bin_dir=!bin_dir!
set /p command=<!bin_dir!/shoes-backend

call !command! %*
endlocal
