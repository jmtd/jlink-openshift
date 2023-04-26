#!/bin/bash
set -euo pipefail

# an extremely basic run script for java applications.
# for a more fully-featured run script, see
# https://github.com/jboss-container-images/openjdk/tree/ubi9/modules/run
# or
# https://github.com/fabric8io-images/run-java-sh/

classpath=
if test -f lib/classpath; then
    classpath="-cp $(cat lib/classpath)"
fi

appjar="${appjar-app.jar}"

$JAVA_HOME/bin/java $classpath -jar "$appjar"
