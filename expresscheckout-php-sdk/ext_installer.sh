#!/bin/sh

checkForErrors() {
    local output=$1
    if echo "$output" | grep -q "error"; then
        echo "Error occurred: $output"
        exit 1
    else
        echo "Installation successful: $output"
        exit 0
    fi
}
installPackage() {
    local packageName=$1
    if [ -x "$(command -v apk)" ];       then cmd="apk add --no-cache $packageName"
    elif [ -x "$(command -v apt-get)" ]; then cmd="apt-get install $packageName -y"
    elif [ -x "$(command -v dnf)" ];     then cmd="dnf install $packageName -y"
    elif [ -x "$(command -v zypper)" ];  then cmd="zypper install $packageName -y"
    else echo "FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: $packagesName">&2 && exit 1
    fi
    echo "$cmd"
}

installGmp() {
    if [ -x "$(command -v docker-php-ext-install)" ]; then
        if [ -x "$(command -v apk)" ]; then dependentPackage=$(installPackage "gmp-dev")
        else dependentPackage=$(installPackage "libgmp-dev")
        fi
        phpExt="docker-php-ext-install gmp"
        echo installing packages command: $dependentPackage $phpExt
        output=$($dependentPackage && $phpExt | tee /dev/tty)
        checkForErrors "$output"
    else
        if [ -x "$(command -v apk)" ]; then dependentPackage=$(installPackage "gmp-dev")
        else dependentPackage=$(installPackage "libgmp-dev")
        fi
        if [ ! "$EUID" = "0" ]
          then usesudo=sudo
        fi
        cmd=$(installPackage "php-gmp")
        echo installing packages command gmp: $usesudo $dependentPackage $cmd
        output=$($usesudo $dependentPackage && $usesudo $cmd | tee /dev/tty)
        checkForErrors "$output"
    fi
}

installBCMath() {
     if [ -x "$(command -v docker-php-ext-install)" ]; then
        phpExt="docker-php-ext-install bcmath"
        echo installing packages command: $phpExt
        output=$($phpExt | tee /dev/tty)
        checkForErrors "$output"
    else
        cmd=$(installPackage "php-bcmath")
        if [ ! "$EUID" = "0" ]
          then usesudo=sudo
        fi
        echo installing packages command: $usesudo $cmd
        output=$($usesudo $cmd | tee /dev/tty)
        checkForErrors "$output"
    fi
}

if [ "$1" = "gmp" ]; then installGmp
else installBCMath
fi