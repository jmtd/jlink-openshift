#!/bin/bash
set -euo pipefail
set -x
shopt -s globstar

# These paths are hard-coded here.
# The expectation is the container invocation will volume-mount in
# the appropriate contents.
#
jarfile=${jarfile-/tmp/run/app.jar}
libdir=/tmp/run/lib
outputjre=/tmp/run/out

die()
{
  echo "$@" >&2
  exit 1
}

test -f "$jarfile" || die "cannot find jarfile $jarfile"
test -d "$libdir"  || die "cannot find libdir $libdir"

# gather dependencies in one place for a module path
mkdir -p /tmp/run/deps
pushd /tmp/run/deps
for jar in "$libdir"/**/*.jar ; do
  test -e "$jar" || ln -s "$jar"
done
popd

echo "Generating deps"
$JAVA_HOME/bin/jdeps --multi-release 11 -R -s \
    --module-path /tmp/run/deps \
    "$jarfile" \
    "$libdir"/**/*.jar \
> deps.txt

echo "Generating stripped-deps"
<deps.txt \
  grep 'java\|jdk\.'	   | # mostly removes target/, but also jdk8internals
  sed -E "s/Warning: .*//" | # remove extraneous warnings
  sed -E "s/.*-> //"	   | # remove src of src -> dep
  sed -E "s/.*\.jar//"	   | # remove extraneous dependencies
  sed "s#/.*##"		   | # delete anything after a slash. in practice target/..
  sort | uniq |
tee stripped-deps.txt

echo "Checking against jdk modules"
$JAVA_HOME/bin/java --list-modules > all-java-modules.txt

# remove module version suffix
<all-java-modules.txt sed 's/@.*//' > modules.txt

# extract only those modules from the JDK that are in our dependency list
# (for springboot-example-simple, the output is identical to stripped-deps.txt)
# and reformat into a comma-separated list, ready for jlink
grep -Fx -f stripped-deps.txt modules.txt | tr '\n' ',' | tr -d "[:space:]" > module-deps.txt

# add this module for some reason
echo "jdk.zipfs" >> module-deps.txt

echo "Linking jre"
$JAVA_HOME/bin/jlink --output "$outputjre/jre"   \
       	--add-modules $(cat module-deps.txt) \
	--strip-debug --no-header-files --no-man-pages
