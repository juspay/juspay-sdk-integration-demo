#!/bin/bash

if command -v php >/dev/null 2>&1; then
    if command -v composer >/dev/null 2>&1; then
        echo "Composer available"
    else
        curl -sS https://getcomposer.org/installer | php
        mv composer.phar /usr/local/bin/composer
        echo "Composer installed successfully. You can run 'composer' command now."
    fi
else
    echo "PHP is not installed. Please install PHP and try again."
fi