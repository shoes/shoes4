@echo off

REM Note that this is NOT the actual bin/shoes.bat that gets installed with
REM the gem! ext\install\shoes.bat is copied over to bin for gems, but this
REM is the right thing to use from bin on a source checkout.

set bin_dir=%~dp0
ext\install\shoes.bat %*