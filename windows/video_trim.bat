@echo off
REM video_trim.bat input_file start_time end_time

if "%~3"=="" (
    echo Usage: %0 input_file start_time end_time
    echo Examples:
    echo   %0 video.mp4 0 10:00
    echo   %0 video.mp4 2 10
    echo   %0 video.mp4 1:00 2:00
    exit /b 1
)

set "INPUT=%~1"
set "START=%~2"
set "END=%~3"

REM Get filename without extension and extension
for %%F in ("%INPUT%") do (
    set "NAME=%%~nF"
    set "EXT=%%~xF"
)

REM Prepare output filename
set "OUTPUT=%NAME%_trimmed%EXT%"

REM Run ffmpeg trim
ffmpeg -y -i "%INPUT%" -ss %START% -to %END% -c copy "%OUTPUT%"

echo Trimmed video saved to %OUTPUT%
