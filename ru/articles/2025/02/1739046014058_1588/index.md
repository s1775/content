---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Rsyslog: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'rsyslog'
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

date: '2025-02-08T23:20:14+03:00'
publishDate: '2025-02-08T23:20:14+03:00'
lastMod: '2025-02-08T23:20:14+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'a931d52d3358f7f79c66b2bad6d3dcac838c0fb8'
uuid: 'a931d52d-3358-57f7-8c66-b2bad6d3dcac'
slug: 'a931d52d-3358-57f7-8c66-b2bad6d3dcac'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "Rsyslog" >}}.

<!--more-->

## Репозиторий

{{< alert "important" >}}
Пакеты OBS находятся на стадии разработки. Раздел загрузки располагается в частном домашнем проекте (Rainer Gerhards)[https://rainer.gerhards.net/].
{{< /alert >}}

- Скачать и установить ключ репозитория:

```bash
. '/etc/os-release' && curl -fsSL "https://download.opensuse.org/repositories/home:rgerhards/Debian_${VERSION_ID}/Release.key" | gpg --dearmor -o '/etc/apt/keyrings/rsyslog.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/rsyslog.sources`:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: Rsyslog\nTypes: deb\nURIs: http://download.opensuse.org/repositories/home:/rgerhards/Debian_${VERSION_ID}/\nSuites: /\nSigned-By: /etc/apt/keyrings/rsyslog.gpg\n" | tee '/etc/apt/sources.list.d/rsyslog.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes rsyslog
```

## Настройка

- Скачать файлы локальной конфигурации в `/etc/rsyslog.d/`:

```bash
f=('rsyslog'); d='/etc/rsyslog.d'; s='https://libsys.ru/ru/2025/02/a931d52d-3358-57f7-8c66-b2bad6d3dcac'; for i in "${f[@]}"; do curl -fsSLo "${d}/90-${i}.local.conf" "${s}/${i}.conf"; done
```
