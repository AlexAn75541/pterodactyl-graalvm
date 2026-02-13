
![license mit](https://img.shields.io/badge/license-MIT-green) 
[![build status](https://github.com/AlexAn75541/pterodactyl-aio-jdk/actions/workflows/docker-image.yml/badge.svg?branch=master)](https://github.com/AlexAn75541/pterodactyl-aio-jdk/actions/workflows/docker-image.yml)

# Pterodactyl JDK Images with (almost) all of the Vendors

Docker images for Pterodactyl Panel with multiple JDK vendors in a single container. Switch between vendors at runtime using the `JDK_VENDOR` environment variable.

## Available Images

| Java Version | Image Tag | Included JDK Vendors |
|--------------|-----------|---------------------|
| **8** | `ghcr.io/alexan75541/pterodactyl-graalvm:aio-8` | Temurin, Zulu, Corretto, Semeru, Liberica, Dragonwell |
| **11** | `ghcr.io/alexan75541/pterodactyl-graalvm:aio-11` | Temurin, Zulu, Corretto, Semeru, Liberica, Dragonwell |
| **17** | `ghcr.io/alexan75541/pterodactyl-graalvm:aio-17` | Temurin, **GraalVM (all 3 variants)**, Zulu, Corretto, Semeru, Liberica, Dragonwell |
| **21** | `ghcr.io/alexan75541/pterodactyl-graalvm:aio-21` | Temurin, **GraalVM (all 3 variants)**, Zulu, Corretto, Semeru, Liberica, Dragonwell, Shenandoah |
| **25** | `ghcr.io/alexan75541/pterodactyl-graalvm:aio-25` | Temurin, Zulu, Liberica, **GraalVM (all 3 variants)**  |


## Main Features

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
> Note that some Java version will not be available in some vendors (Look at the Included JDK Vendors for each Java version)

**Kinda Optimized the Image with:**
- Bare JDK(not JRE) with `javac`, `jshell`, `jar`, `jlink`, etc (ofc `java` is always included)
- Stripped debug symbols for smaller size
- Removed docs, samples, demos
- Single-layer final copy for efficient caching(post image building process)

## How to Use


### Add the `JDK_VENDOR` environment variable in Pterodactyl Panel:

> [!NOTE]
> Without this variable, the image will default on Temurin's JDK for the best compatibility as possible.
> If you want to use this image without the Panel, besure to set the `JDK_VENDOR` as an environment variable(obviously).
> For example: `docker run -e JDK_VENDOR=zulu ghcr.io/alexan75541/pterodactyl-graalvm:aio-21`.

- Go to Pterodactyl Admin Panel → Minecraft Nest → {Any Egg you wish to edit}
- Go to Variables -> Create New Variable
- Enter your name and description of choice
- Add the `JDK_VENDOR` to the Environment Variable box
- You can use any Input value in this list: `temurin` (default), `graalvm`, `graalvm-ce`, `graalvm-native`, `shenandoah`, `zulu`, `corretto`, `semeru`, `liberica`, or `dragonwell` → as long as the rule are `required|string|max:20`
- Go on click Create Variable
- Stop THEN start the server, or Reinstall if unsure

Alternatively, you can use the `egg-paper.json` in my repo, or put this in your `{whatever egg that is}.json` :

```
{
            "name": "JDK Vendor",
            "description": "The JDK vendor to use for running the server.\r\n\r\nOptions: `temurin`, `graalvm`, `graalvm-native`, `graalvm-ce`, `zulu`, `liberica`, `corretto`, `semeru`, `shenandoah`, `dragonwell`",
            "env_variable": "JDK_VENDOR",
            "default_value": "temurin",
            "user_viewable": true,
            "user_editable": true,
            "rules": "required|string|in:temurin,graalvm,graalvm-native,graalvm-ce,zulu,liberica,corretto,semeru,shenandoah,dragonwell",
            "field_type": "text"
}

```

Along with the list of Java version if you want:

```
"docker_images": {
        "Java 8": "ghcr.io\/alexan75541\/pterodactyl-aio-jdk:aio-8",
        "Java 11": "ghcr.io\/alexan75541\/pterodactyl-aio-jdk:aio-11",
        "Java 17": "ghcr.io\/alexan75541\/pterodactyl-aio-jdk:aio-17",
        "Java 21": "ghcr.io\/alexan75541\/pterodactyl-aio-jdk:aio-21",
        "Java 25": "ghcr.io\/alexan75541\/pterodactyl-aio-jdk:aio-25"
```

## License and Contributing

**MIT License - See LICENSE file**

By using Oracle's registry in this repository, I, Aretzera(AlexAn75541) or maybe users of this repository, comply to [GraalVM Free Terms and Conditions (GFTC)](https://www.oracle.com/downloads/licenses/graal-free-license.html).

Moreover, this project includes the following JDK distributions:
- **Eclipse Temurin**: GPLv2 
- **Azul Zulu**: GPLv2   
- **BellSoft Liberica**: GPLv2  
- **GraalVM Community Edition**: GPLv2
- *(And Other vendors...)*

All JDK distributions are used in accordance with their respective licenses.

### Issues and PRs welcome! This repo is maintained for personal use but shared with the community(if they care lol).

**Credits:**

- Pterodactyl Panel: https://pterodactyl.io/
- [RikoDEV's GraalVM Pterodactyl Docker Image Repo](https://github.com/RikoDEV/pterodactyl-graalvm)
- [THE OG YOLK](https://github.com/pterodactyl/yolks)
- [trenutoo's Pterodactyl Docker Image Repo](https://github.com/trenutoo/pterodactyl-images/)
- And all JDK vendors for their amazing work so far and I hope that I won't get killed by them


**Credits:**
- GraalVM: https://www.graalvm.org/
- Pterodactyl Panel: https://pterodactyl.io/
- All JDK vendors for their amazing work so far and I hope that I won't get killed by this
