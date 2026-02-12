# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Java (GraalVM + Temurin)
# Minimum Panel Version: 1.7.0
# ----------------------------------

# get JDK source, woah thats alot of stuff
FROM eclipse-temurin:21-jdk AS temurin
FROM container-registry.oracle.com/graalvm/jdk:21 AS graalvm
FROM ghcr.io/graalvm/jdk-community:21.0.2 AS graalvm-ce
FROM container-registry.oracle.com/graalvm/native-image:21 AS graalvm-native
FROM shipilev/openjdk:21 AS shenandoah


FROM azul/zulu-openjdk:21 AS zulu
FROM amazoncorretto:21 AS corretto
FROM ibm-semeru-runtimes:open-21-jdk AS semeru
FROM bellsoft/liberica-openjdk-debian:21 AS liberica
FROM alibabadragonwell/dragonwell:21 AS dragonwell

# base image
FROM debian:stable-slim

ARG TARGETARCH

LABEL       author="Aretzera" maintainer="agroup168@proton.me"
LABEL org.opencontainers.image.description="Experimental Image btw"

ENV DEBIAN_FRONTEND=noninteractive

# Default to UTF-8 file.encoding
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN         apt-get update -y \
            && apt-get install -y --no-install-recommends curl ca-certificates openssl git tar sqlite3 python3 fontconfig libfreetype6 libstdc++6 lsof build-essential tzdata iproute2 locales libnuma1 numactl \
            && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
            && locale-gen en_US.UTF-8 \
            && update-locale LANG=en_US.UTF-8 \
            && apt-get clean \
            && rm -rf /var/lib/apt/lists/* \
            && useradd -m -d /home/container container

# Copy both JDKs, i downloaded them all and check them in Docker Desktop
COPY --from=temurin  /opt/java/openjdk   /opt/java/temurin
RUN rm -rf /opt/java/temurin/man /opt/java/temurin/demo /opt/java/temurin/sample \
           /opt/java/temurin/src.zip /opt/java/temurin/lib/src.zip /opt/java/temurin/legal \
           /opt/java/temurin/jmods /opt/java/temurin/include

COPY --from=graalvm  /usr/lib64/graalvm/graalvm-java21  /opt/java/graalvm
RUN rm -rf /opt/java/graalvm/man /opt/java/graalvm/legal /opt/java/graalvm/lib/src.zip

COPY --from=graalvm-ce  /usr/lib64/graalvm/graalvm-community-java21  /opt/java/graalvm-ce
RUN rm -rf /opt/java/graalvm-ce/man /opt/java/graalvm-ce/legal /opt/java/graalvm-ce/lib/src.zip

COPY --from=graalvm-native  /usr/lib64/graalvm/graalvm-java21  /opt/java/graalvm-native
RUN rm -rf /opt/java/graalvm-native/man /opt/java/graalvm-native/legal /opt/java/graalvm-native/lib/src.zip

COPY --from=shenandoah  /opt/jdk/lib  /opt/java/shenandoah
RUN rm -rf /opt/java/shenandoah/src.zip

COPY --from=zulu  /usr/lib/jvm  /tmp/zulu-jvm
RUN find /tmp/zulu-jvm -maxdepth 1 -type d -name "zulu-21-*" -exec mv {} /opt/java/zulu \; && \
    rm -rf /tmp/zulu-jvm /opt/java/zulu/man /opt/java/zulu/demo /opt/java/zulu/sample

COPY --from=corretto  /usr/lib/jvm/java-21-amazon-corretto  /opt/java/corretto
RUN rm -rf /opt/java/corretto/man /opt/java/corretto/legal /opt/java/corretto/lib/src.zip

COPY --from=semeru  /opt/java/openjdk  /opt/java/semeru
RUN rm -rf /opt/java/semeru/man /opt/java/semeru/demo /opt/java/semeru/sample /opt/java/semeru/legal

COPY --from=liberica  /usr/lib/jvm  /tmp/liberica-jvm
RUN find /tmp/liberica-jvm -maxdepth 1 -type d -name "*bellsoft*" -exec mv {} /opt/java/liberica \; && \
    rm -rf /tmp/liberica-jvm /opt/java/liberica/man /opt/java/liberica/legal

COPY --from=dragonwell  /opt/java/openjdk  /opt/java/dragonwell
RUN rm -rf /opt/java/dragonwell/man /opt/java/dragonwell/demo /opt/java/dragonwell/sample /opt/java/dragonwell/legal

# Final cleanup - remove any remaining cruft
RUN find /opt/java -type f \( -name "*.debuginfo" -o -name "*.diz" \) -delete && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# JVM_RUNTIME is the arg to set the type of jdk to be launched, defaulted to temurin
ENV JVM_RUNTIME=temurin

USER        container
ENV         USER=container HOME=/home/container

WORKDIR     /home/container

COPY        ./../entrypoint.sh /entrypoint.sh

CMD         ["/bin/bash", "/entrypoint.sh"]