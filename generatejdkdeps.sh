#!/bin/bash

JAVA_HOME="/lib/jvm/java-11-openjdk/bin"

$JAVA_HOME/java --list-modules > java-modules.txt
cat java-modules.txt | sed "s/\\@.*//" > modules.txt
grep -Fx -f stripped-deps.txt modules.txt | tr '\n' ',' | tr -d "[:space:]" > module-deps.txt
echo "jdk.zipfs" >> module-deps.txt
