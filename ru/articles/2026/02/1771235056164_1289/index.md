---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'iRedMail: Установка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'install'
  - 'mail'
  - 'iredmail'
  - 'roundcube'
  - 'iredadmin'
  - 'iredapd'
  - 'clamav'
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

date: '2026-02-16T12:44:18+03:00'
publishDate: '2026-02-16T12:44:18+03:00'
lastMod: '2026-02-16T12:44:18+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '8e0abf8803dce327f0b8269f29cebb41298b4cbb'
uuid: '8e0abf88-03dc-5327-b0b8-269f29cebb41'
slug: '8e0abf88-03dc-5327-b0b8-269f29cebb41'

draft: 0
---

Привожу свою инструкцию по установке и дополнительной настройке {{< tag "iRedMail" >}} на сервере. В статье много терминальных команд и автоматизации.

<!--more-->

## Настройка ОС

- Добавить в файл `/etc/hosts` строку `127.0.0.1 mail.example.org mail localhost localhost.localdomain`:

```bash
d='mail.example.org'; f='/etc/hosts'; hostnamectl hostname "${d%%.*}" && cp "${f}" "${f}.orig" && sed -i '/^127\.0/d' "${f}" && sed -i "1i 127.0.0.1 ${d} ${d%%.*} localhost localhost.localdomain" "${f}"
```

## Установка iRedMail

- Скачать и распаковать последнюю версию {{< tag "iRedMail" >}}:

```bash
export GH_NAME='iRedMail'; export GH_API="gh.api.${GH_NAME}.json"; export IRM_DIR="${HOME}/iRM.iRedMail.$( date '+%s' )"; mkdir "${IRM_DIR}" && cd "${IRM_DIR}" && curl -fsSL "https://api.github.com/repos/iredmail/${GH_NAME}/tags" | tee "${GH_API}" > '/dev/null'; url="$( grep '"tarball_url":' < "${GH_API}" | head -n 1 | awk -F '"' '{ print $(NF-1) }' )"; ver="$( echo "${url}" | awk -F '/' '{ print $(NF) }' )"; cid="$( grep '"sha":' < "${GH_API}" | head -n 1 | awk -F '"' '{ print $(NF-1) }' | head -c 7 )"; curl -fSLOJ "${url}" && tar -xzf ./*"${cid}.tar.gz" && mv ./*"${cid}" "${GH_NAME}-${ver}" && cd "${GH_NAME}-${ver}" && curl -fsSLo 'config' 'https://libsys.ru/ru/2026/02/8e0abf88-03dc-5327-b0b8-269f29cebb41/irm.config' || return
```

{{< alert "tip" >}}
Если требуется конкретная версия iRedMail, то можно воспользоваться командой:

```bash
v='1.7.2'; curl -fSLo "iRedMail-${v}.tar.gz" "https://github.com/iredmail/iRedMail/archive/refs/tags/${v}.tar.gz" && tar -xzf "iRedMail-${v}.tar.gz" && cd "iRedMail-${v}" || exit
```
{{< /alert >}}

- Создать файл `config` (если не существует) в корневой директории {{< tag "iRedMail" >}} со следующим шаблоном:

{{< file "irm.config" "bash" >}}

- Заполнить шаблон `config` своими параметрами.

{{< alert "tip" >}}
Для генерации паролей можно воспользоваться командой:

```bash
u=('MYSQL_ROOT_PASSWD' 'DOMAIN_ADMIN_PASSWD_PLAIN' 'SOGO_SIEVE_MASTER_PASSWD' 'AMAVISD_DB_PASSWD' 'FAIL2BAN_DB_PASSWD' 'IREDADMIN_DB_PASSWD' 'IREDAPD_DB_PASSWD' 'NETDATA_DB_PASSWD' 'RCM_DB_PASSWD' 'SOGO_DB_PASSWD' 'VMAIL_DB_ADMIN_PASSWD' 'VMAIL_DB_BIND_PASSWD'); for i in "${u[@]}"; do printf "%-25s = %s\n" "${i}" "$( < '/dev/urandom' tr -dc 'a-zA-Z0-9' | head -c "${1:-32}"; echo; )"; done
```
{{< /alert >}}

- Запустить установку {{< tag "iRedMail" >}}:

```bash
bash ./iRedMail.sh
```

{{< alert "warning" >}}
В iRedMail `v1.7.4` не работает скрипт `fail2ban_banned_db`. Исправление:

```bash
sed -i 's|#!/usr/local/bin/bash|#!/usr/bin/env bash|g' '/usr/local/bin/fail2ban_banned_db'
```
{{< /alert >}}

## Дополнительные настройки

В этом разделе собраны дополнительные настройки по различным сервисам {{< tag "iRedMail" >}}.

### Amavis

- Установка антивируса и утилит для работы с архивами:

```bash
apt install --yes clamav libclamunrar && apt install --yes arj cabextract cpio lhasa lzop nomarch pax unrar unzip
```

- Удаление старого пакета `p7zip` и установка нового `7zip`:

```bash
. '/etc/os-release' && apt purge --yes p7zip && apt install --yes -t "${VERSION_CODENAME}-backports" 7zip 7zip-rar
```

- Генерация DKIM записи (длина ключа `1024`):

```bash
d='example.org'; f="/var/lib/dkim/${d}.1024.pem"; amavisd genrsa "${f}" 1024 && chown amavis:amavis "${f}" && chmod 0400 "${f}"
```

### ClamAV

- Настройка российского зеркала обновлений {{< tag "ClamAV" >}}:

```bash
sed -i 's|ScriptedUpdates yes|ScriptedUpdates no|g' '/etc/clamav/freshclam.conf' && echo -e 'PrivateMirror https://mirror.sg.gs/clamav\nPrivateMirror https://clamav-mirror.ru\n' | tee -a '/etc/clamav/freshclam.conf' > '/dev/null' && rm -rf '/var/lib/clamav/freshclam.dat' && systemctl stop clamav-freshclam.service && freshclam -vvv && systemctl restart clamav-freshclam.service && systemctl restart clamav-daemon.service
```

### Fangfrisch

**Fangfrisch** - это аналог утилиты ClamAV FreshClam. Он позволяет загружать файлы определений вирусов, которые не являются официальными файлами ClamAV, например, от SaneSecurity , URLhaus и других. Fangfrisch был разработан с учетом безопасности и может запускаться только от непривилегированного пользователя.

Установить и настроить Fangfrisch можно по инструкции {{< uuid "96bdcb5c-a58b-58ae-9e6b-536b49bf1c51" >}}.

### Postfix: Postscreen

- В директиве `postscreen_dnsbl_threshold` заменить `2` на `3`.
- В директиву `postscreen_dnsbl_sites` добавить дополнительные спам-фильтры:

```
    psbl.surriel.com=127.0.0.2*2
    dnsbl-3.uceprotect.net=127.0.0.2*2
    all.spamrats.com=127.0.0.[2..43]*2
    bl.mailspike.net=127.0.0.[2..13]*2
    all.s5h.net=127.0.0.2*2
    multi.surbl.org=127.0.0.[2..254]*1
    list.dnswl.org=127.0.[0..255].1*-2
    list.dnswl.org=127.0.[0..255].2*-10
    list.dnswl.org=127.0.[0..255].3*-100
```
