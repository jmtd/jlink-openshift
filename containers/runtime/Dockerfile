# Experimental runtime image builder. Requires 'spring-jre' and 'target'
# in current working directory when executing the build, e.g. (from the
# repository root):
#   podman build -t jlink-runtime containers/runtime/Dockerfile

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
    libstdc++

# dependencies so far:
# /usr/bin/java: zlib
# libjvm.so:     libstdc++

FROM registry.access.redhat.com/ubi8/ubi-micro:latest

COPY --from=builder /tmp/micro/ /

COPY spring-jre /deployments/spring-jre
ENV  JAVA_HOME  /deployments/spring-jre

COPY /target/spring-boot-sample-simple-1.5.0.BUILD-SNAPSHOT.jar /deployments
COPY /target/lib /deployments/lib

CMD  $JAVA_HOME/bin/java -cp $(cat /deployments/lib/classpath) /deployments/spring-boot-sample-simple-1.5.0.BUILD-SNAPSHOT.jar
