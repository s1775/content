---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'OpenSearch: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'opensearch'
  - 'aws'
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

date: '2025-02-06T11:52:10+03:00'
publishDate: '2025-02-06T11:52:10+03:00'
lastMod: '2025-02-06T11:52:10+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '0c18558eb4e197131ead9b767d14e99c6d9ab85f'
uuid: '0c18558e-b4e1-5713-aead-9b767d14e99c'
slug: '0c18558e-b4e1-5713-aead-9b767d14e99c'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "OpenSearch" >}}.

<!--more-->

## Экспорт параметров

- Экспортировать заранее подготовленные параметры в переменные окружения:

```bash
export OPENSEARCH_VER='3.1.0'; export OPENSEARCH_INITIAL_ADMIN_PASSWORD='PASSWORD'
```

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://artifacts.opensearch.org/publickeys/opensearch-release.pgp' | gpg --dearmor -o '/etc/apt/keyrings/opensearch.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/opensearch.sources`:

```bash
[[ ! -v 'OPENSEARCH_VER' ]] && return; . '/etc/os-release' && echo -e "X-Repolib-Name: OpenSearch\nTypes: deb\nURIs: https://artifacts.opensearch.org/releases/bundle/opensearch/${OPENSEARCH_VER%%.*}.x/apt\nSuites: stable\nComponents: main\nSigned-By: /etc/apt/keyrings/opensearch.gpg\n" | tee '/etc/apt/sources.list.d/opensearch.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
[[ ! -v 'OPENSEARCH_VER' ]] && return; apt update && apt install --yes opensearch=${OPENSEARCH_VER} && apt-mark hold opensearch=${OPENSEARCH_VER}
```

## Настройка

- Скачать файл основной конфигурации `opensearch.yml` в `/etc/opensearch/`:

```bash
f=('opensearch'); d='/etc/opensearch'; s='https://libsys.ru/ru/2025/02/0c18558e-b4e1-5713-aead-9b767d14e99c'; for i in "${f[@]}"; do [[ -f "${d}/${i}.yml" && ! -f "${d}/${i}.yml.orig" ]] && mv "${d}/${i}.yml" "${d}/${i}.yml.orig"; curl -fsSLo "${d}/${i}.yml" "${s}/${i}.yml" && chown opensearch:opensearch "${d}/${i}.yml" && chmod 640 "${d}/${i}.yml"; done
```

- Скачать файлы локальной конфигурации в `/etc/opensearch/jvm.options.d/`:

```bash
f=('jvm'); d='/etc/opensearch/jvm.options.d'; s='https://libsys.ru/ru/2025/02/0c18558e-b4e1-5713-aead-9b767d14e99c'; for i in "${f[@]}"; do curl -fsSLo "${d}/90-${i}.local.options" "${s}/${i}.options" && chown opensearch:opensearch "${d}/90-${i}.local.options" && chmod 640 "${d}/90-${i}.local.options"; done
```
