@echo off

REM Note that this is NOT the actual shoes-picker.bat installed with shoes!
REM Rubygems generates stubs on gem installation, so this takes the place of
REM that when running from source.

REM TODO: Would be nice to get rid of the direct jruby call, but lacking the
REM generated stubs, we've got to get specific instead.
jruby shoes-core\bin\shoes-picker bin

REM Doesn't seem to percolate the error level up, so be explicit about it.
exit %errorlevel%
