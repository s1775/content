---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Docker: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'install'
  - 'docker'
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

date: '2025-03-02T23:22:18+03:00'
publishDate: '2025-03-02T23:22:18+03:00'
lastMod: '2025-03-02T23:22:18+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '654d7f5510b018e0a57c26e445b44ab2cd79ca4f'
uuid: '654d7f55-10b0-58e0-a57c-26e445b44ab2'
slug: '654d7f55-10b0-58e0-a57c-26e445b44ab2'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "Docker" >}}.

<!--more-->

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://download.docker.com/linux/debian/gpg' | gpg --dearmor -o '/etc/apt/keyrings/docker.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/docker.sources`:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: Docker\nTypes: deb\nURIs: https://download.docker.com/linux/debian\nSuites: ${VERSION_CODENAME}\nComponents: stable\nSigned-By: /etc/apt/keyrings/docker.gpg"| tee '/etc/apt/sources.list.d/docker.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes iptables docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## Настройка

- Скачать файл конфигурации службы `daemon.json` в `/etc/docker/`:

```bash
f=('daemon'); d='/etc/docker'; s='https://libsys.ru/ru/2025/02/654d7f55-10b0-58e0-a57c-26e445b44ab2'; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}.json" "${s}/${i}.json"; done
```

- Перезапустить службу:

```bash
systemctl restart docker.service
```
