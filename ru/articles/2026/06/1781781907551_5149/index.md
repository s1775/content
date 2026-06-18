---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Grafana: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
  - 'inDev'
tags:
  - 'debian'
  - 'apt'
  - 'grafana'
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

date: '2026-06-18T14:25:13+03:00'
publishDate: '2026-06-18T14:25:13+03:00'
lastMod: '2026-06-18T14:25:13+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'f62d48d80b9b1fbb4b90e4b811e1ca0c5941a45e'
uuid: 'f62d48d8-0b9b-5fbb-bb90-e4b811e1ca0c'
slug: 'f62d48d8-0b9b-5fbb-bb90-e4b811e1ca0c'

draft: 0
---

Инструкция по установке и настройке {{< tag "Grafana" >}}.

<!--more-->

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://libsys.ru/ru/2026/06/f62d48d8-0b9b-5fbb-bb90-e4b811e1ca0c/grafana.asc' | gpg --dearmor -o '/etc/apt/keyrings/grafana.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/grafana.sources`:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: Grafana\nTypes: deb\nURIs: https://apt.grafana.com\nSuites: stable\nComponents: main\nSigned-By: /etc/apt/keyrings/grafana.gpg\n" | tee '/etc/apt/sources.list.d/grafana.sources' > '/dev/null'
```

## Установка

```bash
apt update && apt install --yes grafana
```
