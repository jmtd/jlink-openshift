# jlink-openshift App runner

A very bare-bones runtime container for Java applications. The Dockerfile performs
a multi-stage build, assembling the runtime environment from a Red Hat UBI 8
minimal image, and copying it into a Red Hat UBI 8 micro image.

## usage

Copy a directory containing a stripped OpenJDK (such as prepared by the [jlink
container](../jlink)) to a subdirectory e.g. "jre", the application JAR to run
to a file e.g. "app.jar", and any supporting libraries to a subdirectory e.g.
"lib", then:
 
        podman build -t runtime --build-arg jre=jre --build-arg jar=app.jar --build-arg lib=lib ./

Then launch as usual

        podman run --rm -ti runtime
