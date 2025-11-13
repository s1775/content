---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Redis: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'redis'
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

date: '2025-02-07T16:30:03+03:00'
publishDate: '2025-02-07T16:30:03+03:00'
lastMod: '2025-02-07T16:30:03+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '0b81ff23999199ccdc64370b86ad2263b5533c06'
uuid: '0b81ff23-9991-59cc-8c64-370b86ad2263'
slug: '0b81ff23-9991-59cc-8c64-370b86ad2263'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "Redis" >}}.

<!--more-->

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://libsys.ru/ru/2025/02/0b81ff23-9991-59cc-8c64-370b86ad2263/redis.asc' | gpg --dearmor -o '/etc/apt/keyrings/redis.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/redis.sources`:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: Redis\nTypes: deb\nURIs: https://packages.redis.io/deb\nSuites: ${VERSION_CODENAME}\nComponents: main\nSigned-By: /etc/apt/keyrings/redis.gpg\n" | tee '/etc/apt/sources.list.d/redis.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes redis && systemctl enable --now redis-server.service
```

## Настройка

- Добавить директиву `include` в основной файл конфигурации `redis.conf`:

```bash
f='/etc/redis/redis.conf'; [[ -f "${f}" && ! -f "${f}.orig" ]] && mv "${f}" "${f}.orig" && cp "${f}.orig" "${f}" && echo -e '\ninclude /etc/redis/conf.d/*.conf\n' | tee -a "${f}" > '/dev/null'
```

- Скачать файлы локальной конфигурации в `/etc/redis/conf.d/`:

```bash
f=('redis'); d='/etc/redis/conf.d'; s='https://libsys.ru/ru/2025/02/0b81ff23-9991-59cc-8c64-370b86ad2263'; [[ ! -d "${d}" ]] && mkdir "${d}"; for i in "${f[@]}"; do curl -fsSLo "${d}/90-${i}.local.conf" "${s}/${i}.conf"; done
```
