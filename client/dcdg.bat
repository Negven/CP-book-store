@echo off
rem This file was created by pub v3.3.2.
rem Package: dcdg
rem Version: 4.1.0
rem Executable: dcdg
rem Script: dcdg
if exist "C:\Users\super\AppData\Local\Pub\Cache\global_packages\dcdg\bin\dcdg.dart-3.3.2.snapshot"                                                                                                                                                                             (
  call dart "C:\Users\super\AppData\Local\Pub\Cache\global_packages\dcdg\bin\dcdg.dart-3.3.2.snapshot"                                                                                                                                                                             %*
  rem The VM exits with code 253 if the snapshot version is out-of-date.
  rem If it is, we need to delete it and run "pub global" manually.
  if not errorlevel 253 (
    goto error
  )
  call dart pub global run dcdg:dcdg %*
) else (
  call dart pub global run dcdg:dcdg %*
)
goto eof
:error
exit /b %errorlevel%
:eof
