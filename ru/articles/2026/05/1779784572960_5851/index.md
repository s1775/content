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

## Установка

- Установить общие приложения и библиотеки:

```bash
[[ ! -v 'PBX_VER' ]] && return; apt update && apt install --yes ffmpeg libavdevice59 liburiparser1
```

- Установить пакеты `asterisk`:

```bash
[[ ! -v 'PBX_VER' ]] && return; apt update && apt install --yes asterisk${PBX_VER}-addons asterisk${PBX_VER}-addons-bluetooth asterisk${PBX_VER}-addons-core asterisk${PBX_VER}-addons-ooh323 asterisk${PBX_VER}-core asterisk${PBX_VER}-curl asterisk${PBX_VER}-dahdi asterisk${PBX_VER}-doc asterisk${PBX_VER}-odbc asterisk${PBX_VER}-ogg asterisk${PBX_VER}-flite asterisk${PBX_VER}-g729 asterisk${PBX_VER}-resample asterisk${PBX_VER}-snmp asterisk${PBX_VER}-speex asterisk${PBX_VER}-sqlite3 asterisk${PBX_VER}-res-digium-phone asterisk${PBX_VER}-voicemail asterisk-version-switch "asterisk-sounds-core-en-*"
```

## Настройка

- Скачать базовые конфигурационные файлы `basic-pbx` в директорию `/etc/asterisk`:

```bash
[[ ! -v 'PBX_VER' ]] && return; f=('asterisk' 'cdr' 'cdr_custom' 'confbridge' 'extensions' 'indications' 'logger' 'modules' 'musiconhold' 'pjsip' 'pjsip_notify' 'queues' 'voicemail'); d='/etc/asterisk'; s="https://raw.githubusercontent.com/asterisk/asterisk/refs/heads/${PBX_VER}/configs/basic-pbx"; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}.conf" "${s}/${i}.conf"; done;
```
