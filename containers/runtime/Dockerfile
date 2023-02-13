# Experimental runtime image builder. Requires 'spring-jre' and 'target'
# in current working directory when executing the build, e.g. (from the
# repository root):
#   podman build -t jlink-runtime containers/runtime/Dockerfile

# CAVEAT: the version of this container MUST align GLIBC versions with the micro
# below.
FROM registry.access.redhat.com/ubi8/ubi-minimal:latest as builder

RUN microdnf install \
    --installroot /tmp/micro \
    --setopt=install_weak_deps=0 \
    --releasever 8 \
    --nodocs -y \
    --config /dev/null \
    --noplugins \
    --setopt=cachedir=/var/cache/yum \
    --setopt=reposdir=/etc/yum.repos.d \
    --setopt=varsdir=/tmp/varsdir \
    zlib \
    libstdc++ \
    glibc \
    rpm

# dependencies so far:
# /usr/bin/java: zlib
# libjvm.so:     libstdc++
# libc6: the micro container already has libc6, but we need to ensure that
# the version aligns exactly with the builder. At the time of writing,
# ubi-micro:latest is a minor version behind ubi-minimal:latest.
# rpm: debugging

FROM registry.access.redhat.com/ubi8/ubi-micro:latest

COPY --from=builder /tmp/micro/ /

COPY spring-jre /deployments/spring-jre
ENV  JAVA_HOME  /deployments/spring-jre

COPY /target/spring-boot-sample-simple-1.5.0.BUILD-SNAPSHOT.jar /deployments
COPY /target/lib /deployments/lib

CMD  $JAVA_HOME/bin/java -cp $(cat /deployments/lib/classpath) /deployments/spring-boot-sample-simple-1.5.0.BUILD-SNAPSHOT.jar
