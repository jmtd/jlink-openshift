The intention here is to build a container with OpenJDK installed
which was built against, and links against, the same version of
libc as in the eventual target image.

## Usage

### building

    podman build -t jlink ./

### running

Assuming you have the following defined locally:

 * `$jarfile`, a local web application JAR
 * `$libdir`, directory containing auxillary Java libraries (JARs) for the above
 * `$outputjre`, where to write the stripped JRE

Invoke as follows

    podman run --rm -ti \
        -v "$jarfile":/tmp/run/app.jar \
        -v "$libdir":/tmp/run/lib \
        -v "$outputjre":/tmp/run/out \
        jlink
