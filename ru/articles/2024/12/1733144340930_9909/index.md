---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Работа с MariaDB'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
  - 'inDev'
tags:
  - 'sql'
  - 'mariadb'
  - 'debian'
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

date: '2024-12-02T15:59:02+03:00'
publishDate: '2024-12-02T15:59:02+03:00'
lastMod: '2024-12-02T15:59:02+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '8a40b3d045356aceb48072b94734b0f7726f9f22'
uuid: '8a40b3d0-4535-5ace-8480-72b94734b0f7'
slug: '8a40b3d0-4535-5ace-8480-72b94734b0f7'

draft: 0
---

Шпаргалка по работе с {{< tag "MariaDB" >}}.

<!--more-->

## Базы данных

- Посмотреть список баз данных:

```bash
echo 'show databases;' | mariadb --user='root' --password
```

- Посмотреть список таблиц в базе данных `DB_NAME`:

```bash
echo 'show full tables from DB_NAME;' | mariadb --user='root' --password
```

- Создать базу данных `DB_NAME` с кодировкой `utf8mb4` и сопоставлением `utf8mb4_unicode_ci`:

```bash
echo "create database if not exists DB_NAME character set 'utf8mb4' collate 'utf8mb4_unicode_ci';" | mariadb --user='root' --password
```

- Изменить кодировку и сопоставление базы данных на `utf8mb4` и `utf8mb4_unicode_ci` соответственно:

```bash
echo "alter database DB_NAME character set 'utf8mb4' collate 'utf8mb4_unicode_ci';" | mariadb --user='root' --password
```

- Удалить базу данных `DB_NAME`:

```bash
echo 'drop database if exists DB_NAME;' | mariadb --user='root' --password
```

## Пользователи

- Посмотреть список пользователей:

```bash
echo 'select user, host, password from mysql.user;' | mariadb --user='root' --password
```

- Создать пользователя `DB_USER` с паролем `DB_PASSWORD`:

```bash
echo "create user 'DB_USER'@'127.0.0.1' identified by 'DB_PASSWORD';" | mariadb --user='root' --password
```

- Переименовать пользователя `DB_USER@127.0.0.1` в `DB_USER@localhost`:

```bash
echo "rename user 'DB_USER'@'127.0.0.1' to 'DB_USER'@'localhost';" | mariadb --user='root' --password
```

- Изменить пароль пользователя `DB_USER` на `DB_PASSWORD_NEW`:

```bash
echo "alter user 'DB_USER'@'127.0.0.1' identified by 'DB_PASSWORD_NEW';" | mariadb --user='root' --password
```

- Удалить пользователя `DB_USER`:

```bash
echo "drop user 'DB_USER'@'127.0.0.1';" | mariadb --user='root' --password
```

- Дать права `CREATE`, `ALTER`, `DROP`, `INSERT`, `UPDATE`, `DELETE`, `SELECT`, `REFERENCES` и `RELOAD` на базу данных `DB_NAME` пользователю `DB_USER`:

```bash
echo "grant create, alter, drop, insert, update, delete, select, references, reload on DB_NAME.* to 'DB_USER'@'127.0.0.1'; flush privileges;" | mariadb --user='root' --password
```

- Дать все права на базу данных `DB_NAME` пользователю `DB_USER`:

```bash
echo "grant all on DB_NAME.* to 'DB_USER'@'127.0.0.1'; flush privileges;" | mariadb --user='root' --password
```

- Дать все права на все базы данных пользователю `DB_USER`:

```bash
echo "grant all on *.* to 'DB_USER'@'127.0.0.1'; flush privileges;" | mariadb --user='root' --password
```

- Отозвать все права пользователя `DB_USER` у базы данных `DB_NAME`:

```bash
echo "revoke all on DB_NAME from 'DB_USER'@'127.0.0.1';" | mariadb --user='root' --password
```

- Показать права пользователя `DB_USER`:

```bash
echo "show grants for 'DB_USER'@'127.0.0.1';" | mariadb --user='root' --password
```

## Экспорт

- Экспортировать базу данных `DB_NAME` и записать в файл `backup.sql.xz`:

```bash
f='backup.sql'; mariadb-dump --user='root' --password --single-transaction --databases 'DB_NAME' --result-file="${f}" && xz "${f}" && rm -f "${f}"
```

{{< alert "tip" >}}
Экспортировать данные можно при помощи конвейера:

```bash
f='backup.sql'; mariadb-dump --user='root' --password --single-transaction --databases 'DB_NAME' | xz -9 > "${f}.xz"
```
{{< /alert >}}

## Импорт

- Удалить старую базу данных `DB_NAME`:

```bash
echo 'drop database if exists DB_NAME;' | mariadb --user='root' --password
```

- Создать базу данных `DB_NAME` с кодировкой `utf8mb4` и сопоставлением `utf8mb4_unicode_ci`:

```bash
echo "create database if not exists DB_NAME character set 'utf8mb4' collate 'utf8mb4_unicode_ci';" | mariadb --user='root' --password
```

- Дать все права на базу данных `DB_NAME` пользователю `DB_USER`:

```bash
echo "grant all privileges on DB_NAME.* to 'DB_USER'@'127.0.0.1'; flush privileges;" | mariadb --user='root' --password
```

- Импортировать данные в новую базу данных `DB_NAME` из файла `DB_NAME.sql.xz`:

```bash
d='DB_NAME'; f="${d}.sql"; xz -d "${f}.xz" && mariadb --user='root' --password --database="${d}" < "${f}"
```

{{< alert "tip" >}}
Импортировать данных можно при помощи конвейера:

```bash
d='DB_NAME'; f="${d}.sql"; xzcat "${f}.xz" | mariadb --user='root' --password --database="${d}"
```
{{< /alert >}}
