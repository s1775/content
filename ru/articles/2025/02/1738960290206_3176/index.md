---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Caddy: Установка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'caddy'
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

date: '2025-02-07T23:31:30+03:00'
publishDate: '2025-02-07T23:31:30+03:00'
lastMod: '2025-02-07T23:31:30+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'b0b74e5bd8a4f9067c86e4e5d9c5d2e37eca0b1b'
uuid: 'b0b74e5b-d8a4-5906-ac86-e4e5d9c5d2e3'
slug: 'b0b74e5b-d8a4-5906-ac86-e4e5d9c5d2e3'

draft: 1
---

Summary...

<!--more-->

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o '/etc/apt/keyrings/caddy.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/caddy.sources`:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: Caddy\nTypes: deb\nURIs: https://dl.cloudsmith.io/public/caddy/stable/deb/${ID}\nSuites: any-version\nComponents: main\nSigned-By: /etc/apt/keyrings/caddy.gpg\n" | tee '/etc/apt/sources.list.d/caddy.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes caddy
```
