#!/bin/bash
set -euo pipefail

classpath=
if test -f lib/classpath; then
    classpath="-cp $(cat lib/classpath)"
fi

$JAVA_HOME/bin/java $classpath -jar app.jar
