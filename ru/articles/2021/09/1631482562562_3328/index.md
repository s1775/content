---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Proxmox VE: Установка на Debian 11 (Bullseye)'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'inDev'
tags:
  - 'proxmox'
  - 'debian'
authors:
  - 'KaiKimera'
sources:
  - 'https://pve.proxmox.com/wiki/Install_Proxmox_VE_on_Debian_11_Bullseye'
  - 'https://pve.proxmox.com/wiki/Network_Configuration'
license: 'CC-BY-SA-4.0'
complexity: '1'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2021-09-13T00:36:02+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '1cf305cd85d09e02aabbe01346bfee0fe29ed687'
uuid: '1cf305cd-85d0-5e02-aabb-e01346bfee0f'
slug: '1cf305cd-85d0-5e02-aabb-e01346bfee0f'

draft: 0
---

В этой небольшой заметке, я расскажу как установить {{< tag "Proxmox" >}} VE на чистый {{< tag "Debian" >}} 11 ({{< tag "Bullseye" >}}).

<!--more-->

## Подготовка

Для начала необходимо отредактировать файл `/etc/hosts`, прописав туда IP сервера, на который будет устанавливаться наш {{< tag "Proxmox" >}} VE:

```text
127.0.0.1   localhost
127.0.1.1   localhost.localdomain     localhost

# Proxmox
10.0.1.1    srv-vm.home.local         srv-vm
```

Для проверки, можно выполнить команду `hostname --ip-address`, которая вернёт IP сервера, указанного в `/etc/hosts` выше.

## Добавление репозиториев

Добавим репозиторий {{< tag "Proxmox" >}} VE:

```bash
echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bullseye pve-no-subscription" > /etc/apt/sources.list.d/pve.list
```

Скачаем и установим ключ репозитория:

```bash
curl 'https://enterprise.proxmox.com/debian/proxmox-release-bullseye.gpg' -o /etc/apt/trusted.gpg.d/pve.gpg
```

Обновим базу пакетов {{< tag "APT" >}} и саму систему:

```bash
apt update && apt full-upgrade
```

## Установка пакетов

Начнём установку пакетов командой:

```bash
apt install proxmox-ve postfix open-iscsi
```

Стоит заметить, что устанавливается {{< tag "Postfix" >}}, он необходим для отправки писем от {{< tag "Proxmox" >}} VE. Но мне в локальной сети такая функция не нужна. При установке, {{< tag "Postfix" >}} спросит в каком режиме ему необходимо будет работать. Я выбираю **local only**.

## Исправление ошибок

После установки {{< tag "Proxmox" >}} VE через пакетны менеджер {{< tag "APT" >}}, я столкнулся с некоторыми проблемами. Не знаю, может быть они будут отсутствовать, если устанавливать {{< tag "Proxmox" >}} VE при помощи его отдельного файла {{< tag "ISO" >}}...

### lvm2-activation-generator: lvmconfig failed

Для исправления ошибки `lvm2-activation-generator: lvmconfig failed`, необходимо в файле `/etc/lvm/lvm.conf` изменить параметр `event_activation`, а именно рас-комментировать и установить в `0`:

```text
global {
  <...>
  # Configuration option global/event_activation.
  # Activate LVs based on system-generated device events.
  # When a device appears on the system, a system-generated event runs
  # the pvscan command to activate LVs if the new PV completes the VG.
  # Use auto_activation_volume_list to select which LVs should be
  # activated from these events (the default is all.)
  # When event_activation is disabled, the system will generally run
  # a direct activation command to activate LVs in complete VGs.
  # This configuration option has an automatic default value.
  # event_activation = 1
  <...>
}
```

```text
global {
  <...>
  # Configuration option global/event_activation.
  # Activate LVs based on system-generated device events.
  # When a device appears on the system, a system-generated event runs
  # the pvscan command to activate LVs if the new PV completes the VG.
  # Use auto_activation_volume_list to select which LVs should be
  # activated from these events (the default is all.)
  # When event_activation is disabled, the system will generally run
  # a direct activation command to activate LVs in complete VGs.
  # This configuration option has an automatic default value.
  event_activation = 0
  <...>
}
```

### Не поднимается  интерфейс

После установки, у меня перестал автоматически подниматься сетевой интерфейс. Может быть, в отдельном образе {{< tag "ISO" >}} {{< tag "Proxmox" >}} VE такой проблемы нет, потому что при установке с отдельного образа {{< tag "ISO" >}}, он запрашивает у администратора параметры сети. Но если устанавливать {{< tag "Proxmox" >}} VE через пакетную систему Debian, то никаких запросов не появляется. В общем, я сделал так (`/etc/network/interfaces`):

```text
auto lo
iface lo inet loopback

iface enp3s0 inet manual

auto vmbr0
iface vmbr0 inet static
  address 10.0.1.1/16
  gateway 10.0.0.1
  bridge-ports enp3s0
  bridge-stp off
  bridge-fd 0
```

Конкретно, тут я добавил блок виртуального соединения:

```text
auto vmbr0
iface vmbr0 inet static
  address 10.0.1.1/16
  gateway 10.0.0.1
  bridge-ports enp3s0
  bridge-stp off
  bridge-fd 0
```

Где указал мост с физической картой `enp3s0`. Саму же карту `enp3s0` я перевёл в режим `manual`. После этого, сетевой интерфейс на сервере заработал в штатном режиме.

На этом консольная настройка сервера виртуализации закончена. Настройка самого {{< tag "Proxmox" >}}'а можно выполнять уже в удобном web-интерфейсе.
