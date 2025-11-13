---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'MySQL: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'mysql'
  - 'install'
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

date: '2025-02-06T11:00:58+03:00'
publishDate: '2025-02-06T11:00:58+03:00'
lastMod: '2025-02-06T11:00:58+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'f29ee2b5891d891eeb2169f494cd11c0bb2c6abf'
uuid: 'f29ee2b5-891d-591e-8b21-69f494cd11c0'
slug: 'f29ee2b5-891d-591e-8b21-69f494cd11c0'

draft: 1
---

Summary...

<!--more-->

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://libsys.ru/ru/2025/02/f29ee2b5-891d-591e-8b21-69f494cd11c0/mysql.asc' | gpg --dearmor -o '/etc/apt/keyrings/mysql.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/mysql.sources`:

```bash
v='8.4-lts'; . '/etc/os-release' && echo -e "X-Repolib-Name: MySQL\nTypes: deb\nURIs: http://repo.mysql.com/apt/${ID}\n#URIs: https://mirror.yandex.ru/mirrors/repo.mysql.com/apt/${ID}\nSuites: ${VERSION_CODENAME}\nComponents: mysql-${v}\nSigned-By: /etc/apt/keyrings/mysql.gpg\n" | tee '/etc/apt/sources.list.d/mysql.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes mysql-server
```

## Настройка

### Основная конфигурация

- Создать файл `/etc/mysql/mysql.conf.d/mysqld.local.cnf` для конфигурации `mysqld` со следующим содержанием:

{{< file "mysql.mysqld.local.cnf" "ini" >}}

- Создать файл `/etc/mysql/mysql.conf.d/mysqldump.local.cnf` для конфигурации `mysqldump` со следующим содержанием:

{{< file "mysql.mysqldump.local.cnf" "ini" >}}

- Удалить файлы в директории `/var/lib/mysql` и инициализировать стандартные базы данных:

```bash
rm -rf /var/lib/mysql/* && mysqld --initialize --user='mysql'
```

- Узнать временный пароль пользователя `root`:

```bash
cat '/var/log/mysql/error.log' | grep 'MY-010454'
```

- Сменить пароль пользователя `root`, добавить пользователей `root@127.0.0.1` и `root@::1`:

```bash
 p='PASSWORD'; echo "alter user 'root'@'localhost' identified by '${p}'; create user 'root'@'127.0.0.1' identified by '${p}'; create user 'root'@'::1' identified by '${p}';" | mariadb --user='root' --password --connect-expired-password
```
