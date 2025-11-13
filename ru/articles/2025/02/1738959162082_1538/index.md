---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Eclipse Temurin: Установка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'eclipse'
  - 'temurin'
  - 'adoptium'
  - 'install'
authors:
  - 'KaiKimera'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2025-02-07T23:12:42+03:00'
publishDate: '2025-02-07T23:12:42+03:00'
lastMod: '2025-02-07T23:12:42+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '5c0145cf8d36cf8095ec98bd13539df574a42282'
uuid: '5c0145cf-8d36-5f80-b5ec-98bd13539df5'
slug: '5c0145cf-8d36-5f80-b5ec-98bd13539df5'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "Temurin" >}}.

<!--more-->

## Экспорт параметров

- Экспортировать заранее подготовленные параметры в переменные окружения:

```bash
export JDK_VER='21-jdk'
```

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://packages.adoptium.net/artifactory/api/gpg/key/public' | gpg --dearmor -o '/etc/apt/keyrings/adoptium.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/adoptium.sources`:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: Eclipse Temurin\nTypes: deb\nURIs: https://packages.adoptium.net/artifactory/deb\nSuites: ${VERSION_CODENAME}\nComponents: main\nSigned-By: /etc/apt/keyrings/adoptium.gpg\n" | tee '/etc/apt/sources.list.d/adoptium.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install temurin-${JDK_VER}
```
