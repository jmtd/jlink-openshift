# jlink-openshift Baseline

This script uses S2I to build a Java web application using the
traditional S2I workflow which layers the result on top of the
builder image.

We use the [Red Hat OpenJDK
containers](https://github.com/jboss-container-images/openjdk) as
the builder image and [Source to
Image](http://github.com/openshift/source-to-image).

We specify the following environment variables to tune the build:

 * **S2I_DELETE_SOURCE=true, MAVEN_CLEAR_REPO=true**
   * these reduce the resulting image size by removing the source
     and intermediate build artefacts.
 * **QUARKUS_PACKAGE_TYPE=uber-jar, MAVEN_S2I_ARTIFACT_DIRS=target, S2I_SOURCE_DEPLOYMENTS_FILTER="*.jar", JAVA_APP_JAR=**
   * These are necessary to override alternative values supplied by the
     application sources in the `.s2i/environment` file which otherwise
     configure the image for the `fast-jar` build layout.
 
