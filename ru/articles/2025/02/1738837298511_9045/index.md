---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'MongoDB: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'mongodb'
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

date: '2025-02-06T13:21:41+03:00'
publishDate: '2025-02-06T13:21:41+03:00'
lastMod: '2025-02-06T13:21:41+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '08fbbde770fc06d52a9e2f27ea376109f75fc22b'
uuid: '08fbbde7-70fc-56d5-aa9e-2f27ea376109'
slug: '08fbbde7-70fc-56d5-aa9e-2f27ea376109'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "MongoDB" >}}.

<!--more-->

## Экспорт параметров

- Экспортировать заранее подготовленные параметры в переменные окружения:

```bash
export MONGODB_VER='8.0'
```

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
[[ ! -v 'MONGODB_VER' ]] && return; curl -fsSL "https://libsys.ru/ru/2025/02/08fbbde7-70fc-56d5-aa9e-2f27ea376109/mongodb-${MONGODB_VER}.asc" | gpg --dearmor -o '/etc/apt/keyrings/mongodb.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/mongodb.sources`:

```bash
[[ ! -v 'MONGODB_VER' ]] && return; . '/etc/os-release' && echo -e "X-Repolib-Name: MongoDB\nTypes: deb\nURIs: http://repo.mongodb.org/apt/${ID}\n#URIs: https://mirror.yandex.ru/mirrors/repo.mongodb.org/apt/${ID}\nSuites: ${VERSION_CODENAME}/mongodb-org/${MONGODB_VER}\nComponents: main\nSigned-By: /etc/apt/keyrings/mongodb.gpg\n" | tee '/etc/apt/sources.list.d/mongodb.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes mongodb-org
```

## Настройка

- Скачать файл основной конфигурации `mongod.conf` в `/etc/`:

```bash
f=('mongod'); d='/etc'; s='https://libsys.ru/ru/2025/02/08fbbde7-70fc-56d5-aa9e-2f27ea376109'; for i in "${f[@]}"; do [[ -f "${d}/${i}.conf" && ! -f "${d}/${i}.conf.orig" ]] && mv "${d}/${i}.conf" "${d}/${i}.conf.orig"; curl -fsSLo "${d}/${i}.conf" "${s}/${i}.conf"; done
```

### Включение авторизации

- Запустить командную оболочку `mongosh`, создать пользователя `root` с паролем `PASSWORD` и ролью `root`:

```bash
mongosh --eval 'use admin' --eval 'db.createUser({user: "root", pwd: "PASSWORD", roles: [{role: "root", db: "admin"}]})'
```

- Добавить в файл `/etc/mongod.conf` следующие строки для включения авторизации:

```yaml
security:
  authorization: enabled
```

- Перезапустить mongod:

```bash
systemctl restart mongod
```

- Запустить командную оболочку `mongosh` с включённой авторизацией:

```bash
mongosh --username 'root' --authenticationDatabase 'admin'
```
