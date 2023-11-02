#!/bin/bash

# CHECK JAVA IS INSTALLED
if command -v java &>/dev/null; then
    echo "Java is installed."
else
    echo "Java is not installed."
    exit 1
fi

# CHECK JAVA VERSION
java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
if [[ "$java_version" == 1.[89]* || "$java_version" == 9.* || "$java_version" == [1-9][0-9].* ]]; then
    echo "Java version is greater than or equal to 8: $java_version"
else
    echo "Java version should be at least 8  $java_version"
    exit
fi

# CHECK MAVEN IS INSTALLED AND JAVA_HOME PATH IS SET PROPERLY
if command -v mvn &>/dev/null; then
    echo "Maven is installed."
    if [ -n "$JAVA_HOME" ]; then
        echo "JAVA_HOME: $JAVA_HOME"
        if command "$JAVA_HOME"/bin/java -version &>/dev/null; then
          java_version_from_java_home="$("$JAVA_HOME"/bin/java -version 2>&1 | awk -F\" '/version/ {print $2}')"
          echo "java version from JAVA_HOME:- $java_version_from_java_home"
          java_version_from_system="$(java -version 2>&1 | awk -F\" '/version/ {print $2}')"
          echo "java version from system $java_version_from_system"
          if [ "$java_version_from_java_home" = "$java_version_from_system" ]; then
              echo "The JAVA_HOME version matches the system's Java version."
          else
              echo "The JAVA_HOME version ($java_version_from_java_home) does not match the system's Java version ($java_version_from_system)."
          fi
        else
          echo "Please ensure JAVA_HOME variable is properly set:- $JAVA_HOME"
          exit 1
        fi
    else
        echo "Please set JAVA_HOME path"
        exit 1
    fi
else
    echo "Please install maven."
    exit 1
fi

DEFAULT_PORT=5000
if [ -n "$1" ]; then
    PORT_NUMBER=$1
else
    PORT_NUMBER=$DEFAULT_PORT
fi

mvn clean install
mvn clean package

stop_jetty() {
    echo "Stopping Jetty server..."
    mvn jetty:stop
    exit
}

trap 'stop_jetty' INT

mvn jetty:run -Djetty.port=$PORT_NUMBER