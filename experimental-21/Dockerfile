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

# ---- Builder stage: assemble and strip all JDKs in one place ----
# This avoids layer bloat — each COPY+RUN pair in the old approach kept
# the unstripped JDK in a cached layer, doubling disk usage during build.
FROM debian:stable-slim AS jdk-builder

# Copy all JDKs into the builder
COPY --from=temurin         /opt/java/openjdk                              /opt/java/temurin
COPY --from=graalvm         /usr/lib64/graalvm/graalvm-java21              /opt/java/graalvm
COPY --from=graalvm-ce      /usr/lib64/graalvm/graalvm-community-java21    /opt/java/graalvm-ce
COPY --from=graalvm-native  /usr/lib64/graalvm/graalvm-java21              /opt/java/graalvm-native
COPY --from=shenandoah      /opt/jdk                                       /opt/java/shenandoah
COPY --from=corretto        /usr/lib/jvm/java-21-amazon-corretto           /opt/java/corretto
COPY --from=semeru          /opt/java/openjdk                              /opt/java/semeru
COPY --from=dragonwell      /opt/java/openjdk                              /opt/java/dragonwell

# Zulu and Liberica use variable directory names, handle them
COPY --from=zulu      /usr/lib/jvm  /tmp/zulu-jvm
COPY --from=liberica  /usr/lib/jvm  /tmp/liberica-jvm

# Single RUN: move variable-named dirs, then strip ALL JDKs in one pass.
# Keeps bin/ and lib/ intact (javac, jlink, jshell, jar, jfr, native-image, etc.)
RUN set -eux && \
    # Move Zulu (variable name pattern)
    find /tmp/zulu-jvm -mindepth 1 -maxdepth 1 -type d -name "zulu-*" -exec mv {} /opt/java/zulu \; && \
    rm -rf /tmp/zulu-jvm && \

    # Move Liberica (variable name pattern)
    find /tmp/liberica-jvm -mindepth 1 -maxdepth 1 -type d -name "*bellsoft*" -exec mv {} /opt/java/liberica \; && \
    rm -rf /tmp/liberica-jvm && \

    # Verify all JDK bin directories exist before cleanup
    echo "=== Verifying JDK bin directories ===" && \
    for jdk in temurin graalvm graalvm-ce graalvm-native shenandoah zulu corretto semeru liberica dragonwell; do \
        if [ ! -d "/opt/java/$jdk/bin" ]; then \
            echo "ERROR: /opt/java/$jdk/bin not found!" && \
            ls -la /opt/java/$jdk/ || echo "JDK directory does not exist" && \
            exit 1; \
        fi; \
        echo "✓ /opt/java/$jdk/bin exists"; \
    done && \

    # Remove non-essential directories using simple wildcard expansion (safer than complex find)
    rm -rf /opt/java/*/man /opt/java/*/demo /opt/java/*/sample /opt/java/*/legal /opt/java/*/jmods /opt/java/*/include 2>/dev/null || true && \

    # Remove non-essential files
    find /opt/java -type f \( -name "src.zip" -o -name "*.debuginfo" -o -name "*.diz" -o -name "*.map" \) -delete 2>/dev/null || true && \

    # Strip debug symbols from shared libraries — saves ~30-40% on .so files  
    find /opt/java -type f \( -name "*.so" -o -name "*.so.*" \) -exec strip --strip-debug {} \; 2>/dev/null || true && \
    
    # Log final sizes for CI debugging
    echo "=== Per-JDK sizes ===" && du -sh /opt/java/* && \
    echo "=== Total ===" && du -sh /opt/java

# ---- Final image ----
FROM debian:stable-slim

ARG TARGETARCH

LABEL       author="Aretzera" maintainer="agroup168@proton.me"
LABEL org.opencontainers.image.description="Experimental Image btw"

ENV DEBIAN_FRONTEND=noninteractive

# Default to UTF-8 file.encoding
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN         apt-get update -y \
            && apt-get install -y --no-install-recommends curl ca-certificates openssl git tar sqlite3 fontconfig libfreetype6 libstdc++6 lsof build-essential tzdata iproute2 locales libnuma1 numactl \
            && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
            && locale-gen en_US.UTF-8 \
            && update-locale LANG=en_US.UTF-8 \
            && apt-get clean \
            && rm -rf /var/lib/apt/lists/* \
            && useradd -m -d /home/container container

# Copy all pre-stripped JDKs in a single layer from the builder
COPY --from=jdk-builder /opt/java /opt/java

# JVM_RUNTIME is the arg to set the type of jdk to be launched, defaulted to temurin
ENV JVM_RUNTIME=temurin

USER        container
ENV         USER=container HOME=/home/container

WORKDIR     /home/container

COPY        ./../entrypoint.sh /entrypoint.sh

CMD         ["/bin/bash", "/entrypoint.sh"]