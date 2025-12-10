---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Angie: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'angie'
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

date: '2025-02-05T22:25:26+03:00'
publishDate: '2025-02-05T22:25:26+03:00'
lastMod: '2025-02-05T22:25:26+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'b825cd19f0f59a63ecb200784311b73801d0e56a'
uuid: 'b825cd19-f0f5-5a63-acb2-00784311b738'
slug: 'b825cd19-f0f5-5a63-acb2-00784311b738'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "Angie" >}}.

<!--more-->

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSLo '/etc/apt/keyrings/angie.gpg' 'https://angie.software/keys/angie-signing.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/angie.sources`:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: Angie\nTypes: deb\nURIs: https://download.angie.software/angie/${ID}/${VERSION_ID}\nSuites: ${VERSION_CODENAME}\nComponents: main\nSigned-By: /etc/apt/keyrings/angie.gpg\n" | tee '/etc/apt/sources.list.d/angie.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes angie angie-module-brotli angie-module-zstd
```

## Настройка

- Скачать файл основной конфигурации `angie.conf` в `/etc/angie/`:

```bash
f=('angie'); d='/etc/angie'; s='https://libsys.ru/ru/2025/02/b825cd19-f0f5-5a63-acb2-00784311b738'; for i in "${f[@]}"; do [[ -f "${d}/${i}.conf" && ! -f "${d}/${i}.conf.orig" ]] && mv "${d}/${i}.conf" "${d}/${i}.conf.orig"; curl -fsSLo "${d}/${i}.conf" "${s}/${i}.conf"; done
```

- Скачать файлы локальной конфигурации модулей в `/etc/angie/conf.d/`:

```bash
f=('http.acme' 'http.brotli' 'http.core' 'http.gzip' 'http.headers' 'http.proxy' 'http.real_ip' 'http.ssl' 'http.ssl.map' 'http.v3' 'http.zstd'); d='/etc/angie/conf.d'; s='https://libsys.ru/ru/2025/02/b825cd19-f0f5-5a63-acb2-00784311b738'; [[ ! -d "${d}" ]] && mkdir "${d}"; for i in "${f[@]}"; do curl -fsSLo "${d}/90-${i}.local.conf" "${s}/module.${i}.conf"; done
```

- Скачать файлы стандартных сайтов (`80` и `443`) в `/etc/angie/http.d/`:

```bash
f=('default' 'default-ssl'); d='/etc/angie/http.d'; s='https://libsys.ru/ru/2025/02/b825cd19-f0f5-5a63-acb2-00784311b738'; for i in "${f[@]}"; do [[ -f "${d}/${i}.conf" && ! -f "${d}/${i}.conf.orig" ]] && mv "${d}/${i}.conf" "${d}/${i}.conf.orig"; curl -fsSLo "${d}/${i}.conf" "${s}/http.${i}.conf"; done
```
