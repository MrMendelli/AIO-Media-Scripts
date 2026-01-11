@ echo off

setlocal EnableDelayedExpansion
title %~n0
set "Scale=480"

where ffmpeg > nul
if not errorlevel 0 (
    color 0c
    echo.
    echo ffmpeg is not present in PATH, exiting.
    pause
    exit /b 0
) else if not exist "%~1" (
    color 0c
    echo.
    echo No infile supplied...
    pause
    exit /b 0
) else do (
    for /f "delims=" %%a in (
        'dir /b "%ProgramData%\Lian-Li\L-Connect 3\uploaded"'
    ) do (
        if "!AIO!" neq "" (
            cls
            color 0c
            echo.
            echo No AIO directory found in %ProgramData%\Lian-Li\L-Connect 3\uploaded\.
            echo Ensure device and drivers have been properly installed.
            pause
            exit /b 0
        ) else (
            set "AIO=%%~a"
            set "OutDir=%ProgramData%\Lian-Li\L-Connect 3\uploaded\!AIO!"
        )
    )
) else (
    for %%f in (
        %*
    ) do (
        md "%ProgramData%\Lian-Li\L-Connect 3\uploaded\!AIO!\thumbnail"
        for /f "delims=" %%x in (
            'ffprobe -hide_banner -v error -select_streams v -show_entries stream^=width -of csv^=p^=0:s^=x %%f'
        ) do (
            for /f "delims=" %%y in (
                'ffprobe -hide_banner -v error -select_streams v -show_entries stream^=height -of csv^=p^=0:s^=x %%f'
            ) do (
                set "OutFile=%%~nf (!Scale!x).!Format!"
                if %%x equ %%y (
                    if %%x lss !Scale! (
                        cls
                        color 0c
                        echo.
                        echo Warning: The resolution scale of ~\%%~nxf is %%xpx.
                        echo Minimum must be !Scale!px or more to meet minimum resolution requirement.
                        pause > nul
                        exit /b 0
                    ) else (
                        ffmpeg -hide_banner -i %%f -filter:v scale=!Scale!:-1 -f h264 -c:a copy -an "!OutDir!\%%~nf.mp4"
                        ffmpeg -hide_banner -i "!OutDir!\%%~nf.mp4" -pix_fmt yuv420p -c:v libx264 -preset ultrafast "!OutDir!\%%~nf.h264"
                        ffmpeg -hide_banner -i "!OutDir!\%%~nf.mp4" -vf "select=eq(n\,0)" -q:v 3 "!OutDir!\thumbnail\%%~nf.jpg"
                    )
                ) else if %%x gtr %%y (
                    if %%y lss !Scale! (
                        cls
                        color 0c
                        echo.
                        echo Warning: Height of ~\%%~nxf is %%ypx.
                        echo Minimum height must be !Scale!px or more to meet minimum resolution requirement.
                        pause > nul
                        exit /b 0
                    ) else (
                        ffmpeg -hide_banner -i %%f -filter:v "crop=%%y:%%y,scale=!Scale!:-1" -f h264 -c:a copy -an "!OutDir!\%%~nf.mp4"
                        ffmpeg -hide_banner -i "!OutDir!\%%~nf.mp4" -pix_fmt yuv420p -c:v libx264 -preset ultrafast "!OutDir!\%%~nf.h264"
                        ffmpeg -hide_banner -i "!OutDir!\%%~nf.mp4" -vf "select=eq(n\,0)" -q:v 3 "!OutDir!\thumbnail\%%~nf.jpg"
                    )
                ) else if %%x lss %%y (
                    if %%x lss !Scale! (
                        cls
                        color 0c
                        echo.
                        echo Warning: Width of ~\%%~nxf is %%xpx.
                        echo Minimum width must be !Scale!px or more to meet minimum resolution requirement.
                        pause > nul
                        exit /b 0
                    ) else (
                        ffmpeg -hide_banner -i %%f -filter:v "crop=%%x:%%x,scale=!Scale!:-1" -f h264 -c:a copy -an "!OutDir!\%%~nf.mp4"
                        ffmpeg -hide_banner -i "!OutDir!\%%~nf.mp4" -pix_fmt yuv420p -c:v libx264 -preset ultrafast "!OutDir!\%%~nf.h264"
                        ffmpeg -hide_banner -i "!OutDir!\%%~nf.mp4" -vf "select=eq(n\,0)" -q:v 3 "!OutDir!\thumbnail\%%~nf.jpg"
                    )
                )
            )
            if !errorlevel! neq 0 (
                echo.
            ) else (
                echo.
            )
        )
    )
    pause
)
exit /b 0
