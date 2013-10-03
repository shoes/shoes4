@setlocal enableextensions enabledelayedexpansion
@echo off
set bin_dir=%~dp0
set root_dir=!bin_dir:~0,-4!
set lib_dir=!root_dir!lib
set command=jruby --1.9 -I "!lib_dir!" -e "require 'shoes'; require 'shoes/configuration'; Shoes.configuration.backend = :swt; require '%1' "
call !command!
endlocal
