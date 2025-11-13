---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Syslog-NG: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'syslog-ng'
  - 'syslog'
  - 'log'
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

date: '2025-02-08T23:43:42+03:00'
publishDate: '2025-02-08T23:43:42+03:00'
lastMod: '2025-02-08T23:43:42+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '24f7d6b6531f528386934ca9d034f604a509542a'
uuid: '24f7d6b6-531f-5283-b693-4ca9d034f604'
slug: '24f7d6b6-531f-5283-b693-4ca9d034f604'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "Syslog-NG" >}}.

<!--more-->

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://libsys.ru/ru/2025/02/24f7d6b6-531f-5283-b693-4ca9d034f604/syslog-ng.asc' | gpg --dearmor -o '/etc/apt/keyrings/syslog-ng.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/syslog-ng.sources`:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: Syslog-NG\nTypes: deb\nURIs: https://ose-repo.syslog-ng.com/apt\nSuites: stable\nComponents: ${ID}-${VERSION_CODENAME}\nSigned-By: /etc/apt/keyrings/syslog-ng.gpg\n" | tee '/etc/apt/sources.list.d/syslog-ng.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes syslog-ng
```

## Настройка

- Создать файлы локальной конфигурации в `/etc/syslog-ng/conf.d/`:

```bash
f=('syslog-ng'); d='/etc/syslog-ng/conf.d'; s='https://libsys.ru/ru/2025/02/24f7d6b6-531f-5283-b693-4ca9d034f604'; for i in "${f[@]}"; do curl -fsSLo "${d}/90-${i}.local.conf" "${s}/${i}.conf"; done
```
