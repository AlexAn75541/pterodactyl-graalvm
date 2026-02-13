
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

**GraalVM Variants (Java 17, 21):**
- `graalvm` - Oracle GraalVM JDK
- `graalvm-ce` - GraalVM Community Edition  
- `graalvm-native` - GraalVM with Native Image support

**Optimized Image:**
- Bare JDK(not JRE) with javac, jshell, jar, jlink, etc
- Stripped debug symbols for smaller size
- Removed docs, samples, demos
- Single-layer final copy for efficient caching

## How to Use In Pterodactyl Panel

**1. Set Docker Image in Pterodactyl Egg:**
```json
{
  "docker_image": "ghcr.io/alexan75541/pterodactyl-graalvm:aio-{YOUR DESIRED VERSION}"
}
```

**2. Add function to switch JDK Vendors for users:**

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
- All JDK vendors for their amazing work so far and I hope that I won't get killed by this
