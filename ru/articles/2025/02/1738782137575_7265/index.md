---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'PHP: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'apt'
  - 'php'
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

date: '2025-02-05T22:02:21+03:00'
publishDate: '2025-02-05T22:02:21+03:00'
lastMod: '2025-02-05T22:02:21+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '9bd1261d38420859e2022e1d7a5ba9f44360148d'
uuid: '9bd1261d-3842-5859-8202-2e1d7a5ba9f4'
slug: '9bd1261d-3842-5859-8202-2e1d7a5ba9f4'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "PHP" >}}.

<!--more-->

## Экспорт параметров

- Экспортировать заранее подготовленные параметры в переменные окружения:

```bash
export PHP_VER='8.4'
```

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSLo '/etc/apt/keyrings/php.gpg' 'https://libsys.ru/ru/2025/02/9bd1261d-3842-5859-8202-2e1d7a5ba9f4/php.gpg'
```

{{< alert "tip" >}}
Ключ можно скачать со следующих зеркал:

```bash
curl -fsSLo '/etc/apt/keyrings/php.gpg' 'https://packages.sury.su/php/apt.gpg'
```

```bash
curl -fsSLo '/etc/apt/keyrings/php.gpg' 'https://mirror.metanet.ch/sury/php/apt.gpg'
```

```bash
curl -fsSLo '/etc/apt/keyrings/php.gpg' 'https://debian.octopuce.fr/sury-php/apt.gpg'
```

```bash
curl -fsSLo '/etc/apt/keyrings/php.gpg' 'https://mirror.yandex.ru/mirrors/packages.sury.org/php/apt.gpg'
```

```bash
curl -fsSLo '/etc/apt/keyrings/php.gpg' 'https://ftp.mpi-inf.mpg.de/mirrors/linux/mirror/deb.sury.org/repositories/php/apt.gpg'
```
{{< /alert >}}

- Создать файл репозитория `/etc/apt/sources.list.d/php.sources`:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: PHP\nTypes: deb\nURIs: https://packages.sury.org/php\n#URIs: https://packages.sury.su/php\n#URIs: https://mirror.metanet.ch/sury/php\n#URIs: https://debian.octopuce.fr/sury-php\n#URIs: https://mirror.yandex.ru/mirrors/packages.sury.org/php\n#URIs: https://ftp.mpi-inf.mpg.de/mirrors/linux/mirror/deb.sury.org/repositories/php\nSuites: ${VERSION_CODENAME}\nComponents: main\nSigned-By: /etc/apt/keyrings/php.gpg\n" | tee '/etc/apt/sources.list.d/php.sources' > '/dev/null'
```

## Установка

- Установить пакеты:

```bash
[[ ! -v 'PHP_VER' ]] && return; apt update && apt install --yes php${PHP_VER} php${PHP_VER}-{fpm,bcmath,bz2,cli,curl,gd,gmp,imagick,imap,intl,ldap,mbstring,memcached,mysql,odbc,opcache,pgsql,redis,uploadprogress,xml,zip,zstd}
```

## Настройка

- Скачать файлы локальной конфигурации в `/etc/php/<VER>/fpm/conf.d/`:

```bash
[[ ! -v 'PHP_VER' ]] && return; f=('php' 'php.cgi' 'php.date' 'php.mail' 'php.mbstring'); d="/etc/php/${PHP_VER}/fpm/conf.d"; s='https://libsys.ru/ru/2025/02/9bd1261d-3842-5859-8202-2e1d7a5ba9f4'; for i in "${f[@]}"; do curl -fsSLo "${d}/90-${i##*.}.local.ini" "${s}/${i}.ini"; done
```

- Скачать файл конфигурации пула `main` в `/etc/php/<VER>/fpm/pool.d/`:

```bash
[[ ! -v 'PHP_VER' ]] && return; f=('main'); d="/etc/php/${PHP_VER}/fpm/pool.d"; s='https://libsys.ru/ru/2025/02/9bd1261d-3842-5859-8202-2e1d7a5ba9f4'; [[ ! -d '/var/log/php-fpm' ]] && mkdir '/var/log/php-fpm'; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}.conf" "${s}/pool.${i}.conf"; done
```
