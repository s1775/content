---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'FreePBX: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
  - 'inDev'
tags:
  - 'debian'
  - 'apt'
  - 'asterisk'
  - 'freepbx'
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

date: '2026-05-26T11:36:14+03:00'
publishDate: '2026-05-26T11:36:14+03:00'
lastMod: '2026-05-26T11:36:14+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '693f58bc7dc270f2573a59523931ea74de1d45b1'
uuid: '693f58bc-7dc2-50f2-a73a-59523931ea74'
slug: '693f58bc-7dc2-50f2-a73a-59523931ea74'

draft: 0
---

Инструкция по установке и настройки {{< tag "Asterisk" >}} из репозитория {{< tag "FreePBX" >}}.

<!--more-->

Авторы {{< tag "Asterisk" >}} не собирают пакеты для дистрибутивов {{< tag "Linux" >}} и рекомендуют компилировать своё приложение на месте. Однако, можно воспользоваться репозиторием от {{< tag "FreePBX" >}} и попробовать установить {{< tag "Asterisk" >}} оттуда.

Эта статья носит исследовательский характер.

## Экспорт параметров

- Экспортировать заранее подготовленные параметры в переменные окружения:

```bash
export PBX_VER='22'
```

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'http://deb.freepbx.org/gpg/aptly-pubkey.asc' | gpg --dearmor -o '/etc/apt/keyrings/freepbx.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/freepbx.sources`:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: FreePBX\nTypes: deb\nURIs: http://deb.freepbx.org/freepbx17-prod\nSuites: ${VERSION_CODENAME}\nComponents: main\nSigned-By: /etc/apt/keyrings/freepbx.gpg\n" | tee '/etc/apt/sources.list.d/freepbx.sources' > '/dev/null'
```

- Создать файлы предпочтений `/etc/apt/preferences.d/freepbx.pref` со следующим содержанием:

```
Package: *
Pin: origin deb.freepbx.org
Pin-Priority: 600
```

## Установка

- Создать директорию `/var/lib/asterisk/moh`:

```bash
mkdir -p '/var/lib/asterisk/moh'
```

- Установить пакеты `asterisk`:

```bash
[[ ! -v 'PBX_VER' ]] && return; apt update && apt install --yes asterisk${PBX_VER} asterisk${PBX_VER}-core asterisk${PBX_VER}-configs asterisk${PBX_VER}-odbc asterisk${PBX_VER}-sqlite3 asterisk${PBX_VER}-resample asterisk${PBX_VER}-speex asterisk${PBX_VER}-flite asterisk${PBX_VER}-curl asterisk${PBX_VER}-snmp asterisk${PBX_VER}-g729 asterisk${PBX_VER}-ogg asterisk${PBX_VER}-res-digium-phone asterisk${PBX_VER}-voicemail "asterisk-sounds-core-en*"
```

- Установить библиотеки:

```bash
[[ ! -v 'PBX_VER' ]] && return; apt update && apt install --yes ffmpeg sqlite3 libavahi-client3 libavdevice59 libcodec2-1.0 libfdk-aac2 libgmime-3.0-0 libgsm1 libical3 libiksemel3 libjack0 liblua5.2-0 libneon27 libodbc2 libportaudio2 libpri1.4 libradcli4 libradcli4 libresample1 libsnmp40 libspandsp2 libspeex1 libspeexdsp1 libsrtp2-1 libunbound8 liburiparser1 libvorbis0a libvorbisenc2 libvorbisfile3 libxslt1.1
```

- Установить пакеты `asterisk-sounds`:

```bash
[[ ! -v 'PBX_VER' ]] && return; apt update && apt install --yes asterisk-sounds-core-en-alaw asterisk-sounds-core-en-ulaw asterisk-sounds-core-en-wideband
```

- Исправить конфигурацию `radius` в `/etc/asterisk/cdr.conf`:

```bash
sed -i -e 's|;\[radius\]|\[radius\]|g' -e 's|;radiuscfg => /usr/local/etc/radiusclient-ng/|radiuscfg => /etc/radcli/|g' '/etc/asterisk/cdr.conf'
```

- Исправить конфигурацию `radius` в `/etc/asterisk/cel.conf`:

```bash
sed -i 's|;radiuscfg => /usr/local/etc/radiusclient-ng/|radiuscfg => /etc/radcli/|g' '/etc/asterisk/cel.conf'
```
