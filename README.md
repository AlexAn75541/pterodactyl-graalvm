
![license mit](https://img.shields.io/badge/license-MIT-green) 
[![build graalvm](https://github.com/AlexAn75541/pterodactyl-graalvm/actions/workflows/docker-image.yml/badge.svg)](https://github.com/AlexAn75541/pterodactyl-graalvm/actions/workflows/docker-image.yml)

# Pterodactyl Multi-Vendor JDK Images

Docker images for Pterodactyl Panel with multiple JDK vendors in a single container. Switch between vendors at runtime using the `JVM_RUNTIME` environment variable.

## Available Images

| Java Version | Image Tag | Included JDK Vendors |
|--------------|-----------|---------------------|
| **8** | `ghcr.io/alexan75541/pterodactyl-graalvm:aio-8` | Temurin, Zulu, Corretto, Semeru, Liberica, Dragonwell |
| **11** | `ghcr.io/alexan75541/pterodactyl-graalvm:aio-11` | Temurin, Zulu, Corretto, Semeru, Liberica, Dragonwell |
| **17** | `ghcr.io/alexan75541/pterodactyl-graalvm:aio-17` | Temurin, **GraalVM (3 variants)**, Zulu, Corretto, Semeru, Liberica, Dragonwell |
| **21** | `ghcr.io/alexan75541/pterodactyl-graalvm:aio-21` | Temurin, **GraalVM (3 variants)**, Zulu, Corretto, Semeru, Liberica, Dragonwell, Shenandoah |
| **25** | `ghcr.io/alexan75541/pterodactyl-graalvm:aio-25` | Temurin, Zulu, Liberica _(limited vendor support)_ |

## Main Features

**Multi-Architecture Support:** linux/amd64 (x86_64) and linux/arm64 (aarch64)

**Multiple JDK Vendors supported:**
- **Temurin** - Eclipse Adoptium OpenJDK, standard and widely trusted
- **GraalVM** - Oracle GraalVM JDK with high-performance JIT compiler. Variants: `graalvm`, `graalvm-ce` (Community Edition), `graalvm-native` (with Native Image support)
- **Shenandoah** - Ultra-low pause time GC - though some vendors here already has Shenandoah GC built-in
- **Zulu** - Azul's certified OpenJDK build
- **Corretto** - Amazon's production-grade OpenJDK
- **Semeru** - IBM's OpenJ9-based runtime
- **Liberica** - BellSoft's feature-complete OpenJDK distribution
- **Dragonwell** - Alibaba's optimized OpenJDK for production workloads

> [!CAUTION]
> Note that some Java version will not be available in some vendors(Will notice this later)

**Kinda Optimized the Image with:**
- Bare JDK(not JRE) with `javac`, `jshell`, `jar`, `jlink`, etc (ofc `java` is always included)
- Stripped debug symbols for smaller size
- Removed docs, samples, demos
- Single-layer final copy for efficient caching(post image building process)

## How to Use In Pterodactyl Panel(or anywhere else)

**1. Set Docker Image in Pterodactyl Egg:**
```json
{
  "docker_image": "ghcr.io/alexan75541/pterodactyl-graalvm:aio-{YOUR DESIRED VERSION}"
}
```

**2. Add function to switch JDK Vendors for users:**

> [!NOTE]
> Without this variable, the image will default on Temurin's JDK for the best compatibility as possible.
> If you want to use this image without the Panel, besure to set the `JVM_RUNTIME` as an environment variable(obviously).
> For example: `docker run -e JVM_RUNTIME=zulu ghcr.io/alexan75541/pterodactyl-graalvm:aio-21`.

Add the `JVM_RUNTIME` environment variable in Pterodactyl Panel:
- Go to your server → Startup
- Add/edit the `JVM_RUNTIME` variable
- Set value: `temurin` (default), `graalvm`, `graalvm-ce`, `graalvm-native`, `shenandoah`, `zulu`, `corretto`, `semeru`, `liberica`, or `dragonwell`
- Stop THEN start the server

## License and Contributing

MIT License - See LICENSE file

Issues and PRs welcome! This repo is maintained for personal use but shared with the community(if they care lol).

**Credits:**
- GraalVM: https://www.graalvm.org/
- Pterodactyl Panel: https://pterodactyl.io/
- [RikoDEV's GraalVM Pterodactyl Docker Image Repo](https://github.com/RikoDEV/pterodactyl-graalvm)
- [THE OG YOLK](https://github.com/pterodactyl/yolks)
- [trenutoo's Pterodactyl Docker Image Repo](https://github.com/trenutoo/pterodactyl-images/)
- All JDK vendors for their amazing work so far and I hope that I won't get killed by them


