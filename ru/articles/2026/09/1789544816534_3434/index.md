---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'ClickHouse: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
  - 'inDev'
tags:
  - 'debian'
  - 'apt'
  - 'clickhouse'
  - 'database'
authors:
  - 'KaiKimera'
sources:
  - 'https://clickhouse.com/docs/get-started/setup/self-managed/debian-ubuntu'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2026-09-16T10:46:59+03:00'
publishDate: '2026-09-16T10:46:59+03:00'
lastMod: '2026-09-16T10:46:59+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '8385e0b901e209279a3efa7df4e6eb621f7af3b3'
uuid: '8385e0b9-01e2-5927-ba3e-fa7df4e6eb62'
slug: '8385e0b9-01e2-5927-ba3e-fa7df4e6eb62'

draft: 0
---

Инструкция по установке и настройке {{< tag "ClickHouse" >}}.

<!--more-->

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://packages.clickhouse.com/rpm/lts/repodata/repomd.xml.key' | gpg --dearmor -o '/etc/apt/keyrings/clickhouse.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/clickhouse.sources`:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: ClickHouse\nTypes: deb\nURIs: https://packages.clickhouse.com/deb\nSuites: stable\nComponents: main\nSigned-By: /etc/apt/keyrings/clickhouse.gpg\n" | tee '/etc/apt/sources.list.d/clickhouse.sources' > '/dev/null'
```

## Установка

```bash
apt update && apt install --yes clickhouse-server clickhouse-client
```
