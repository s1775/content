---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'PostgreSQL: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'postgresql'
  - 'pgsql'
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

date: '2025-02-06T12:03:26+03:00'
publishDate: '2025-02-06T12:03:26+03:00'
lastMod: '2025-02-06T12:03:26+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '9c234b3c704e099f8fd9b3fbb70f789767f901b4'
uuid: '9c234b3c-704e-599f-9fd9-b3fbb70f7897'
slug: '9c234b3c-704e-599f-9fd9-b3fbb70f7897'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "PostgreSQL" >}}.

<!--more-->

## Экспорт параметров

- Экспортировать заранее подготовленные параметры в переменные окружения:

```bash
export PGSQL_VER='17'
```

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://www.postgresql.org/media/keys/ACCC4CF8.asc' | gpg --dearmor -o '/etc/apt/keyrings/pgsql.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/pgsql.sources`:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: PostgreSQL\nTypes: deb\nURIs: https://apt.postgresql.org/pub/repos/apt\n#URIs: https://mirror.yandex.ru/mirrors/postgresql\nSuites: ${VERSION_CODENAME}-pgdg\nComponents: main\nSigned-By: /etc/apt/keyrings/pgsql.gpg\n" | tee '/etc/apt/sources.list.d/pgsql.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
[[ ! -v 'PGSQL_VER' ]] && return; apt update && apt install --yes postgresql-${PGSQL_VER}
```

## Настройка

- Скачать файлы локальной конфигурации в `/etc/postgresql/17/main/conf.d/`:

```bash
[[ ! -v 'PGSQL_VER' ]] && return; f=('pgsql' 'pgsql.zfs'); d="/etc/postgresql/${PGSQL_VER}/main/conf.d"; s='https://libsys.ru/ru/2025/02/9c234b3c-704e-599f-9fd9-b3fbb70f7897'; for i in "${f[@]}"; do curl -fsSLo "${d}/90-${i##*.}.local.conf" "${s}/${i}.conf" && chown postgres:postgres "${d}/90-${i##*.}.local.conf"; done
```

- Изменить стандартный пароль у роли `postgres` на `PASSWORD`:

```bash
 p='PASSWORD'; sudo -u 'postgres' psql -c "alter role postgres with password '${p}';"
```
