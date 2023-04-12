# jlink-openshift

Proof-of-Concept/experiments with integrating Java modules (`jlink`,`jdep`)
and OpenShift.

## Containers

 * [App Builder](buildapp/README.md)

## Scripts

### Prerequisites

Most of the scripts require `$JAVA_HOME` to be defined.

### Script details

 * `mkdeps.sh`:          springboot demo   → jdeps     → deps.txt
 * `mkquarkusdeps.sh`:   quarkus demo      → jdeps     → deps.txt
 * `mkstrippeddeps.sh`:  deps.txt          → filtering → stripped-deps.txt
 * `generatejdkdeps.sh`: stripped-deps.txt → filtering → module-deps.txt
 * `mkjreimage.sh`:      module-deps.txt   → jlink     → custom JDK (springboot)

 * `repack_jdk.sh`: replaced non-stripped libs from a JDK image with stripped ones from system JDK
 * `merged-script.sh`: jdeps → deps.txt → filtering → stripped-deps.txt → filtering → module-deps.txt → jlink

