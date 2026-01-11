@ echo off

setlocal EnableDelayedExpansion
title AIO Animation (Squared)

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
    echo No infile^(s^) supplied, exiting...
    pause
    exit /b 0
) else (
    :SetFormat
    set "Format="
    set "Scale="
    cls
    color 0e
    echo.
    echo Format and scale options are applied to all listed items.
    echo File^(s^) will output to a 1:1 ^(squared^) aspect ratio.
    echo.
    echo Selected file^(s^):
    echo.
    for %%a in (
        %*
    ) do (
        echo   ~\%%~nxa
    )
    echo.
    echo Supported formats:
    echo.
    :: APNG; Requires encoding lines to be duplicated with check if !Format! is set to apng then use APNG encode flags and extension override. Might add later.
    echo   - GIF
    echo   - MKV
    echo   - MP4
    echo   - WebP
    echo.
    set /p Format="Choose format: "
    echo.
    :: Annoying, doesn't work with desired inverse-case checks for some reason. Always hits error case regardless if input is valid or not.
    if "!Format!" equ "" (
        color 0c
        echo You must enter a value.
        pause > nul
        goto :SetFormat
    ) else if "!Format!" equ "gif" (
        goto :SetScale
    ) else if "!Format!" equ "mkv" (
        goto :SetScale
    ) else if "!Format!" equ "mp4" (
        goto :SetScale
    ) else if "!Format!" equ "webp" (
        goto :SetScale
    ) else if "!Format!" neq "" (
        color 0c
        echo You must enter a supported format from the list.
        pause > nul
        goto :SetFormat
    ) else (
        :: Can't combine into prior menu as additional prompt without it being ugly or causing issues with resetting variables or forcing a complete prompt reset.
        :SetScale
        set "Scale="
        cls
        color 0e
        echo.
        echo ^(Enter -r to return to format^)
        set /p Scale="Choose resolution scale: "
        echo.
        if "!Scale!" equ "-r" (
            goto :SetFormat
        ) else if "!Scale!" equ "" (
            color 0c
            echo You must enter a value.
            pause > nul
            goto :SetScale
        ) else if !Scale! lss 32 (
            color 0c
            echo Scale must be 32 or higher.
            pause > nul
            goto :SetScale
        ) else if !Scale! gtr 4096 (
            color 0c
            echo Scale must be 4096 or lower.
            pause > nul
            goto :SetScale
        ) else (
            color 07
            cls
            for %%f in (
                %*
            ) do (
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
                                echo Maximum value must be %%xpx or less to prevent stretching or distortion.
                                pause > nul
                                goto :SetScale
                            ) else (
                                ffmpeg -hide_banner -i %%f -filter:v "scale=!Scale!:-1" -c:a copy -an "!OutFile!"
                            )
                        ) else if %%x gtr %%y (
                            if %%y lss !Scale! (
                                cls
                                color 0c
                                echo.
                                echo Warning: Height of ~\%%~nxf is %%ypx.
                                echo Maximum height value must be %%ypx or less to prevent stretching or distortion.
                                pause > nul
                                goto :SetScale
                            ) else (
                                ffmpeg -hide_banner -i %%f -filter:v "crop=%%y:%%y,scale=!Scale!:-1" -c:a copy -an "!OutFile!"
                            )
                        ) else if %%x lss %%y (
                            if %%x lss !Scale! (
                                cls
                                color 0c
                                echo.
                                echo Warning: Width of ~\%%~nxf is %%xpx.
                                echo Maximum width value must be %%xpx or less to prevent stretching or distortion.
                                pause > nul
                                goto :SetScale
                            ) else (
                                ffmpeg -hide_banner -i %%f -filter:v "crop=%%x:%%x,scale=!Scale!:-1" -c:a copy -an "!OutFile!"
                            )
                        )
                    )
                )
                if !errorlevel! neq 0 (
                    echo.
                ) else (
                    echo.
                )
            )
            pause
        )
    )
)
exit /b 0
