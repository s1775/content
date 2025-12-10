---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'iRedMail: Управление белым и чёрным списками'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'security'
  - 'terminal'
tags:
  - 'mail'
  - 'iredmail'
  - 'iredapd'
  - 'whitelist'
  - 'blacklist'
  - 'greylist'
authors:
  - 'KaiKimera'
sources:
  - 'https://docs.iredmail.org/manage.iredapd.html'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-05-25T09:02:49+03:00'
publishDate: '2024-05-25T09:02:49+03:00'
lastMod: '2024-05-25T09:02:49+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '27b4071a6d32151703c7dd77ee740e87aee34518'
uuid: '27b4071a-6d32-5517-83c7-dd77ee740e87'
slug: '27b4071a-6d32-5517-83c7-dd77ee740e87'

draft: 0
---

Белый и чёрный списки являются списками фильтрации входящих электронных писем на уровне сервера.

<!--more-->

Чёрный список позволяет заблокировать поступление электронных писем от определённого абонента, белый список, напротив, разрешить поступление электронных писем от отправителя вне зависимости от их содержания и дополнительных проверок почтовым сервером.

В {{< tag "iRedMail" >}} чёрный и белый списки контролируются плагином `amavisd_wblist` (`/opt/iredapd/plugins/amavisd_wblist.py`). Самим же плагином можно управлять при помощи скрипта `wblist_admin.py` (`/opt/iredapd/tools/wblist_admin.py`).

## Форматы адресов

Допустимые форматы адресов для белого и чёрного списков:

- `user@domain.com` - один пользователь.
- `@domain.com` / `@sub.domain.com` - один домен.
- `@.domain.com` - домен и все его суб-домены.
- `@.` - любой домен.
- `@.com` / `@.org` / `@.info` - домен верхнего уровня.
- `192.168.1.2` - один IP-адрес.
- `192.168.1.0/24` - Сеть CIDR.

## Примеры для белого списка

- Показать записи из белого списка:

```bash
python3 '/opt/iredapd/tools/wblist_admin.py' --list --whitelist
```

- Добавить в белый список IP-адрес, email, домен и суб-домен:

```bash
python3 '/opt/iredapd/tools/wblist_admin.py' --add --whitelist '192.168.1.10' 'user@domain.com' '@iredmail.org' '@.example.org'
```

- Удалить из белого списка IP-адрес, email, домен и суб-домен:

```bash
python3 '/opt/iredapd/tools/wblist_admin.py' --delete --whitelist '192.168.1.10' 'user@domain.com' '@iredmail.org' '@.example.org'
```

- Создать для локального почтового домена `@domain.com` белый список и внести в него IP-адрес `192.168.1.10` и email `user@example.org`:

```bash
python3 '/opt/iredapd/tools/wblist_admin.py' --account '@domain.com' --add --whitelist '192.168.1.10' 'user@example.org'
```

- Создать для локального почтового домена `@domain.com` и всех его суб-доменов белый список и внести в него IP-адрес `192.168.1.10` и email `user@example.org`:

```bash
python3 '/opt/iredapd/tools/wblist_admin.py' --account '@.domain.com' --add --whitelist '192.168.1.10' 'user@example.org'
```

- Создать для локального пользователя `user@domain.com` белый список и внести в него IP-адрес `192.168.1.10` и email `user@example.org`:

```bash
python3 '/opt/iredapd/tools/wblist_admin.py' --account 'user@domain.com' --add --whitelist '192.168.1.10' 'user@example.org'
```

- Показать записи из белого списка для локального почтового домена `@domain.com`:

```bash
python3 '/opt/iredapd/tools/wblist_admin.py' --account '@domain.com' --list --whitelist
```

- Показать записи из белого списка для локального пользователя `user@domain.com`:

```bash
python3 '/opt/iredapd/tools/wblist_admin.py' --account 'user@domain.com' --list --whitelist
```

## Примеры для чёрного списка

- Показать записи из чёрного списка:

```bash
python3 '/opt/iredapd/tools/wblist_admin.py' --list --blacklist
```

- Добавить в чёрный список IP-адрес, email, домен и суб-домен:

