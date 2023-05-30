#!/bin.bash
set -euo pipefail

BASEIMG=${BASEIMG:=registry.access.redhat.com/ubi8/openjdk-17}
APPSRC=${APPSRC:=https://github.com/quarkusio/quarkus-quickstarts.git}
CONTEXTDIR=${CONTEXTDIR:=getting-started}
rev=${rev:=3.0.3.Final}
OUTIMG=jlink-appsrc

# Note: this directory needs to be owned by uid 185
WORKDIR=${WORKDIR:=$PWD/work}

s2i build --pull-policy if-not-present --context-dir=$CONTEXTDIR -r=${rev} \
    -e S2I_DELETE_SOURCE=false \
    -e QUARKUS_PACKAGE_TYPE=uber-jar \
    -e MAVEN_S2I_ARTIFACT_DIRS=target \
    -e S2I_SOURCE_DEPLOYMENTS_FILTER="*.jar" \
    -e JAVA_APP_JAR= \
    -v $WORKDIR:/tmp/src \
    $APPSRC \
    $BASEIMG \
    $OUTIMG
