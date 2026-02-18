---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Bind9: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'inDev'
  - 'linux'
  - 'network'
tags:
  - 'linux'
  - 'debian'
  - 'bind'
  - 'dns'
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

date: '2025-05-28T17:44:46+03:00'
publishDate: '2025-05-28T17:44:46+03:00'
lastMod: '2025-05-28T17:44:46+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '2e155edf9a477f8bf968a27047debf562a15d45e'
uuid: '2e155edf-9a47-5f8b-9968-a27047debf56'
slug: '2e155edf-9a47-5f8b-9968-a27047debf56'

draft: 1
---

Summary...

<!--more-->

## Исходные данные

- IP-адрес DNS-сервера `NS1`: `192.168.1.2`.
- IP-адрес DNS-сервера `NS2`: `192.168.1.3`.
- IP-адрес домена `example.org`: `192.168.1.5`.
- IP-адрес домена `mail.example.org`: `192.168.1.6`.

## Установка

- Установить пакеты:

```bash
apt install --yes bind9
```

## Настройка

- Настроить Bind9 на режим работы только с адресами IPv4:

```bash
mv '/etc/default/named' '/etc/default/named.orig' && cp '/etc/default/named.orig' '/etc/default/named' && sed -i 's|-u bind|-u bind -4|g' '/etc/default/named'
```

- Сделать резервную копию файлов `named.conf.options` и `named.conf.root-hints`:

```bash
for i in 'named.conf.options' 'named.conf.root-hints'; do mv "/etc/bind/${i}" "/etc/bind/${i}.orig" && touch "/etc/bind/${i}"; done
```

- Привести файл `/etc/bind/named.conf.root-hints` к следующему виду:

{{< file "named.conf.root-hints" >}}

### Authoritative Server

- Привести файл `/etc/bind/named.conf.options` к следующему виду:

{{< file "named.conf.options" >}}

#### Primary

- Создать файл прямой зоны `/etc/bind/zone.example.org` со следующим содержанием:

{{< file "zone.example.com" "dns" >}}

- Создать файл обратной зоны `/etc/bind/zone.example.org.rev` со следующим содержанием:

{{< file "zone.example.com.rev" "dns" >}}

- Создать файл локальной зоны `/etc/bind/zone.example.org.local` со следующим содержанием:

{{< file "zone.example.com.local" "dns" >}}

- Добавить в файл `/etc/bind/named.conf.local` описание локальной, прямой и обратной зоны `example.org`:

{{< file "named.conf.local.primary" >}}

#### Secondary

- Добавить в файл `/etc/bind/named.conf.local` описание локальной, прямой и обратной зоны `example.org`:

{{< file "named.conf.local.secondary" >}}

### Resolver (Caching Name Servers)

- Привести файл `/etc/bind/named.conf.options` к следующему виду:

{{< file "named.conf.options.resolver" >}}
