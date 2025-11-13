---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Установка и настройка Asterisk'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'inDev'
  - 'network'
tags:
  - 'debian'
  - 'asterisk'
  - 'voip'
authors:
  - 'KaiKimera'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '1'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-04-04T14:44:11+03:00'
publishDate: '2024-04-04T14:44:11+03:00'
lastMod: '2024-04-04T14:44:11+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '2e00b43bb0da79c28e9260dcf2ba1d5255b468e9'
uuid: '2e00b43b-b0da-59c2-ae92-60dcf2ba1d52'
slug: '2e00b43b-b0da-59c2-ae92-60dcf2ba1d52'

draft: 0
---

Устанавливаем {{< tag "Asterisk" >}} на ОС {{< tag "Debian" >}} и создаём под него отдельного пользователя.

<!--more-->

## Обновление ОС и установка пакетов

Перед сборкой {{< tag "Asterisk" >}} необходимо обновить пакеты ОС {{< tag "Debian" >}}:

```bash
apt update && apt --yes full-upgrade
```

## Установка Asterisk

Сборку {{< tag "Asterisk" >}} необходимо выполнять находясь в его директории.

### Установка компонентов

Добавляем возможность использования MP3 и устанавливаем все зависимости для сборки:

```bash
bash ./contrib/scripts/get_mp3_source.sh && bash ./contrib/scripts/install_prereq install
```

### Конфигурация сборки

Выполняем конфигурирование и настройку компонентов:

```bash
./configure && make menuselect.makeopts && menuselect/menuselect --enable app_macro --enable chan_ooh323 --enable format_mp3 --enable codec_opus --enable CORE-SOUNDS-EN-WAV --enable CORE-SOUNDS-EN-ULAW --enable CORE-SOUNDS-EN-ALAW --enable CORE-SOUNDS-EN-GSM --enable CORE-SOUNDS-RU-WAV --enable CORE-SOUNDS-RU-ULAW --enable CORE-SOUNDS-RU-ALAW --enable CORE-SOUNDS-RU-GSM menuselect.makeopts
```

Устанавливаются следующие компоненты:

- `app_macro`
- `chan_ooh323`
- `format_mp3`
- `codec_opus`
- `CORE-SOUNDS-EN-WAV`
- `CORE-SOUNDS-EN-ULAW`
- `CORE-SOUNDS-EN-ALAW`
- `CORE-SOUNDS-EN-GSM`
- `CORE-SOUNDS-RU-WAV`
- `CORE-SOUNDS-RU-ULAW`
- `CORE-SOUNDS-RU-ALAW`
- `CORE-SOUNDS-RU-GSM`

### Сборка и установка Asterisk

После конфигурирования, начинаем сборку:

```bash
make && make install && make basic-pbx && make config && ldconfig
```

## Настройка Asterisk

### Настройка пользователя

По умолчанию, {{< tag "Asterisk" >}} использует пользователя `root` для работы. Это немного не правильно, сделаем так, чтобы {{< tag "Asterisk" >}} работал под своим пользователем. Создаём пользователя:

```bash
u='asterisk'; groupadd ${u} && useradd -r -d /var/lib/${u} -g ${u} ${u} && usermod -aG audio,dialout ${u} && chown -R ${u}:${u} /etc/${u} && chown -R ${u}:${u} /var/{lib,log,spool}/${u} && chown -R ${u}:${u} /usr/lib/${u}
```

После создания пользователя, необходимо отредактировать конфигурационные файлы, чтобы указать Asterisk'у под каким пользователем осуществлять запуск:

```bash
sed -i -e 's|#AST_USER="asterisk"|AST_USER="asterisk"|g' -e 's|#AST_GROUP="asterisk"|AST_GROUP="asterisk"|g' '/etc/default/asterisk' && sed -i -e 's|;runuser = asterisk|runuser = asterisk|g' -e 's|;rungroup = asterisk|rungroup = asterisk|g' '/etc/asterisk/asterisk.conf'
```

## Запуск Asterisk

Указываем автоматический запуск службы {{< tag "Asterisk" >}}:

```bash
systemctl enable --now asterisk
```

Проверяем:

```terminal {mode="root"}
systemctl status asterisk

● asterisk.service - LSB: Asterisk PBX
     Loaded: loaded (/etc/init.d/asterisk; generated)
     Active: active (running) since Thu 2024-04-04 11:51:43 UTC; 2h 5min ago
       Docs: man:systemd-sysv-generator(8)
    Process: 791 ExecStart=/etc/init.d/asterisk start (code=exited, status=0/SUCCESS)
      Tasks: 35 (limit: 1013)
     Memory: 61.1M
        CPU: 36.239s
     CGroup: /system.slice/asterisk.service
             └─871 /usr/sbin/asterisk -U asterisk -G asterisk

Apr 04 11:51:42 phone systemd[1]: Starting LSB: Asterisk PBX...
Apr 04 11:51:43 phone asterisk[791]:  * Starting Asterisk PBX: asterisk
Apr 04 11:51:43 phone asterisk[791]:    ...done.
Apr 04 11:51:43 phone systemd[1]: Started LSB: Asterisk PBX.
```

Заходим в консоль {{< tag "Asterisk" >}} и проверяем работу:

```terminal {mode="root"}
asterisk -rvv

Asterisk 20.7.0, Copyright (C) 1999 - 2022, Sangoma Technologies Corporation and others.
Created by Mark Spencer <markster@digium.com>
Asterisk comes with ABSOLUTELY NO WARRANTY; type 'core show warranty' for details.
This is free software, with components licensed under the GNU General Public
License version 2 and other licenses; you are welcome to redistribute it under
certain conditions. Type 'core show license' for details.
=========================================================================
Running as user 'asterisk'
Running under group 'asterisk'
Connected to Asterisk 20.7.0 currently running on phone (pid = 871)
phone*CLI>
```

## TLS

```bash
mkdir /etc/asterisk/keys
```

```bash
nano /etc/asterisk/pjsip.conf
```

```ini
[transport-tls]
type=transport
protocol=tls
bind=0.0.0.0:5061
cert_file=/etc/asterisk/keys/asterisk.crt
priv_key_file=/etc/asterisk/keys/asterisk.key
```
