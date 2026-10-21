---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Podman: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'install'
  - 'podman'
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

date: '2025-03-02T23:36:20+03:00'
publishDate: '2025-03-02T23:36:20+03:00'
lastMod: '2025-03-02T23:36:20+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'dc9141c42dd5a4cfd40b8468694b9250a2a5b77a'
uuid: 'dc9141c4-2dd5-54cf-b40b-8468694b9250'
slug: 'dc9141c4-2dd5-54cf-b40b-8468694b9250'

draft: 1
---

Инструкция по установке и настройке {{< tag "Podman" >}}.

<!--more-->

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
. '/etc/os-release' && curl -fsSL "https://download.opensuse.org/repositories/home:alvistack/Debian_${VERSION_ID}/Release.key" | gpg --dearmor -o '/etc/apt/keyrings/alvistack.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/alvistack.sources`:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: AlviStack\nTypes: deb\nURIs: https://download.opensuse.org/repositories/home:/alvistack/Debian_${VERSION_ID}\nSuites: /\nSigned-By: /etc/apt/keyrings/alvistack.gpg"| tee '/etc/apt/sources.list.d/alvistack.sources' > '/dev/null'
```

- Скачать файлы предпочтений в `/etc/apt/preferences.d/`:

```bash
f=('alvistack'); d='/etc/apt/preferences.d'; s='https://libsys.ru/ru/2025/03/dc9141c4-2dd5-54cf-b40b-8468694b9250'; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}.pref" "${s}/${i}.pref"; done
```

## Установка

- Установить {{< tag "Podman" >}}:

```bash
apt update && apt install --yes -t 'l=home:alvistack' podman netavark aardvark-dns passt
```

- Скачать файлы конфигурации в `/etc/containers/`:

```bash
f=('containers' 'storage'); d='/etc/containers'; s='https://libsys.ru/ru/2025/03/dc9141c4-2dd5-54cf-b40b-8468694b9250'; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}.conf" "${s}/${i}.conf"; done
```

- Привести `chain forward` в конфигурации `nftables` к следующему виду:

```
table inet filter {
  chain forward {
    type filter hook forward priority 0; policy drop;

    ct state { established, related } accept
    ct state invalid drop
    iifname "podman*" accept
    oifname "podman*" accept
    ct status dnat accept
  }
}
```

- Перезапустить сетевой стек `podman`:

```bash
podman network reload --all
```
