# jlink-openshift App builder

The first stage is to build a Java app. We use the [Red Hat OpenJDK
containers](https://github.com/jboss-container-images/openjdk) and [Source to
Image](http://github.com/openshift/source-to-image) to achieve this. See
`s2i.sh`.

You need to create a work directory with owner UID=185.
