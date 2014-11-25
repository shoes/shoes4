@echo off

REM Note that this is NOT the actual bin/shoes.bat that gets installed with
REM the gem! shoes\ext\install\shoes.bat is copied over to bin for gems, but
REM this is the right thing to use from bin on a source checkout.

set bin_dir=shoes\bin
shoes\ext\install\shoes.bat %*
