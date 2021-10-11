#!/bin/bash
set -euo pipefail

test -f deps.txt

<deps.txt \
  sed -E "s/.*-> //"  | # remove src of src -> dep
  grep -v "not found" | # clear out unresolved deps
  sed "s#/.*##"       | # delete anything after a slash. in practice target/..
  grep 'java\|jdk\.'  | # mostly removes target/, but also jdk8internals
  sort | uniq | tr '\n' ',' | tr -d "[:space:]" |
tee stripped-deps2.txt
