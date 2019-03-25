FROM alpine:3.9 AS download
RUN apk add curl libarchive-tools
RUN curl -OL https://github.com/broadinstitute/picard/releases/download/2.18.29/picard.jar

FROM alpine:3.9 AS download-openjdk
RUN apk add curl libarchive-tools
RUN curl -OL https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u202-b08/OpenJDK8U-jre_x64_linux_hotspot_8u202b08.tar.gz
RUN tar xzf OpenJDK8U-jre_x64_linux_hotspot_8u202b08.tar.gz

FROM debian:jessie-slim
COPY --from=download-openjdk /jdk8u202-b08-jre /opt/openjdk8
COPY --from=download /picard.jar /opt/picard.jar
ENV JAVA_OPTIONS -Xmx4g
RUN echo '/opt/openjdk8/bin/java ${JAVA_OPTIONS} -jar /opt/picard.jar "${@}"' > /usr/bin/picard && chmod +x /usr/bin/picard
