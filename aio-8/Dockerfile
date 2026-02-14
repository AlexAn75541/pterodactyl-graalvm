# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Java 8 (Multi-vendor)
# Minimum Panel Version: 1.7.0
# ----------------------------------

# get JDK source
FROM eclipse-temurin:8-jdk AS temurin
FROM azul/zulu-openjdk:8 AS zulu
FROM amazoncorretto:8 AS corretto
FROM ibm-semeru-runtimes:open-8-jdk AS semeru
FROM bellsoft/liberica-openjdk-debian:8 AS liberica
FROM alibabadragonwell/dragonwell:8 AS dragonwell
FROM ghcr.io/graalvm/jdk:ol7-java8 AS graalvm-ce

# ---- Builder stage: assemble and strip all JDKs in one place ----
FROM debian:stable-slim AS jdk-builder

# Copy all JDKs into the builder
COPY --from=temurin         /opt/java/openjdk                              /opt/java/temurin
COPY --from=corretto        /usr/lib/jvm/java-1.8.0-amazon-corretto        /opt/java/corretto
COPY --from=semeru          /opt/java/openjdk                              /opt/java/semeru
COPY --from=dragonwell      /opt/java/openjdk                              /opt/java/dragonwell
COPY --from=graalvm-ce      /usr/lib64/graalvm/graalvm21-java8             /opt/java/graalvm-ce

# Zulu and Liberica use variable directory names
COPY --from=zulu      /usr/lib/jvm  /tmp/zulu-jvm
COPY --from=liberica  /usr/lib/jvm  /tmp/liberica-jvm

# Single RUN: move variable-named dirs, then strip ALL JDKs
RUN set -eux && \
    # Move Zulu
    ZULU_DIR=$(find /tmp/zulu-jvm -mindepth 1 -maxdepth 1 -type d | head -n1) && \
    if [ -n "$ZULU_DIR" ]; then \
        mv "$ZULU_DIR" /opt/java/zulu; \
    else \
        echo "ERROR: No Zulu JDK directory found!" && exit 1; \
    fi && \
    rm -rf /tmp/zulu-jvm && \
    \
    # Move Liberica
    LIBERICA_DIR=$(find /tmp/liberica-jvm -mindepth 1 -maxdepth 1 -type d | head -n1) && \
    if [ -n "$LIBERICA_DIR" ]; then \
        mv "$LIBERICA_DIR" /opt/java/liberica; \
    else \
        echo "ERROR: No Liberica JDK directory found!" && exit 1; \
    fi && \
    rm -rf /tmp/liberica-jvm && \
    \
    # Verify every JDK has a bin/java
    for jdk in temurin zulu corretto semeru liberica dragonwell; do \
        if [ ! -f "/opt/java/$jdk/bin/java" ]; then \
            echo "ERROR: /opt/java/$jdk/bin/java not found!" && exit 1; \
        fi; \
        echo "OK /opt/java/$jdk/bin/java"; \
    done && \
    \
    # Remove non-essential directories
    for dir in man demo sample legal jmods include; do \
        find /opt/java -type d -name "$dir" -exec rm -rf {} + 2>/dev/null || true; \
    done && \
    \
    # Remove non-essential files
    find /opt/java -type f \( -name "src.zip" -o -name "*.debuginfo" -o -name "*.diz" -o -name "*.map" \) -delete 2>/dev/null || true && \
    \
    # Strip debug symbols from shared libraries
    find /opt/java -type f \( -name "*.so" -o -name "*.so.*" \) -exec strip --strip-debug {} \; 2>/dev/null || true && \
    \
    # Log final sizes
    echo "=== Per-JDK sizes ===" && du -sh /opt/java/* && \
    echo "=== Total ===" && du -sh /opt/java

# ---- Final image ----
FROM debian:stable-slim

ARG TARGETARCH

LABEL       author="Aretzera" maintainer="agroup168@proton.me"
LABEL org.opencontainers.image.description="Java 8 Multi-vendor Image"

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN         apt-get update -y \
            && apt-get install -y --no-install-recommends curl ca-certificates openssl git tar sqlite3 fontconfig libfreetype6 libstdc++6 lsof build-essential tzdata iproute2 locales libnuma1 numactl \
            && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
            && locale-gen en_US.UTF-8 \
            && update-locale LANG=en_US.UTF-8 \
            && apt-get clean \
            && rm -rf /var/lib/apt/lists/* \
            && useradd -m -d /home/container container

# Copy all pre-stripped JDKs in a single layer
COPY --from=jdk-builder /opt/java /opt/java

ENV JDK_VENDOR=temurin

USER        container
ENV         USER=container HOME=/home/container

WORKDIR     /home/container

COPY        ./../entrypoint.sh /entrypoint.sh

CMD         ["/bin/bash", "/entrypoint.sh"]
