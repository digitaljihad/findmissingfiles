@echo off
setlocal enabledelayedexpansion

REM Function to find missing files in a directory
:find_missing_files
for /r %%d in (.) do (
    pushd "%%d"
    if errorlevel 1 goto :skip_directory
    set "mp3_files="
    for %%f in (*.mp3) do (
        set "file_name=%%~nf"
        set "file_prefix=!file_name:~0,2!"
        if "!file_prefix!" geq "00" if "!file_prefix!" leq "99" (
            set "mp3_files=!mp3_files! !file_prefix!"
        )
    )

    if defined mp3_files (
        set "mp3_files=!mp3_files: =,!"
        call :check_missing_files "%%d" !mp3_files!
    )
    :skip_directory
    popd
)
goto :eof

REM Function to check for missing files in a sequence
:check_missing_files
set "directory=%~1"
set "mp3_files=%~2"
set "missing_files="
set "mp3_files=%mp3_files:,= %"

set /a "start=100"
set /a "end=0"

for %%a in (%mp3_files%) do (
    set /a "num=%%a"
    if !num! lss !start! set "start=%%a"
    if !num! gtr !end! set "end=%%a"
)

for /l %%i in (!start!,1,!end!) do (
    set "found=0"
    set "number=0%%i"
    set "number=!number:~-2!"
    for %%j in (%mp3_files%) do (
        if "!number!"=="%%j" set "found=1"
    )
    if !found! equ 0 (
        set "missing_files=!missing_files!, %%i"
    )
)

if defined missing_files (
    echo Missing files in directory "%directory%": !missing_files:~2!
)

goto :eof

REM Main execution
cd /d "%~dp0"
call :find_missing_files
endlocal
