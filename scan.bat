@echo off
setlocal enabledelayedexpansion

REM Function to find missing files in a directory
:find_missing_files
for /r %%d in (.) do (
    pushd "%%d"
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
    popd
)
goto :eof

REM Function to check for missing files in a sequence
:check_missing_files
set "directory=%~1"
set "mp3_files=%~2"
set "missing_files="
set "mp3_files=%mp3_files:,= %"
set "array=0 %mp3_files%"

for %%a in (%mp3_files%) do (
    if not defined start (
        set "start=%%a"
    )
    set "end=%%a"
)

for /l %%i in (%start%,1,%end%) do (
    set "number=0%%i"
    set "number=!number:~-2!"
    if "!mp3_files!" not contain "!number!" (
        set "missing_files=!missing_files! !number!"
    )
)

if defined missing_files (
    echo Missing files in directory %directory%: %missing_files: =, %
)

goto :eof

REM Main execution
cd /d "%~dp0"
call :find_missing_files
endlocal
