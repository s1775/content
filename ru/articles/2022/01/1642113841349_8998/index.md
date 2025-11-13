---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Установка Vivaldi в Debian'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
tags:
  - 'debian'
  - 'vivaldi'
  - 'browser'
authors:
  - 'KaiKimera'
sources:
  - 'https://help.vivaldi.com/desktop/install-update/manual-setup-vivaldi-linux-repositories/'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2022-01-14T01:44:01+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'ddddd243d1828e260161d2ea7812214acfe1662f'
uuid: 'ddddd243-d182-5e26-a161-d2ea7812214a'
slug: 'ddddd243-d182-5e26-a161-d2ea7812214a'

draft: 0
---

Привет всем! В этой небольшой заметке я приведу команду, при помощи которой можно добавить репозиторий браузера {{< tag "Vivaldi" >}} в {{< tag "Debian" >}}.

<!--more-->

Установочный пакет {{< tag "Vivaldi" >}} уже выполняет указанные действия, но для этого он задействует утилиту `apt-key`, которая в {{< tag "Debian" >}} 11 имеет статус `deprecated`.

Однострочная команда по добавлению {{< tag "Vivaldi" >}} в репозиторий {{< tag "Debian" >}}'а приведена ниже. Она дробится на следующие под-команды:

1. Добавление файла `vivaldi-archive.list` в директорию `/etc/apt/sources.list.d`.
2. Скачивание файла подписи `linux_signing_key.pub` и размещение его в директорию `/etc/apt/trusted.gpg.d` с названием `vivaldi-browser.gpg`.
3. Обновление информации из репозитория при помощи команды `apt update`.

```bash
echo "deb [signed-by=/etc/apt/trusted.gpg.d/vivaldi-browser.gpg arch=$(dpkg --print-architecture)] https://repo.vivaldi.com/archive/deb/ stable main" | tee /etc/apt/sources.list.d/vivaldi-archive.list && curl -fsSL 'https://repo.vivaldi.com/archive/linux_signing_key.pub' | gpg --dearmor | tee /etc/apt/trusted.gpg.d/vivaldi-browser.gpg > /dev/null && apt update
```

После выполнения команды, установка {{< tag "Vivaldi" >}} происходит таким образом:

```bash
apt install vivaldi-stable
```