```bash
python3 '/opt/iredapd/tools/wblist_admin.py' --add --blacklist '202.96.134.133' 'bad-user@domain.com' '@bad-domain.com' '@.sub-domain.com'
```

- Добавить в чёрный список имя отправителя (`sender`):

```bash
python3 '/opt/iredapd/tools/wblist_admin.py' --add --blacklist 'sender@*'
```

- Удалить из чёрного списка IP-адрес, email, домен и суб-домен:

```bash
python3 '/opt/iredapd/tools/wblist_admin.py' --delete --blacklist '202.96.134.133' 'bad-user@domain.com' '@bad-domain.com' '@.sub-domain.com'
```

- Создать для локального почтового домена `@domain.com` чёрный список и внести в него IP-адрес `172.16.1.10` и email `bad-user@example.org`:

```bash
python3 '/opt/iredapd/tools/wblist_admin.py' --account '@domain.com' --add --blacklist '172.16.1.10' 'bad-user@example.org'
```

- Создать для локального почтового домена `@domain.com` и всех его суб-доменов чёрный список и внести в него IP-адрес `172.16.1.10` и email `bad-user@example.org`:

```bash
python3 '/opt/iredapd/tools/wblist_admin.py' --account '@.domain.com' --add --blacklist '172.16.1.10' 'bad-user@example.org'
```

- Создать для локального пользователя `user@domain.com` чёрный список и внести в него IP-адрес `172.16.1.10` и email `bad-user@example.org`:

```bash
python3 '/opt/iredapd/tools/wblist_admin.py' --account 'user@domain.com' --add --blacklist '172.16.1.10' 'bad-user@example.org'
```

- Показать записи из чёрного списка для локального пользователя `user@domain.com`:

```bash
python3 '/opt/iredapd/tools/wblist_admin.py' --account 'user@domain.com' --list --blacklist
```

## Серый список

За серый список отвечает плагин `greylisting` (`/opt/iredapd/plugins/greylisting.py`). Этим плагином можно управлять при помощи скрипта `greylisting_admin.py` (`/opt/iredapd/tools/greylisting_admin.py`).

### Примеры для серого списка

- Отключить глобальный серый список:

```bash
python3 '/opt/iredapd/tools/greylisting_admin.py' --disable --from '@.'
```

- Показать все настройки серого списка:

```bash
python3 '/opt/iredapd/tools/greylisting_admin.py' --list
```

- Показать все доменные имена отправителей из белого списка:

```bash
python3 '/opt/iredapd/tools/greylisting_admin.py' --list-whitelist-domains
```

- Показать все адреса отправителей из белого списка:

```bash
python3 '/opt/iredapd/tools/greylisting_admin.py' --list-whitelists
```

- Добавить домен отправителя `@example.org` в белый список:

```bash
python3 '/opt/iredapd/tools/greylisting_admin.py' --whitelist-domain --from '@example.org'
```

- Удалить домен отправителя `@example.org` из белого списка:

```bash
python3 '/opt/iredapd/tools/greylisting_admin.py' --remove-whitelist-domain --from '@example.org'
```

- Включить серый список для локального почтового домена `@example.org`:

```bash
python3 '/opt/iredapd/tools/greylisting_admin.py' --enable --to '@example.org'
```

- Отключить серый список для локального пользователя `user@example.org`:

```bash
python3 '/opt/iredapd/tools/greylisting_admin.py' --disable --to 'user@example.org'
```

- Отключить серый список для писем, отправленных с домена `@gmail.com` локальному пользователю `user@example.org`:

```bash
python3 '/opt/iredapd/tools/greylisting_admin.py' --disable --from '@gmail.com' --to 'user@example.org'
```

- Отключить серый список для писем, отправленных с IP-адреса `45.56.127.226`:

```bash
python3 '/opt/iredapd/tools/greylisting_admin.py' --disable --from '45.56.127.226'
```

- Удалить настройки серого списка для локального домена `@test.com`:

```bash
python3 '/opt/iredapd/tools/greylisting_admin.py' --delete --to '@test.com'
```
