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
COPY --from=graalvm  /usr/lib64/graalvm/graalvm-java21  /opt/java/graalvm
COPY --from=graalvm-ce  /usr/lib64/graalvm/graalvm-community-java21  /opt/java/graalvm-ce
COPY --from=graalvm-native  /usr/lib64/graalvm/graalvm-java21  /opt/java/graalvm-native
COPY --from=shenandoah  /opt/jdk/lib  /opt/java/shenandoah
COPY --from=zulu  /usr/lib/jvm  /tmp/zulu
COPY --from=corretto  /usr/lib/jvm/java-21-amazon-corretto  /opt/java/corretto
COPY --from=semeru  /opt/java/openjdk  /opt/java/semeru
COPY --from=liberica  /usr/lib/jvm  /tmp/liberica
COPY --from=dragonwell  /opt/java/openjdk  /opt/java/dragonwell

# Move arch-specific JDKs to final location
RUN mv /tmp/zulu/zulu-21-* /opt/java/zulu && \
    mv /tmp/liberica/*bellsoft* /opt/java/liberica && \
    rm -rf /tmp/zulu /tmp/liberica

# Cleanup all JDKs - remove docs, sources, demos, and debug files
RUN for jdk_dir in /opt/java/*; do \
        if [ -d "$jdk_dir" ]; then \
            cd "$jdk_dir" && \
            rm -rf man/ demo/ sample/ src.zip lib/src.zip legal/ jmods/ include/ 2>/dev/null || true && \
            find . -type f \( -name "*.debuginfo" -o -name "*.diz" \) -delete 2>/dev/null || true; \
        fi; \
    done

# JVM_RUNTIME is the arg to set the type of jdk to be launched, defaulted to temurin
ENV JVM_RUNTIME=temurin

USER        container
ENV         USER=container HOME=/home/container

WORKDIR     /home/container

COPY        ./../entrypoint.sh /entrypoint.sh

CMD         ["/bin/bash", "/entrypoint.sh"]