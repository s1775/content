---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'ClamAV: Установка дополнительных баз данных'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'security'
  - 'network'
tags:
  - 'debian'
  - 'clamav'
  - 'fangfrisch'
authors:
  - 'KaiKimera'
sources:
  - 'https://rseichter.github.io/fangfrisch'
  - 'https://salsa.debian.org/clamav-team/fangfrisch'
  - 'https://wiki.archlinux.org/title/ClamAV'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2025-04-29T12:34:44+03:00'
publishDate: '2025-04-29T12:34:44+03:00'
lastMod: '2025-04-29T12:34:44+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '96bdcb5ca58b88ae8e6b536b49bf1c512075ee8c'
uuid: '96bdcb5c-a58b-58ae-9e6b-536b49bf1c51'
slug: '96bdcb5c-a58b-58ae-9e6b-536b49bf1c51'

draft: 0
---

В этой заметке рассмотрим процесс установки и настройки утилиты **Fangfrisch**.

<!--more-->

**Fangfrisch** - это аналог утилиты ClamAV FreshClam. Он позволяет загружать файлы определений вирусов, которые не являются официальными файлами ClamAV, например, от SaneSecurity , URLhaus и других. Fangfrisch был разработан с учетом безопасности и может запускаться только от непривилегированного пользователя.

## Установка

- Установить пакеты ClamAV и пакет развёртывания виртуальной среды Python:

```bash
apt install --yes clamdscan python3-pip python3-venv
```

- Создать директорию `/var/lib/fangfrisch` и окружение:

```bash
d='/var/lib/fangfrisch'; mkdir "${d}" && chown clamav:clamav "${d}" && cd "${d}" && python3 -m 'venv' 'venv' && source 'venv/bin/activate' && pip install fangfrisch
```

## Настройка

- Создать файл `/etc/fangfrisch.conf` со следующим содержанием:

{{< file "fangfrisch.conf" "ini" >}}

- Инициализировать базу данных:

```bash
sudo -u 'clamav' '/var/lib/fangfrisch/venv/bin/fangfrisch' --conf '/etc/fangfrisch.conf' initdb
```

- Обновить базу данных:

```bash
sudo -u 'clamav' '/var/lib/fangfrisch/venv/bin/fangfrisch' --conf '/etc/fangfrisch.conf' refresh
```

- Скачать файлы сервиса и таймера в `/etc/systemd/system` и обновить список сервисов `systemd`:

```bash
f=('fangfrisch.service' 'fangfrisch.timer'); d='/etc/systemd/system'; s='https://libsys.ru/ru/2025/04/96bdcb5c-a58b-58ae-9e6b-536b49bf1c51'; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}" "${s}/${i}"; done; systemctl daemon-reload
```

- Включить и запустить таймер `fangfrisch.timer`:

```bash
systemctl enable --now 'fangfrisch.timer'
```
