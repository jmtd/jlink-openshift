#!/bin.bash
set -euo pipefail

BASEIMG=${BASEIMG:=registry.access.redhat.com/ubi8/openjdk-17}
APPSRC=${APPSRC:=https://github.com/quarkusio/quarkus-quickstarts.git}
CONTEXTDIR=${CONTEXTDIR:=getting-started}
rev=${rev:=2.16.4.Final}
OUTIMG=jlink-appsrc

# Note: this directory needs to be owned by uid 185
WORKDIR=${WORKDIR:=$PWD/work}

s2i build --pull-policy if-not-present --context-dir=$CONTEXTDIR -r=${rev} \
    -e S2I_DELETE_SOURCE=false \
    -v $WORKDIR:/tmp/src \
    $APPSRC \
    $BASEIMG \
    $OUTIMG
