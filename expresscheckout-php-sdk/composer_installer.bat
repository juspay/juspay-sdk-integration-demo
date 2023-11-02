@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

REM
WHERE php >nul 2>nul
IF ERRORLEVEL 1 (
    ECHO PHP is not installed. Please install PHP and try again.
    EXIT /B 1
)

REM
WHERE composer >nul 2>nul
IF ERRORLEVEL 1 (
    ECHO Composer is not installed. Installing Composer...
    
    REM
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

    REM
    php composer-setup.php

    REM
    php -r "unlink('composer-setup.php');"
    
    ECHO Composer installed successfully. You can run 'composer' command now.
) ELSE (
    ECHO Composer is already installed. You can run 'composer' command.
)

EXIT /B 0

