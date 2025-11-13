---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'NodeJS: Установка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'nodejs'
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

date: '2025-02-08T00:00:51+03:00'
publishDate: '2025-02-08T00:00:51+03:00'
lastMod: '2025-02-08T00:00:51+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '138218c7d9a9aeeb44cf31ba8dc24896cc15f418'
uuid: '138218c7-d9a9-5eeb-a4cf-31ba8dc24896'
slug: '138218c7-d9a9-5eeb-a4cf-31ba8dc24896'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "NodeJS" >}}.

<!--more-->

## Экспорт параметров

- Экспортировать заранее подготовленные параметры в переменные окружения:

```bash
export NODE_VER='22'
```

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key' | gpg --dearmor -o '/etc/apt/keyrings/nodesource.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/nodesource.sources`:

```bash
echo -e "X-Repolib-Name: Node.js\nTypes: deb\nURIs: https://deb.nodesource.com/node_${NODE_VER}.x\nSuites: nodistro\nComponents: main\nSigned-By: /etc/apt/keyrings/nodesource.gpg\n" | tee '/etc/apt/sources.list.d/nodesource.sources' > '/dev/null'
```

- Скачать файлы предпочтений в `/etc/apt/preferences.d/`:

```bash
f=('nodejs' 'nsolid'); d='/etc/apt/preferences.d'; s='https://libsys.ru/ru/2025/02/138218c7-d9a9-5eeb-a4cf-31ba8dc24896'; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}.pref" "${s}/${i}.pref"; done
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes nodejs
```
