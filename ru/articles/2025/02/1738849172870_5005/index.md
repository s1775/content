---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Graylog: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'graylog'
  - 'mongodb'
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

date: '2025-02-06T16:39:35+03:00'
publishDate: '2025-02-06T16:39:35+03:00'
lastMod: '2025-02-06T16:39:35+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '21804a64d47aa563805047029e5cb5a3f5fddb1f'
uuid: '21804a64-d47a-5563-a050-47029e5cb5a3'
slug: '21804a64-d47a-5563-a050-47029e5cb5a3'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "Graylog" >}}.

<!--more-->

## Экспорт параметров

- Экспортировать заранее подготовленные параметры в переменные окружения:

```bash
export GRAYLOG_VER='6.1'
```

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSLo '/etc/apt/keyrings/graylog.gpg' 'https://libsys.ru/ru/2025/02/21804a64-d47a-5563-a050-47029e5cb5a3/graylog.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/graylog.sources`:

```bash
[[ ! -v 'GRAYLOG_VER' ]] && return; . '/etc/os-release' && echo -e "X-Repolib-Name: Graylog\nTypes: deb\nURIs: https://packages.graylog2.org/repo/${ID}\nSuites: stable\nComponents: ${GRAYLOG_VER}\nSigned-By: /etc/apt/keyrings/graylog.gpg\n" | tee '/etc/apt/sources.list.d/graylog.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes graylog-server
```

## Настройка

- Скачать файл основной конфигурации `server.conf` в `/etc/graylog/server/`:

```bash
f=('server'); d='/etc/graylog/server'; s='https://libsys.ru/ru/2025/02/21804a64-d47a-5563-a050-47029e5cb5a3'; for i in "${f[@]}"; do [[ -f "${d}/${i}.conf" && ! -f "${d}/${i}.conf.orig" ]] && mv "${d}/${i}.conf" "${d}/${i}.conf.orig"; curl -fsSLo "${d}/${i}.conf" "${s}/${i}.conf"; done
```

- Создать пароль для `password_secret`:

```bash
< '/dev/urandom' tr -dc 'a-zA-Z0-9' | head -c "${1:-96}"; echo;
```

- Создать хэш пароля `password_secret` для `root_password_sha2`:

```bash
echo -n 'Enter Password: ' && head -1 < '/dev/stdin' | tr -d '\n' | sha256sum | cut -d ' ' -f1
```

### Конфигурация PROXY-сервера

- Установить {{< tag "Angie" >}} по материалу {{< uuid "b825cd19-f0f5-5a63-acb2-00784311b738" >}}.
- Скачать файл сайта `graylog-ssl.conf` в `/etc/angie/http.d/`:

```bash
f=('graylog-ssl'); d='/etc/angie/http.d'; s='https://libsys.ru/ru/2025/02/21804a64-d47a-5563-a050-47029e5cb5a3'; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}.conf" "${s}/${i}.conf"; done
```
