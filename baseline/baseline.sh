#!/bin.bash
set -euo pipefail

# Baseline S2I app build (app layered on top of builder image)

BASEIMG=${BASEIMG:=registry.access.redhat.com/ubi8/openjdk-17:1.15-1.1682053058}
APPSRC=${APPSRC:=https://github.com/quarkusio/quarkus-quickstarts.git}
CONTEXTDIR=${CONTEXTDIR:=getting-started}
rev=${rev:=2.16.4.Final}
rev=3.0.3.Final
OUTIMG=jlink-baseline:$rev

s2i build --pull-policy if-not-present --context-dir=$CONTEXTDIR -r=${rev} \
    -e S2I_DELETE_SOURCE=true \
    -e MAVEN_CLEAR_REPO=true \
    -e QUARKUS_PACKAGE_TYPE=uber-jar \
    -e MAVEN_S2I_ARTIFACT_DIRS=target \
    -e S2I_SOURCE_DEPLOYMENTS_FILTER="*.jar" \
    -e JAVA_APP_JAR= \
    $APPSRC \
    $BASEIMG \
    $OUTIMG

docker save $OUTIMG | wc -c
