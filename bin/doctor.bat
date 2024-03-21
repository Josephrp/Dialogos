@echo off
chcp 65001 >nul

set BIN_PATH=%~dp0
set ROOT_PATH=%BIN_PATH%..
set PROJECT_NAME=Dialogos
set MINICONDA_PATH=%ROOT_PATH%\miniconda\
set CONDA_BIN_PATH=%MINICONDA_PATH%condabin\
set CONDA_CMD=%CONDA_BIN_PATH%conda
set SETUP_FILE=%BIN_PATH%setup.bat
set RUN_FILE=%BIN_PATH%run.py
set /a ERROR_COUNT=0

echo.
call :check_project_folder
call :check_miniconda_folder
call :check_conda_folder
call :check_run_folder

:fix_errors
if "%1"=="--fix" (
    if %ERROR_COUNT% gtr 0 (
        echo 🚫 There were %ERROR_COUNT% errors in the installation and setup of the previous batch file.
        echo Please press any key to begin the healing process.
        pause
        call %SETUP_FILE%
        echo.
    )
)
goto :exit

:check_project_folder
if not exist %ROOT_PATH%\%PROJECT_NAME% (
    echo 🚫 Project folder not found: %ROOT_PATH%\%PROJECT_NAME%
    set /a ERROR_COUNT+=1
) 2>nul
goto :eof

:check_miniconda_folder
if not exist %MINICONDA_PATH% (
    echo 🚫 Miniconda folder not found: %MINICONDA_PATH%
    set /a ERROR_COUNT+=1
) 2>nul
goto :eof

:check_conda_folder
call %CONDA_CMD% info --envs | findstr /C:"%PROJECT_NAME%" >nul 2>nul
if errorlevel 1 (
    echo 🚫 Conda environment not activated: %PROJECT_NAME%
    set /a ERROR_COUNT+=1
) 2>nul
goto :eof

:check_run_folder
if not exist %RUN_FILE% (
    echo 🚫 Run.py file not found: %RUN_FILE%
    set /a ERROR_COUNT+=1
) 2>nul
goto :eof

:exit
if %ERROR_COUNT% equ 0 (
    echo ✅ Everything is set up correctly 🎭
)
echo.
exit /b %ERROR_COUNT%

:eof
