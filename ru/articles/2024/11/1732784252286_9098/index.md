---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Работа с PostgreSQL'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
  - 'inDev'
tags:
  - 'sql'
  - 'postgresql'
  - 'pgsql'
authors:
  - 'KaiKimera'
sources:
  - 'https://www.postgresql.org/docs/current/app-createuser.html'
  - 'https://www.postgresql.org/docs/current/app-dropuser.html'
  - 'https://www.postgresql.org/docs/current/app-createdb.html'
  - 'https://www.postgresql.org/docs/current/app-pgdump.html'
  - 'https://www.postgresql.org/docs/current/app-pgrestore.html'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-11-28T11:57:34+03:00'
publishDate: '2024-11-28T11:57:34+03:00'
lastMod: '2024-11-28T11:57:34+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '3297173ead39b74fbcc6e4f5500968510a45dd71'
uuid: '3297173e-ad39-574f-9cc6-e4f550096851'
slug: '3297173e-ad39-574f-9cc6-e4f550096851'

draft: 0
---

Шпаргалка по работе с {{< tag "PostgreSQL" >}}.

<!--more-->

## Роли (пользователи)

- Посмотреть список ролей:

```bash
sudo -u 'postgres' psql -c '\du'
```

- Создать роль `DB_USER` с паролем:

```bash
sudo -u 'postgres' createuser --pwprompt 'DB_USER'
```

- Переименовать роль `DB_USER` в `DB_USER_NEW`:

```bash
sudo -u 'postgres' psql -c 'alter role DB_USER rename to DB_USER_NEW;'
```

- Сделать роль `DB_USER` супер-пользователем:

```bash
sudo -u 'postgres' psql -c 'alter role DB_USER superuser;'
```

- Изменить пароль у роли `DB_USER`:

```bash
sudo -u 'postgres' psql -c "alter role DB_USER with password 'PASSWORD';"
```

- Удалить пароль у роли `DB_USER`:

```bash
sudo -u 'postgres' psql -c 'alter role DB_USER with password null;'
```

- Удалить роль `DB_USER`:

```bash
sudo -u 'postgres' dropuser 'DB_USER'
```

- Изменить роль владельца у всех баз данных с `DB_USER` на `DB_USER_NEW`:

```bash
sudo -u 'postgres' psql -c 'reassign owned by DB_USER to DB_USER_NEW;'
```

- Изменить роль у таблиц базы данных `DB_NAME` с `DB_USER` на `DB_USER_NEW`:

```bash
sudo -u 'postgres' psql -c '\c DB_NAME' -c 'reassign owned by DB_USER to DB_USER_NEW;'
```

## Базы данных

- Посмотреть список баз данных:

```bash
sudo -u 'postgres' psql -c '\l'
```

- Посмотреть список таблиц схемы `public` в базе данных `DB_NAME`:

```bash
sudo -u 'postgres' psql -c '\c DB_NAME' -c '\dt'
```

- Посмотреть список таблиц всех схем в базе данных `DB_NAME`:

```bash
sudo -u 'postgres' psql -c '\c DB_NAME' -c '\dt *.*'
```

- Создать базу данных `DB_NAME` с владельцем `DB_USER`:

```bash
sudo -u 'postgres' createdb --owner='DB_USER' --locale='C' 'DB_NAME'
```

- Создать базу данных `DB_NAME` из шаблона `template0` с владельцем `DB_USER`:

```bash
sudo -u 'postgres' createdb --owner='DB_USER' --locale='C' --template='template0' 'DB_NAME'
```

- Удалить базу данных `DB_NAME`:

```bash
sudo -u 'postgres' dropdb --if-exists 'DB_NAME'
```

## Резервное копирование

{{< alert "warning" >}}
Использовать перенаправление для резервного копирования и восстановления базы данных не рекомендуется. Резервная копия базы данных может оказаться повреждённой.
{{< /alert >}}

- Создать резервную копию базы данных `DB_NAME` при помощи пользователя `DB_USER` и записать в файл `DB_NAME.DATE.sql.xz`:

```bash
u='DB_USER'; d='DB_NAME'; f="${d}.$( date -u '+%Y-%m-%d.%H-%M-%S' ).sql"; sudo -u 'postgres' pg_dump --host='127.0.0.1' --port='5432' --username="${u}" --password --dbname="${d}" --file="${f}" && xz "${f}" && rm -f "${f}"
```

## Восстановление

- Удалить старую базу данных `DB_NAME` (при необходимости):

```bash
sudo -u 'postgres' dropdb --if-exists 'DB_NAME'
```

- Создать новую базу данных `DB_NAME` с владельцем `DB_USER`:

```bash
sudo -u 'postgres' createdb --owner='DB_USER' 'DB_NAME'
```

- Восстановить данные в новую базу данных `DB_NAME` под пользователем `DB_USER` из файла `DB_NAME.sql.xz`:

```bash
u='DB_USER'; d='DB_NAME'; f="${d}.sql"; xz -d "${f}.xz" && psql --host='127.0.0.1' --port='5432' --username="${u}" --dbname="${d}" --file="${f}" --no-psqlrc --single-transaction
```

## Очистка и анализ

- Выполнить очистку и собрать статистику базы данных `DB_NAME`:

```bash
sudo -u 'postgres' vacuumdb --dbname='DB_NAME' --analyze
```

- Выполнить очистку и собрать статистику всех баз данных:

```bash
sudo -u 'postgres' vacuumdb --all --analyze
```

## Обновление кластера

{{< alert "important" >}}
В данном примере рассматривается сценарий обновления PostgreSQL **16** до PostgreSQL **17** на ОС **Debian**.
{{< /alert >}}

- Посмотреть список экземпляров PostgreSQL в кластере:

```bash
pg_lsclusters
```

- Установить новую версию PostgreSQL 17:

```bash
apt install postgresql-17
```

{{< accordion-item "TimescaleDB" >}}
- Установить новую версию TimescaleDB для PostgreSQL 17:

```bash
apt install timescaledb-2-postgresql-17 timescaledb-2-loader-postgresql-17
```

- Импортировать настройки TimescaleDB в конфигурацию PostgreSQL 17:

```bash
timescaledb-tune --quiet --yes && systemctl restart postgresql@17-main.service
```
{{< /accordion-item >}}

- Остановить новую версию экземпляра PostgreSQL 17 в кластере:

```bash
pg_dropcluster --stop 17 main
```

- Запустить обновление версии экземпляра PostgreSQL 16 до PostgreSQL 17 в кластере:

```bash
pg_upgradecluster 16 main
```

- Удалить версию экземпляра PostgreSQL 16 из кластера:

```bash
pg_dropcluster 16 main
```

- Посмотреть установленные пакеты для PostgreSQL 16 и удалить ненужные:

```bash
apt list --installed | grep 'postgresql.*-16'
```

## Удалённое подключение

- В файле `postgresql.conf` добавить `listen_addresses = '*'`:

```ini
# listen_addresses = 'localhost'
listen_addresses = '*'
```

- В файле `pg_hba.conf` добавить строки:

```
host    all             all             0.0.0.0/0               scram-sha-256
host    all             all             ::/0                    scram-sha-256
```

- В брандмауэре открыть порт `5432/tcp`.
