#!/bin/bash
# Depends on the following packages being installed:
#
# java-11-openjdk-devel
#
usage() {
  echo "usage: bash $0 {SYSTEM-JDK-BASE-DIR} {JDK-IMAGE}" 1>&2
  echo -e "\n" 1>&2
  echo "Examples: " 1>&2
  echo "  bash $0 /usr/lib/jvm/java-11-openjdk /path/to/jdk11-image" 1>&2
  echo "  bash $0 /usr/lib/jvm/java-10-openjdk /path/to/jdk10-image" 1>&2
  echo "  bash $0 /usr/lib/jvm/java-9-openjdk /path/to/jdk9-image" 1>&2
  exit 1
}

if [ $# -ne 2 ]; then
  usage
fi
INSTALL_BASE="$1"
JDK_IMAGE="$2"
echo -n "Replacing shared libraries from JDK image '$JDK_IMAGE' with shared libraries from '$INSTALL_BASE'... "

pushd $JDK_IMAGE > /dev/null
  for l in $(find -name \*.so); do
    rm $l
    cp $INSTALL_BASE/$l $l
  done
popd > /dev/null
echo "Done."
