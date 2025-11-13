---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'MariaDB: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'mariadb'
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

date: '2025-02-07T14:49:15+03:00'
publishDate: '2025-02-07T14:49:15+03:00'
lastMod: '2025-02-07T14:49:15+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '0068df20232a95a2548752dc746a4f472515fd55'
uuid: '0068df20-232a-55a2-a487-52dc746a4f47'
slug: '0068df20-232a-55a2-a487-52dc746a4f47'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "MariaDB" >}}.

<!--more-->

## Экспорт параметров

- Экспортировать заранее подготовленные параметры в переменные окружения:

```bash
export MARIADB_VER='11.4'
```

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSLo '/etc/apt/keyrings/mariadb.gpg' 'https://mariadb.org/mariadb_release_signing_key.pgp'
```

- Создать файл репозитория `/etc/apt/sources.list.d/mariadb.sources`:

```bash
[[ ! -v 'MARIADB_VER' ]] && return; . '/etc/os-release' && echo -e "X-Repolib-Name: MariaDB\nTypes: deb\nURIs: https://mirror.netcologne.de/mariadb/repo/${MARIADB_VER}/${ID}\n#URIs: https://mirror.yandex.ru/mirrors/mariadb/repo/${MARIADB_VER}/${ID}\nSuites: ${VERSION_CODENAME}\nComponents: main\nSigned-By: /etc/apt/keyrings/mariadb.gpg\n" | tee '/etc/apt/sources.list.d/mariadb.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes mariadb-server && systemctl stop mariadb.service
```

## Настройка

- Скачать файлы локальной конфигурации в `/etc/mysql/mariadb.conf.d/`:

```bash
f=('server' 'mariadb-dump'); d='/etc/mysql/mariadb.conf.d'; s='https://libsys.ru/ru/2025/02/0068df20-232a-55a2-a487-52dc746a4f47'; for i in "${f[@]}"; do curl -fsSLo "${d}/90-${i}.local.cnf" "${s}/${i}.cnf"; done
```

- Удалить файлы в директории `/var/lib/mysql` и инициализировать стандартные базы данных:

```bash
rm -rf /var/lib/mysql/* && mariadb-install-db --user='mysql' && systemctl start mariadb.service
```

- Запустить скрипт безопасной установки:

```bash
mariadb-secure-installation && systemctl restart mariadb.service
```

- Создать пользователя `root` для подключения `127.0.0.1` и с любых хостов (`%`):

```bash
 p='PASSWORD'; echo "create user if not exists 'root'@'127.0.0.1' identified by '${p}'; grant all privileges on *.* to 'root'@'127.0.0.1' with grant option; create user if not exists 'root'@'%' identified by '${p}'; grant all privileges on *.* to 'root'@'%' with grant option; flush privileges;" | mariadb --user='root' --password
```
