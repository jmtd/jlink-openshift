# Experimental runtime image builder. Requires 'jre' and 'target'
# in current working directory when executing the build, e.g. (from the
# repository root):
#   podman build -t jlink-runtime containers/runtime/Dockerfile

# CAVEAT: the version of this container MUST align GLIBC versions with the micro
# below. For that reason we explicitly re-install glibc in the build step (sometimes
# ubi micro and minimal:latest can be out of alignment)
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
    glibc

# system dependencies so far:
# /usr/bin/java: zlib
# libjvm.so:     libstdc++
# libc6

FROM registry.access.redhat.com/ubi8/ubi-micro:latest

COPY --from=builder /tmp/micro/ /

ARG  jre=jre
ARG  jar=app.jar
ARG  lib=lib

COPY /${jre}    /deployments/jre
ENV  JAVA_HOME  /deployments/jre

COPY /${jar}    /deployments/app.jar
COPY /${lib}    /deployments/lib
COPY run.sh     /deployments

WORKDIR /deployments
CMD     ./run.sh
