# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Java (GraalVM + Temurin)
# Minimum Panel Version: 1.7.0
# ----------------------------------

# get JDK source
FROM eclipse-temurin:21-jdk AS temurin
FROM ghcr.io/graalvm/jdk-community:21.0.2 AS graalvm

# base image
FROM debian:latest

LABEL       author="Aretzera" maintainer="agroup168@proton.me"
LABEL org.opencontainers.image.description="Experimental Image btw"

ENV DEBIAN_FRONTEND=noninteractive

# Default to UTF-8 file.encoding
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN         apt-get update -y \
            && apt-get install -y --no-install-recommends curl ca-certificates openssl git tar sqlite3 fontconfig libfreetype6 libstdc++6 lsof build-essential tzdata iproute2 locales \
            && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
            && locale-gen en_US.UTF-8 \
            && update-locale LANG=en_US.UTF-8 \
            && apt-get clean \
            && rm -rf /var/lib/apt/lists/* \
            && useradd -m -d /home/container container

# Copy both JDKs, i downloaded them all and check them in Docker Desktop
COPY --from=temurin  /opt/java/openjdk   /opt/java/temurin
COPY --from=graalvm  /usr/lib64/graalvm/graalvm-community-java21  /opt/java/graalvm

# JVM_RUNTIME is the arg to set the type of jdk to be launched, defaulted to graalvm
ENV JVM_RUNTIME=graalvm

USER        container
ENV         USER=container HOME=/home/container

WORKDIR     /home/container

COPY        ./../entrypoint.sh /entrypoint.sh

CMD         ["/bin/bash", "/entrypoint.sh"]