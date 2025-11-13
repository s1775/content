---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Fail2Ban: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'install'
  - 'fail2ban'
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

date: '2025-02-25T17:00:31+03:00'
publishDate: '2025-02-25T17:00:31+03:00'
lastMod: '2025-02-25T17:00:31+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'e69f2ca5e02c2aa274ef43b0b443b67e2c650626'
uuid: 'e69f2ca5-e02c-5aa2-a4ef-43b0b443b67e'
slug: 'e69f2ca5-e02c-5aa2-a4ef-43b0b443b67e'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "Fail2Ban" >}}.

<!--more-->

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes fail2ban python3-systemd rsyslog
```

## Настройка

- Скачать файлы локальной конфигурации в `/etc/fail2ban/`:

```bash
f=('fail2ban' 'jail'); d='/etc/fail2ban'; s='https://libsys.ru/ru/2025/02/e69f2ca5-e02c-5aa2-a4ef-43b0b443b67e'; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}.local" "${s}/${i}.local"; done
```

- Скачать файлы локальной конфигурации в `/etc/fail2ban/action.d/`:

```bash
f=('nftables-common'); d='/etc/fail2ban/action.d'; s='https://libsys.ru/ru/2025/02/e69f2ca5-e02c-5aa2-a4ef-43b0b443b67e'; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}.local" "${s}/action.${i}.local"; done
```

## Тюрьмы

### SSH

- Создать файл конфигурации тюрьмы `/etc/fail2ban/jail.d/sshd.local` со следующим содержанием:

{{< file "jail.sshd.local" "ini" >}}

### Angie: BotSearch

- Создать файл конфигурации тюрьмы `/etc/fail2ban/jail.d/angie.botsearch.local` со следующим содержанием:

{{< file "jail.angie-botsearch.local" "ini" >}}

### Angie: LimitReq

- Создать файл конфигурации тюрьмы `/etc/fail2ban/jail.d/angie.limit-req.local` со следующим содержанием:

{{< file "jail.angie-limit-req.local" "ini" >}}

- В файл конфигурации Angie добавить следующие строки:

```nginx
http {
  limit_req_zone $binary_remote_addr zone=main:10m rate=50r/s;
  server {
    limit_req zone=main burst=60 nodelay;
  }
}
```

### Asterisk

- Создать файл конфигурации тюрьмы `/etc/fail2ban/jail.d/asterisk.local` со следующим содержанием:

{{< file "jail.asterisk.local" "ini" >}}

### Recidive

Настройка тюрьмы для долгосрочной блокировки повторяющихся инцидентов.

- Создать файл конфигурации тюрьмы `/etc/fail2ban/jail.d/recidive.local` со следующим содержанием:

{{< file "jail.recidive.local" "ini" >}}

#### Примеры

- Заблокировать IP-адрес `192.168.1.2` на срок 1 неделю:

```bash
fail2ban-client set 'recidive' banip '192.168.1.2'
```

### Manual

Настройка тюрьмы для перманентной блокировки.

- Создать файл конфигурации фильтра `/etc/fail2ban/filter.d/manual.conf` со следующим содержанием:

{{< file "filter.manual.conf" "ini" >}}

- Создать файл конфигурации тюрьмы `/etc/fail2ban/jail.d/manual.local` со следующим содержанием:

{{< file "jail.manual.local" "ini" >}}

#### Примеры

- Поместить IP-адрес `192.168.1.2` в тюрьму `manual` для постоянной блокировки:

```bash
fail2ban-client set 'manual' banip '192.168.1.2'
```

- Удалить IP-адрес `192.168.1.2` из тюрьмы `manual`:

```bash
fail2ban-client set 'manual' unbanip '192.168.1.2'
```

- Прочитать файл `ip.blacklist.txt` с IP-адресами и поместить их в тюрьму `manual` для постоянной блокировки:

```bash
grep -v '^#' 'ip.blacklist.txt' | while read IP; do fail2ban-client set 'manual' banip "${IP}"; done
```

## Использование

- Посмотреть статус всех тюрем:

```bash
fail2ban-client status
```

- Посмотреть статус тюрьмы `JAIL_NAME`:

```bash
fail2ban-client status 'JAIL_NAME'
```

- Посмотреть статус всех тюрем в компактном виде:

```bash
fail2ban-client banned
```

- Заблокировать IP-адрес `192.168.1.2` в тюрьме `JAIL_NAME`:

```bash
fail2ban-client set 'JAIL_NAME' banip '192.168.1.2'
```

- Разблокировать IP-адрес `192.168.1.2` в тюрьме `JAIL_NAME`:

```bash
fail2ban-client set 'JAIL_NAME' unbanip '192.168.1.2'
```

- Разблокировать IP-адрес `192.168.1.2` во всех тюрьмах:

```bash
fail2ban-client unban '192.168.1.2'
```

## Скрипты

- Показать список заблокированных IP-адресов, разделённых по тюрьмам:

```bash
for i in $( fail2ban-client status | grep 'Jail list:' | sed 's|.*:||;s|,||g' ); do echo "Jail: ${i}"; fail2ban-client status "${i}" | grep 'Banned IP'; done
```
