---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Настройка времени в Linux'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'terminal'
  - 'linux'
tags:
  - 'time'
  - 'timezone'
  - 'hwclock'
authors:
  - 'KaiKimera'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2021-05-15T19:22:34+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '8bdb6bfec516beed99e405003575d2109a5bd949'
uuid: '8bdb6bfe-c516-5eed-a9e4-05003575d210'
slug: '8bdb6bfe-c516-5eed-a9e4-05003575d210'

draft: 1
---

Summary...

<!--more-->

## Системные часы

```bash
timedatectl status
```

```text
               Local time: Sat 2021-05-15 19:44:40 MSK
           Universal time: Sat 2021-05-15 16:44:40 UTC
                 RTC time: Sat 2021-05-15 16:44:40
                Time zone: Europe/Moscow (MSK, +0300)
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no
```

```bash
timedatectl set-ntp true
```

```bash
systemctl status systemd-timesyncd
```

```bash
systemctl enable systemd-timesyncd --now
```

```bash
timedatectl list-timezones
```

```bash
timedatectl set-timezone Europe/Moscow
```

```bash
timedatectl set-time "yyyy-MM-dd hh:mm:ss"
```

```bash
timedatectl set-time "2014-05-26 11:13:54"
```

## Аппаратные часы

```bash
hwclock --show
```

```bash
hwclock --systohc
```
