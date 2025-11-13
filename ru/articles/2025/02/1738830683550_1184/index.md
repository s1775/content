---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'ElasticSearch: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'elastic'
  - 'elasticsearch'
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

date: '2025-02-06T11:31:25+03:00'
publishDate: '2025-02-06T11:31:25+03:00'
lastMod: '2025-02-06T11:31:25+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '6542fa1441f4330978c0a3bac519b93d875214a4'
uuid: '6542fa14-41f4-5309-98c0-a3bac519b93d'
slug: '6542fa14-41f4-5309-98c0-a3bac519b93d'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "ElasticSearch" >}}.

<!--more-->

## Экспорт параметров

- Экспортировать заранее подготовленные параметры в переменные окружения:

```bash
export ELASTICSEARCH_VER='8'
```

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://libsys.ru/ru/2025/02/6542fa14-41f4-5309-98c0-a3bac519b93d/elasticsearch.asc' | gpg --dearmor -o '/etc/apt/keyrings/elasticsearch.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/elasticsearch.sources`:

```bash
[[ ! -v 'ELASTICSEARCH_VER' ]] && return; . '/etc/os-release' && echo -e "X-Repolib-Name: ElasticSearch\nTypes: deb\nURIs: https://artifacts.elastic.co/packages/${ELASTICSEARCH_VER}.x/apt\n#URIs: https://mirror.yandex.ru/mirrors/elastic/${ELASTICSEARCH_VER}\nSuites: stable\nComponents: main\nSigned-By: /etc/apt/keyrings/elasticsearch.gpg\n" | tee '/etc/apt/sources.list.d/elasticsearch.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes elasticsearch
```

## Настройка

- Скачать файл основной конфигурации `elasticsearch.yml` в `/etc/elasticsearch/`:

```bash
f=('elasticsearch'); d='/etc/elasticsearch'; s='https://libsys.ru/ru/2025/02/6542fa14-41f4-5309-98c0-a3bac519b93d'; for i in "${f[@]}"; do [[ -f "${d}/${i}.yml" && ! -f "${d}/${i}.yml.orig" ]] && mv "${d}/${i}.yml" "${d}/${i}.yml.orig"; curl -fsSLo "${d}/${i}.yml" "${s}/${i}.yml" && chown root:elasticsearch "${d}/${i}.yml" && chmod 660 "${d}/${i}.yml"; done
```

- Скачать файлы локальной конфигурации в `/etc/elasticsearch/jvm.options.d/`:

```bash
f=('jvm'); d='/etc/elasticsearch/jvm.options.d'; s='https://libsys.ru/ru/2025/02/6542fa14-41f4-5309-98c0-a3bac519b93d'; for i in "${f[@]}"; do curl -fsSLo "${d}/90-${i}.local.options" "${s}/${i}.options" && chown root:elasticsearch "${d}/90-${i}.local.options" && chmod 660 "${d}/90-${i}.local.options"; done
```
