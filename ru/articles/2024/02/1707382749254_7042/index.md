---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Первичная настройка FreeBSD'
description: ''
icon: 'far fa-file-lines'
cover:
  crop: 'top'
categories:
  - 'bsd'
tags:
  - 'freebsd'
  - 'zfs'
  - 'zsh'
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

date: '2024-02-08T11:59:09+03:00'
publishDate: '2024-02-08T11:59:09+03:00'
lastMod: '2024-02-17T04:49:00+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'f97dc3109a6a12f7a441bf7eb02087c24ad6a343'
uuid: 'f97dc310-9a6a-52f7-8441-bf7eb02087c2'
slug: 'f97dc310-9a6a-52f7-8441-bf7eb02087c2'

draft: 0
---

Надумал я как-то на днях изучить ОС {{< tag "FreeBSD" >}}. Система обладает своими особенностями, но кто работает в {{< tag "Linux" >}}, тот легко разберётся в FreeBSD.

<!--more-->

## Обновление системы

После установки базовой системы, рекомендуется запустить обновление.

- Запросить и применить обновления:

```bash
freebsd-update fetch && freebsd-update install
```

## Обновление пакетов

- Запросить и применить обновления пакетов:

```bash
pkg update -f && pkg upgrade --yes
```

## Переключение ветки пакетов

По умолчанию, {{< tag "FreeBSD" >}} берёт обновления пакетов из квартальной (`quarterly`) ветки. Если хочется получить свежие пакеты здесь и сейчас, то нужно переключить ветку на `latest`.

- Создать файл `/usr/local/etc/pkg/repos/FreeBSD.conf`:

```bash
mkdir -p /usr/local/etc/pkg/repos && echo 'FreeBSD: { url: "pkg+http://pkg.FreeBSD.org/${ABI}/latest" }' > /usr/local/etc/pkg/repos/FreeBSD.conf
```

- Обновить базу данных пакетов и обновить пакеты:

```bash
pkg update -f && pkg upgrade --yes
```

## Установка пакетов

Для установки пакетов используется пакетный менеджер `pkg`. В интернете есть информация о том, что не рекомендуется смешивать пакеты и порты. То есть, если вы уже начали использовать пакеты, то надо продолжать только ими пользоваться.

### Установка сервиса обновления микрокода CPU

- Установить пакет.
- Добавить в `rc.conf` автозапуск сервиса.
- Запустить сервис.

```bash
pkg install cpu-microcode && sysrc microcode_update_enable=YES && service microcode_update start
```

### Установка дополнительных пакетов

Для работы на сервере, я устанавливаю следующие пакеты:

```bash
pkg install bash ca_root_nss curl gnupg htop mc nano rsync rsyslog sudo zsh && sysrc syslogd_enable=NO && sysrc rsyslogd_enable=YES
```

## Настройка терминала

В своей работе я предпочитаю {{< tag "Zsh" >}}.

### Установка Zsh для пользователей

- Изменить стандартную оболочку на {{< tag "Zsh" >}} для **root**:

```bash
chsh -s zsh root
```

- Изменить стандартную оболочку на {{< tag "Zsh" >}} для **обычного пользователя**:

```bash
chsh -s zsh USERNAME
```

Где:
- `USERNAME` - логин пользователя.

## Настройка приложений и служб

### Ядро

- Увеличение лимита на дескрипторы файлов:

```bash
echo -e 'kern.maxfiles=500000\nkern.maxfilesperproc=500000' >> '/etc/sysctl.conf'
```

### ZFS

- Отключение `atime`:

```bash
zfs set atime=off zroot
```

### Zsh

- Скачиваем конфигурацию:

```bash
curl -fsSLo '/usr/local/etc/zshrc.grml' 'https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc'
```

- Редактируем `~/.zshrc`:

```bash
echo -e ". '/usr/local/etc/zshrc.grml'\nexport GPG_TTY=\$(tty)" >> ~/.zshrc
```

### SSHD

- Настройка параметров подключения по SSH:

```bash
sed -i '' -e 's/#Port 22/Port 8022/g' -e 's/#IgnoreRhosts/IgnoreRhosts/g' -e 's/#MaxAuthTries 6/MaxAuthTries 2/g' -e 's/#PermitEmptyPasswords/PermitEmptyPasswords/g' -e 's/#PermitRootLogin/PermitRootLogin/g' -e 's/#X11Forwarding/X11Forwarding/g' -e 's/#LogLevel INFO/LogLevel VERBOSE/g' '/etc/ssh/sshd_config'
```

#### Параметры

- `Port 8022` - порт SSH.
- `IgnoreRhosts yes` - не учитывать содержимое файлов `.rhosts` и `.shosts`.
- `MaxAuthTries 2` - количество попыток авторизации.
- `PermitEmptyPasswords no` - запретить вход с пустым паролем.
- `PermitRootLogin no` - запретить вход под пользователем `root`.
- `X11Forwarding no` - отключить проброс приложений X11.
- `LogLevel VERBOSE` - включить расширенное логирование.
