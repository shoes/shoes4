@setlocal enableextensions enabledelayedexpansion
@echo off
set bin_dir=%~dp0
set command=jruby --1.9 !bin_dir!/ruby-shoes %*
call !command!
endlocal
