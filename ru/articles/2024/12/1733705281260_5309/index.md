---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'HAProxy: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'cat_01'
  - 'cat_02'
  - 'cat_03'
tags:
  - 'tag_01'
  - 'tag_02'
  - 'tag_03'
authors:
  - 'JohnDoe'
  - 'JaneDoe'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-12-09T03:48:02+03:00'
publishDate: '2024-12-09T03:48:02+03:00'
lastMod: '2024-12-09T03:48:02+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '5fe150c1984f4dde047b84136704fef2c61bb252'
uuid: '5fe150c1-984f-5dde-a47b-84136704fef2'
slug: '5fe150c1-984f-5dde-a47b-84136704fef2'

draft: 1
---

Summary...

<!--more-->

## Репозиторий

### GPG

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://haproxy.debian.net/bernat.debian.org.gpg' | gpg --dearmor -o '/etc/apt/keyrings/haproxy.gpg'
```

### APT

- Создать файл репозитория `/etc/apt/sources.list.d/haproxy.sources`:

```bash
v='3.0'; . '/etc/os-release' && echo -e "X-Repolib-Name: HAProxy\nTypes: deb\nURIs: http://haproxy.debian.net\nSuites: ${VERSION_CODENAME}-backports-${v}\nComponents: main\nSigned-By: /etc/apt/keyrings/haproxy.gpg\n" | tee '/etc/apt/sources.list.d/haproxy.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
v='3.0'; apt update && apt install --yes haproxy=${v}.\*
```

## Настройка

{{< file "haproxy.cfg" >}}
