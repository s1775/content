---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Syncthing: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'install'
  - 'syncthing'
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

date: '2025-02-23T16:10:18+03:00'
publishDate: '2025-02-23T16:10:18+03:00'
lastMod: '2025-02-23T16:10:18+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '261ad6aba4a527f9cae2da4d1095e6fcf8c749e1'
uuid: '261ad6ab-a4a5-57f9-aae2-da4d1095e6fc'
slug: '261ad6ab-a4a5-57f9-aae2-da4d1095e6fc'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "Syncthing" >}}.

<!--more-->

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSLo '/etc/apt/keyrings/syncthing.gpg' 'https://syncthing.net/release-key.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/syncthing.sources`:

```bash
echo -e "X-Repolib-Name: Syncthing\nTypes: deb\nURIs: https://apt.syncthing.net\nSuites: syncthing\nComponents: stable\nSigned-By: /etc/apt/keyrings/syncthing.gpg\n" | tee '/etc/apt/sources.list.d/syncthing.sources' > '/dev/null'
```

- Скачать файл предпочтений `syncthing.pref`:

```bash
f=('syncthing'); d='/etc/apt/preferences.d'; s='https://libsys.ru/ru/2025/02/261ad6ab-a4a5-57f9-aae2-da4d1095e6fc'; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}.pref" "${s}/${i}.pref"; done
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes syncthing
```

## Настройка

- Скачать юнит для запуска {{< tag "Syncthing" >}} под обычным пользователем:

```bash
f=('syncthing@'); d='/etc/systemd/system'; s='https://libsys.ru/ru/2025/02/261ad6ab-a4a5-57f9-aae2-da4d1095e6fc'; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}.service" "${s}/${i}.service"; done
```

- Запустить сервис {{< tag "Syncthing" >}} под пользователем `USER`:

```bash
systemctl enable --now syncthing@USER.service
```
