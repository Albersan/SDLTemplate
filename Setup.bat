@echo off
echo *********************************************************************************************************************
echo *************************************************** Setup Project ***************************************************
echo *********************************************************************************************************************
echo.
:PROMPT

setlocal enabledelayedexpansion

if not exist "downloads" mkdir "downloads"

:: URLs list for the libraries
for %%A in (
    "https://github.com/libsdl-org/SDL/releases/download/release-2.32.0/SDL2-devel-2.32.0-VC.zip SDL2.zip"
    "https://github.com/libsdl-org/SDL_image/releases/download/release-2.8.8/SDL2_image-devel-2.8.8-VC.zip SDL2_image.zip"
    "https://github.com/libsdl-org/SDL_mixer/releases/download/release-2.8.1/SDL2_mixer-devel-2.8.1-VC.zip SDL2_mixer.zip"
) do (
    for /f "tokens=1,2 delims= " %%B in ("%%A") do (
        set "DOWNLOAD_URL=%%B"
        set "ZIP_FILE=downloads\%%C"
	echo.
        echo Downloading %%C...
        powershell -Command "& {Invoke-WebRequest '!DOWNLOAD_URL!' -OutFile '!ZIP_FILE!'}"

        if not exist "!ZIP_FILE!" (
            echo Error: Can't download !ZIP_FILE!.
            exit /b
        )

        echo Download completed. Extracting...
	echo.

        :: Use PowerShell for unzip the .zip
        powershell -Command "Expand-Archive -Path '!ZIP_FILE!' -DestinationPath 'downloads' -Force"
    )
)
:: Make the target folders
if not exist "downloads\include" mkdir "downloads\include"
if not exist "downloads\lib" mkdir "downloads\lib"
if not exist "downloads\bin" mkdir "downloads\bin"

:: Copy SDL2 files

if not exist "libs" mkdir "libs"
if not exist "libs\SDL2" mkdir "SDL2"
if not exist "libs\SDL2\bin" mkdir "libs\SDL2\bin"
if not exist "libs\SDL2\include" mkdir "libs\SDL2\include"
if not exist "libs\SDL2\lib" mkdir "libs\SDL2\lib"

echo Copying SDL files...
xcopy /E /I /Y "downloads\SDL2-2.32.0\include\*" "libs\SDL2\include\"
xcopy /E /I /Y "downloads\SDL2-2.32.0\lib\x64\*.lib" "libs\SDL2\lib\"
xcopy /E /I /Y "downloads\SDL2-2.32.0\lib\x64\*.dll" "libs\SDL2\bin\"

xcopy /E /I /Y "downloads\SDL2_image-2.8.8\include\*" "libs\SDL2\include\"
xcopy /E /I /Y "downloads\SDL2_image-2.8.8\lib\x64\*.lib" "libs\SDL2\lib\"
xcopy /E /I /Y "downloads\SDL2_image-2.8.8\lib\x64\*.dll" "libs\SDL2\bin\"

xcopy /E /I /Y "downloads\SDL2_mixer-2.8.1\include\*" "libs\SDL2\include\"
xcopy /E /I /Y "downloads\SDL2_mixer-2.8.1\lib\x64\*.lib" "libs\SDL2\lib\"
xcopy /E /I /Y "downloads\SDL2_mixer-2.8.1\lib\x64\*.dll" "libs\SDL2\bin\"

if exist "downloads" (
    rmdir /s /q "downloads"
)
if exist "SDL2" (
    rmdir /s /q "SDL2"
)


:: Change the project name in the CMakeLists.txt
for %%I in ("%CD%") do set PROJECT_NAME=%%~nxI

powershell -Command "(Get-Content CMakeLists.txt) -replace '^project\(.*\).*$', 'project(%PROJECT_NAME%) # Project name' | Set-Content CMakeLists.txt"

if exist "build" (
    rmdir /s /q "build"
)

mkdir "build"

cd build
cmake -G "Visual Studio 17 2022" ..

echo.
echo Your project setup was done perfectly
echo.

pause
:END