#!/bin/bash
project="spring-boot-sample-simple"
jarfile="$project/target/spring-boot-sample-simple-1.5.0.BUILD-SNAPSHOT.jar"
libdir="$project/target/lib"

test -f "$jarfile"
test -d "$libdir"
echo "Generating deps"
$JAVA_HOME/bin/jdeps --multi-release 11 -R -s \
    "$jarfile" \
    "$libdir"/**/*.jar \
> deps.txt

echo "Generating stripped-deps"
<deps.txt \
  grep 'java\|jdk\.'  | # mostly removes target/, but also jdk8internals
  sed -E "s/Warning: .*//" | #remove extraneous warnings
  sed -E "s/.*-> //"  | # remove src of src -> dep
  sed -E "s/.*\.jar//" | # remove extraneous dependencies
  sed "s#/.*##"       | # delete anything after a slash. in practice target/..
  sort | uniq |
tee stripped-deps.txt

echo "Checking against jdk modules"
$JAVA_HOME/bin/java --list-modules > java-modules.txt
cat java-modules.txt | sed "s/\\@.*//" > modules.txt
grep -Fx -f stripped-deps.txt modules.txt | tr '\n' ',' | tr -d "[:space:]" > module-deps.txt
echo "jdk.zipfs" >> module-deps.txt

echo "Linking jre"
$JAVA_HOME/bin/jlink --output quarkus-jre \
       	--add-modules $(cat module-deps.txt) \
	-G --no-header-files --no-man-pages
