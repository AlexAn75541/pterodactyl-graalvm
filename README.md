
![license mit](https://img.shields.io/badge/license-MIT-green) 
[![build graalvm](https://github.com/AlexAn75541/pterodactyl-graalvm/actions/workflows/docker-image.yml/badge.svg)](https://github.com/AlexAn75541/pterodactyl-graalvm/actions/workflows/docker-image.yml)

GraalVM is a high-performance runtime that provides significant improvements in application performance and efficiency which is ideal for microservices. https://www.graalvm.org/


This repo will be having many unofficial ptedrodactyl build, I do not have any affiliate with rikodev, I just make this repo for my personal use lol 🧐

___

## Docker Container Configuration

| Java | Standard                               	     | JDK (Mostly CE Build)                              | Enterprise                                      |
|------	|--------------------------------------------- |--------------------------------------------------- |------------------------------------------------ |
| 11    | `ghcr.io/alexan75541/pterodactyl-graalvm:11` | ❌                                          	    | `ghcr.io/alexan75541/pterodactyl-graalvm:11-EE` |
| 17    | `ghcr.io/alexan75541/pterodactyl-graalvm:17` | `ghcr.io/alexan75541/pterodactyl-graalvm:17-JDK` 	| `ghcr.io/alexan75541/pterodactyl-graalvm:17-EE` |
| 19   	| `ghcr.io/alexan75541/pterodactyl-graalvm:19` | ❌                                          	    | ❌                                         	  |
| 20   	| ❌                                     	   | `ghcr.io/alexan75541/pterodactyl-graalvm:20-JDK` 	| ❌                                         	  |
| 21   	| ❌                                           | `ghcr.io/alexan75541/pterodactyl-graalvm:21-JDK`*  | ❌                                         	  |
| 22    | ❌                                     	   | `ghcr.io/alexan75541/pterodactyl-graalvm:22-JDK` 	| ❌                                         	  |

*Additional configuration using JDK21 from Oracle's GraalVM (Trust me this one is almost the same as GraalVM Enterprise): `ghcr.io/alexan75541/pterodactyl-graalvm:21-JDK-2`
___

yay