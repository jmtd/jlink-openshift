#!/bin/bash
set -euo pipefail
shopt -s globstar

project="${project-quarkus-quickstart/getting-started}"
jarfile="${jarfile-$project/target/quarkus-app/quarkus-run.jar}"
libdir="${libdir-$project/target/quarkus-app/lib}"

test -f "$jarfile"
test -d "$libdir"

# Create a temporary directory for a module path
mkdir dependencies
cp $libdir/**/*.jar dependencies
# Calculate dependencies
$JAVA_HOME/bin/jdeps --module-path dependencies --ignore-missing-deps --multi-release 11 -R -s \
    "$jarfile" \
    "$libdir"/**/*.jar \
> deps.txt
# Clean up temporary directory
rm -rf dependencies
