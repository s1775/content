---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Автоматическая установка SECURITY-обновлений в Debian'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'security'
tags:
  - 'debian'
  - 'upgrade'
  - 'apt'
  - 'unattended'
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

date: '2024-12-17T10:48:17+03:00'
publishDate: '2024-12-17T10:48:17+03:00'
lastMod: '2024-12-17T10:48:17+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '179f936a0cd21508609a72d30e29ae55afdcea3a'
uuid: '179f936a-0cd2-5508-809a-72d30e29ae55'
slug: '179f936a-0cd2-5508-809a-72d30e29ae55'

draft: 0
---

Готовая конфигурация для автоматической установки SECURITY-обновлений в {{< tag "Debian" >}}.

<!--more-->

## Установка

- Установить пакеты `unattended-upgrades`, `apt-listchanges` и `python3-gi`:

```bash
apt install --yes unattended-upgrades apt-listchanges python3-gi
```

## Настройка

- Открыть файл `/etc/apt/apt.conf.d/50unattended-upgrades` и **закомментировать** строки:

```c {hl_lines=["9-11"],file="50unattended-upgrades"}
Unattended-Upgrade::Origins-Pattern {
        // Codename based matching:
        // This will follow the migration of a release through different
        // archives (e.g. from testing to stable and later oldstable).
        // Software will be the latest available for the named release,
        // but the Debian release itself will not be automatically upgraded.
//      "origin=Debian,codename=${distro_codename}-updates";
//      "origin=Debian,codename=${distro_codename}-proposed-updates";
//      "origin=Debian,codename=${distro_codename},label=Debian";
//      "origin=Debian,codename=${distro_codename},label=Debian-Security";
//      "origin=Debian,codename=${distro_codename}-security,label=Debian-Security";

        // Archive or Suite based matching:
        // Note that this will silently match a different release after
        // migration to the specified archive (e.g. testing becomes the
        // new stable).
//      "o=Debian,a=stable";
//      "o=Debian,a=stable-updates";
//      "o=Debian,a=proposed-updates";
//      "o=Debian Backports,a=${distro_codename}-backports,l=Debian Backports";
};
```

- Создать файл `/etc/apt/apt.conf.d/52unattended-upgrades-local` со следующим содержанием:

{{< file "52unattended-upgrades-local" "c" >}}

- Создать файл `/etc/apt/apt.conf.d/20auto-upgrades` со следующим содержанием:

{{< file "20auto-upgrades" "c" >}}

- Запустить автоматическое обновление вручную для отладки:

```bash
unattended-upgrade -d
```
