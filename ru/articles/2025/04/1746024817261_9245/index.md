---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'ClamAV: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'security'
  - 'network'
  - 'inDev'
tags:
  - 'debian'
  - 'apt'
  - 'clamav'
  - 'install'
authors:
  - 'KaiKimera'
sources:
  - 'https://www.clamav.net/downloads'
  - 'https://docs.clamav.net/manual/Installing.html'
  - 'https://docs.clamav.net/manual/Installing/Add-clamav-user.html'
  - 'https://docs.clamav.net/manual/Usage/Configuration.html'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2025-04-30T17:53:42+03:00'
publishDate: '2025-04-30T17:53:42+03:00'
lastMod: '2025-04-30T17:53:42+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'd5729fa5d717e6c9af9645530459d0f87cc38d3c'
uuid: 'd5729fa5-d717-56c9-af96-45530459d0f8'
slug: 'd5729fa5-d717-56c9-af96-45530459d0f8'

draft: 0
---

Инструкция по установке {{< tag "ClamAV" >}} из официального пакета Cisco Talos.

<!--more-->

## Установка

- Скачать и установить `clamav.linux.x86_64.deb`:

```bash
v='1.4.2'; curl -fSLo "/tmp/clamav-${v}.linux.x86_64.deb" "https://www.clamav.net/downloads/production/clamav-${v}.linux.x86_64.deb" && apt install --yes "/tmp/clamav-${v}.linux.x86_64.deb"
```

- Создать пользователя `clamav` с домашней директорией `/var/lib/clamav`:

```bash
u='clamav'; d='/var/lib/clamav'; mkdir "${d}" && adduser --system --no-create-home --disabled-login --disabled-password --shell '/bin/false' --group --home "${d}" "${u}" && chown "${u}":"${u}" "${d}"
```

{{< alert "tip" >}}
Если планируется интеграция ClamAV с Amavis, то пользователя `clamav` необходимо добавить в группу `amavis`:

```bash
u='clamav'; g='amavis'; usermod -aG "${g}" "${u}"
```
{{< /alert >}}

- Создать директории `/run/clamav` и`/var/log/clamav`:

```bash
u='clamav'; d=("/run/${u}" "/var/log/${u}"); for i in "${d[@]}"; do install -d -g "${u}" -o "${u}" "${i}"; done
```

- Скачать файлы сервисов для `systemd`:

```bash
f=('clamonacc.service' 'daemon.service' 'freshclam.service'); d='/etc/systemd/system'; s='https://libsys.ru/ru/2025/04/d5729fa5-d717-56c9-af96-45530459d0f8'; for i in "${f[@]}"; do curl -fsSLo "${d}/clamav-${i}" "${s}/clamav-${i}"; done
```

## Настройка

- Скачать файлы конфигурации `clamd.conf` и `freshclam.conf`:

```bash
f=('clamd.conf' 'freshclam.conf'); d='/usr/local/etc'; s='https://libsys.ru/ru/2025/04/d5729fa5-d717-56c9-af96-45530459d0f8'; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}" "${s}/${i}"; done
```

- Запустить скачивание и обновление баз данных:

```bash
freshclam
```
