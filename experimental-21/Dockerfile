# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Java (GraalVM + Temurin)
# Minimum Panel Version: 1.7.0
# ----------------------------------

# get JDK source, woah thats alot of stuff
FROM eclipse-temurin:21-jdk AS temurin
RUN cd /opt/java/openjdk && rm -rf man/ demo/ sample/ src.zip legal/ jmods/ && find . -name "*.debuginfo" -delete -o -name "*.diz" -delete

FROM container-registry.oracle.com/graalvm/jdk:21 AS graalvm
RUN cd /usr/lib64/graalvm/graalvm-java21 && rm -rf man/ demo/ sample/ lib/src.zip legal/ jmods/ && find . -name "*.debuginfo" -delete -o -name "*.diz" -delete

FROM ghcr.io/graalvm/jdk-community:21.0.2 AS graalvm-ce
RUN cd /usr/lib64/graalvm/graalvm-community-java21 && rm -rf man/ demo/ sample/ lib/src.zip legal/ jmods/ && find . -name "*.debuginfo" -delete -o -name "*.diz" -delete

FROM container-registry.oracle.com/graalvm/native-image:21 AS graalvm-native
RUN cd /usr/lib64/graalvm/graalvm-java21 && rm -rf man/ demo/ sample/ lib/src.zip legal/ jmods/ && find . -name "*.debuginfo" -delete -o -name "*.diz" -delete

FROM shipilev/openjdk:21 AS shenandoah
RUN cd /opt/jdk && rm -rf man/ demo/ sample/ lib/src.zip legal/ jmods/ && find . -name "*.debuginfo" -delete -o -name "*.diz" -delete

FROM azul/zulu-openjdk:21 AS zulu
RUN cd /usr/lib/jvm && \
    ZULU_DIR=$(ls -d zulu-21-* 2>/dev/null | head -1) && \
    cd "${ZULU_DIR}" && \
    rm -rf man/ demo/ sample/ lib/src.zip legal/ jmods/ && \
    find . -name "*.debuginfo" -delete -o -name "*.diz" -delete

FROM amazoncorretto:21 AS corretto
RUN cd /usr/lib/jvm/java-21-amazon-corretto && rm -rf man/ demo/ sample/ lib/src.zip legal/ jmods/ && find . -name "*.debuginfo" -delete -o -name "*.diz" -delete

FROM ibm-semeru-runtimes:open-21-jdk AS semeru
RUN cd /opt/java/openjdk && rm -rf man/ demo/ sample/ lib/src.zip legal/ jmods/ && find . -name "*.debuginfo" -delete -o -name "*.diz" -delete

FROM bellsoft/liberica-openjdk-debian:21 AS liberica
RUN cd /usr/lib/jvm && \
    LIBERICA_DIR=$(ls -d *bellsoft* 2>/dev/null | head -1) && \
    cd "${LIBERICA_DIR}" && \
    rm -rf man/ demo/ sample/ lib/src.zip legal/ jmods/ && \
    find . -name "*.debuginfo" -delete -o -name "*.diz" -delete

FROM alibabadragonwell/dragonwell:21 AS dragonwell
RUN cd /opt/java/openjdk && rm -rf man/ demo/ sample/ lib/src.zip legal/ jmods/ && find . -name "*.debuginfo" -delete -o -name "*.diz" -delete

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


# ARCH: {foldername}-amd64 (x64) or {foldername}-aarch64 (arm64)
RUN --mount=type=bind,from=zulu,source=/usr/lib/jvm,target=/tmp/zulu \
    ZULU_ARCH=$(case "${TARGETARCH}" in amd64) echo "amd64" ;; arm64) echo "aarch64" ;; *) echo "amd64" ;; esac) && \
    cp -r /tmp/zulu/zulu-21-${ZULU_ARCH} /opt/java/zulu


COPY --from=corretto  /usr/lib/jvm/java-21-amazon-corretto  /opt/java/corretto
COPY --from=semeru  /opt/java/openjdk  /opt/java/semeru


# ARCH: {foldername}-x86_64 (x64) or {foldername}-aarch64 (arm64), ts is so tuff
RUN --mount=type=bind,from=liberica,source=/usr/lib/jvm,target=/tmp/liberica \
    LIBERICA_ARCH=$(case "${TARGETARCH}" in amd64) echo "x86_64" ;; arm64) echo "aarch64" ;; *) echo "x86_64" ;; esac) && \
    cp -r /tmp/liberica/*bellsoft-${LIBERICA_ARCH} /opt/java/liberica

COPY --from=dragonwell  /opt/java/openjdk  /opt/java/dragonwell


# JVM_RUNTIME is the arg to set the type of jdk to be launched, defaulted to temurin
ENV JVM_RUNTIME=temurin

USER        container
ENV         USER=container HOME=/home/container

WORKDIR     /home/container

COPY        ./../entrypoint.sh /entrypoint.sh

CMD         ["/bin/bash", "/entrypoint.sh"]