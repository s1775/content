---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'TimescaleDB: Установка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'timescale'
  - 'timescaledb'
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

date: '2025-02-06T12:29:15+03:00'
publishDate: '2025-02-06T12:29:15+03:00'
lastMod: '2025-02-06T12:29:15+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '5dfddacbebc0fc96f59839649fa484bc51568a83'
uuid: '5dfddacb-ebc0-5c96-9598-39649fa484bc'
slug: '5dfddacb-ebc0-5c96-9598-39649fa484bc'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "TimescaleDB" >}}.

<!--more-->

## Экспорт параметров

- Экспортировать заранее подготовленные параметры в переменные окружения:

```bash
export PGSQL_VER='17' && export TSDB_VER='2.18.*'
```

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://packagecloud.io/timescale/timescaledb/gpgkey' | gpg --dearmor -o '/etc/apt/keyrings/timescaledb.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/timescaledb.sources`:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: TimescaleDB\nTypes: deb\nURIs: https://packagecloud.io/timescale/timescaledb/${ID}\nSuites: ${VERSION_CODENAME}\nComponents: main\nSigned-By: /etc/apt/keyrings/timescaledb.gpg\n" | tee '/etc/apt/sources.list.d/timescaledb.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
[[ ! -v 'PGSQL_VER' || ! -v 'TSDB_VER' ]] && return; apt update && apt install --yes timescaledb-2-postgresql-${PGSQL_VER}=${TSDB_VER} timescaledb-2-loader-postgresql-${PGSQL_VER}=${TSDB_VER} timescaledb-tools
```
