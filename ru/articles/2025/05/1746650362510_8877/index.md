---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'DB: Резервное копирование и восстановление базы данных'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'scripts'
  - 'inDev'
tags:
  - 'debian'
  - 'gpg'
  - 'mariadb'
  - 'mysql'
  - 'openssl'
  - 'pgsql'
  - 'postgresql'
  - 'rsync'
authors:
  - 'KaiKimera'
sources:
  - 'https://dev.mysql.com/doc/refman/en/mysql.html'
  - 'https://dev.mysql.com/doc/refman/en/mysqldump.html'
  - 'https://mariadb.com/kb/en/mariadb-command-line-client'
  - 'https://mariadb.com/kb/en/mariadb-dump'
  - 'https://www.postgresql.org/docs/current/app-pgdump.html'
  - 'https://www.postgresql.org/docs/current/app-psql.html'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2025-05-07T23:39:24+03:00'
publishDate: '2025-05-07T23:39:24+03:00'
lastMod: '2025-05-07T23:39:24+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '57f8f8c0b963e708d310129ea98a2423766812bb'
uuid: '57f8f8c0-b963-5708-b310-129ea98a2423'
slug: '57f8f8c0-b963-5708-b310-129ea98a2423'

draft: 0
---

Написал [скрипт](https://github.com/pkgstore/bash-backup-db), при помощи которого можно делать резервные копии баз данных {{< tag "PgSQL" >}} / {{< tag "MariaDB" >}} и отправлять их в удалённое хранилище через {{< tag "Rsync" >}}.

<!--more-->

## Скрипт

Скрипт состоит из следующих компонентов:

- `app.backup_db.conf` - файл с настройками.
- `app.backup_db.sh` - приложение.
- `job.backup_db` - задание для CRON.

### Установка

- Установить пакеты:

```bash
apt install --yes sshpass
```

- Скачать и установить скрипт:

```bash
curl -sL 'https://raw.githubusercontent.com/pkgstore/bash-install/refs/heads/main/install.sh' | bash -s -- '/root/apps/backup' 'bash-backup-db' 'main'
```

#### MongoDB

- Запустить командную оболочку `mongosh`, создать пользователя `backup` с паролем `PASSWORD` и дать ему роль `backup`:

```bash
mongosh --username 'root' --authenticationDatabase 'admin' --eval 'use admin' --eval 'db.createUser({user: "backup", pwd: "PASSWORD", roles: [{role: "backup", db: "admin"}]})'
```

#### MariaDB

- Создать пользователя `backup@127.0.0.1` с паролем `PASSWORD` и дать ему разрешения на все базы данных:

```bash
echo "create user 'backup'@'127.0.0.1' identified by 'PASSWORD'; grant all on *.* to 'backup'@'127.0.0.1'; flush privileges;" | mariadb --user='root' --password
```

#### PostgreSQL

- Создать пользователя `backup` и сделать его супер-пользователем:

```bash
sudo -u 'postgres' createuser --pwprompt 'backup' && sudo -u 'postgres' psql -c 'alter role backup superuser;'
```

### Настройка

{{< alert "tip" >}}
Некоторые параметры, указанные здесь, отсутствуют в конфигурационном файле. Это означает, что они имеют значения, установленные по умолчанию. Для переопределения этих значений, необходимо добавить отсутствующие параметры в конфигурационный файл.
{{< /alert >}}

#### База данных

Общие параметры резервного копирования базы данных.

- `DB_SRC=('mysql.DB_1' 'pgsql.DB_2')` - массив названий баз данных для резервного копирования. Название базы данных должно содержать имя DBMS, разделённое точкой (`.`).
- `DB_HOST='127.0.0.1'` - хост для соединения с DBMS. По умолчанию: `127.0.0.1`.
- `DB_PORT='3306'` - порт для соединения с DBMS. По умолчанию: `3306` (`mysql`) / `5432` (`pgsql`).
- `DB_USER='root'` - имя пользователь для соединения с DBMS. По умолчанию: `root` (`mysql`) / `postgres` (`pgsql`).
- `DB_PASS='PASSWORD'` - пароль для соединения с DBMS.
- `FS_DST='/tmp/backup_db'` - директория для хранения дампов баз данных.
- `FS_TPL="$( date -u '+%m' )/$( date -u '+%d' )-$( date -u '+%H' )"` - шаблон структуры директорий для хранения дампов баз данных.
- `FS_DAYS='30'` - дни, по прошествии которых, старые файлы будут удалены. По умолчанию: `30`.

##### MySQL

Индивидуальные параметры для резервного копирования базы дынных СУБД MySQL/MariaDB.

- `MYSQL_ST=1` - добавить опцию `--single-transaction` при создании резервной копии БД MySQL.
- `MYSQL_SLT=1` - добавить опцию `--skip-lock-tables` при создании резервной копии БД MySQL.

##### PostgreSQL

Индивидуальные параметры для резервного копирования базы дынных СУБД PostgreSQL.

- `PGSQL_CLN=1` - добавить опцию `--clean` при создании резервной копии БД PgSQL.
- `PGSQL_FMT='plain'` - добавить опцию `--format=FORMAT`.
  - `plain` - сформировать текстовый SQL-скрипт. Это поведение по умолчанию.
  - `custom` - выгрузить данные в специальном архивном формате, пригодном для дальнейшего использования утилитой `pg_restore`. Наряду с форматом `directory` является наиболее гибким форматом, позволяющим вручную выбирать и сортировать восстанавливаемые объекты. Вывод в этом формате по умолчанию сжимается.
- `PGSQL_IE=1` - добавить опцию `--if-exists` при создании резервной копии БД PgSQL.
- `PGSQL_NO=1` - добавить опцию `--no-owner` при создании резервной копии БД PgSQL.
- `PGSQL_NP=1` - добавить опцию `--no-privileges` при создании резервной копии БД PgSQL.
- `PGSQL_QAI=1` - добавить опцию `--quote-all-identifiers` при создании резервной копии БД PgSQL.
- `PGSQL_Z=zstd:5` - устанавливает метод и уровень сжатия. Используется только при формате резервного копирования `custom`. По умолчанию: `zstd:5`.
  - `gzip` - метод сжатия `GZip`.
  - `lz4` - метод сжатия `LZ4`.
  - `zstd` - метод сжатия `ZSTD`.

#### Шифрование

Параметры шифрования резервной копии базы данных.

- `ENC_ON=0` - включение / отключение функции шифрования.
- `ENC_APP='gpg'` - приложение для шифрования.
  - `gpg` - для шифрования использовать OpenGPG.
  - `ssl` - для шифрования использовать OpenSSL.
- `ENC_PASS='SECRET'` - секретная фраза для шифрования.
- `ENC_GPG_CIPHER='AES256'` - алгоритм симметричного шифрования GPG. По умолчанию: `AES256`.
- `ENC_GPG_DIGEST='SHA512'` - алгоритм хеша для преобразования секретной фразы при симметричном шифровании GPG. По умолчанию: `SHA512`.
- `ENC_GPG_COUNT='65536'` - указать, сколько циклов преобразования будет проходить секретная фраза для симметричного шифрования GPG. По умолчанию: `65536`.
- `ENC_SSL_CIPHER='aes-256-cfb'` - алгоритм симметричного шифрования SSL. По умолчанию: `aes-256-cfb`.
- `ENC_SSL_DIGEST='sha512'` - алгоритм хеша для преобразования секретной фразы при симметричном шифровании SSL. По умолчанию: `sha512`.
- `ENC_SSL_COUNT='65536'` - указать, сколько циклов преобразования будет проходить секретная фраза для симметричного шифрования SSL. По умолчанию: `65536`.

#### SSH FS

Параметры монтирования удалённого хранилища при помощи `sshfs`.

- `SSH_ON=0` - включение / отключение функции монтирования удалённого хранилища через `sshfs`.
- `SSH_HOST='192.168.1.2'` - IP-адрес удалённого хранилища для соединения по SSH.
- `SSH_PORT='22'` - порт удалённого хранилища для соединения по SSH. По умолчанию: `22`.
- `SSH_USER='root'` - имя пользователя удалённого хранилища для соединения по SSH. По умолчанию: `root`.
- `SSH_PASS='PASSWORD'` - пароль пользователя удалённого хранилища для соединения по SSH.
- `SSH_DST='/remote/directory'` - директория удалённого хранилища для синхронизации дампов базы данных.
- `SSH_MNT='/mnt/backup'` - директория, в которую будет монтироваться удалённое хранилище.

#### RSYNC

Параметры синхронизации резервной копии базы данных с удалённым хранилищем (используется `rsync`).

- `RSYNC_ON=0` - включение / отключение функции синхронизации.
- `RSYNC_HOST='192.168.1.2'` - IP-адрес удалённого хранилища для соединения по SSH.
- `RSYNC_PORT='22'` - порт удалённого хранилища для соединения по SSH. По умолчанию: `22`.
- `RSYNC_USER='root'` - имя пользователя удалённого хранилища для соединения по SSH. По умолчанию: `root`.
- `RSYNC_PASS='PASSWORD'` - пароль пользователя удалённого хранилища для соединения по SSH.
- `RSYNC_DST=0` - директория удалённого хранилища для синхронизации дампов базы данных.
- `RSYNC_DEL=0` - параметр добавляет опцию `--delete`, которая удаляет посторонние файлы на удалённом хранилище.
- `RSYNC_RSF=0` - параметр добавляет опцию `--remove-source-files`, которая удаляет исходные файлы после синхронизации с удалённым хранилищем.
- `RSYNC_PED=0` - параметр добавляет опцию `--prune-empty-dirs`, которая исключает из процесса синхронизации пустые директории.
- `RSYNC_CVS=0` - параметр добавляет опцию `--cvs-exclude`, которая исключает из процесса синхронизации нежелательные элементы, например: `CWRCS`, `SCCS`, `CVS`, `CVS.adm`, `RCSLOG`, `cvslog.*`, `tags`, `TAGS`, `.make.state`, `.nse_depinfo`, `*~`, `#*`, `.#*`, `,*`, `_$*`, `*$`, `*.old`, `*.bak`, `*.BAK`, `*.orig`, `*.rej`, `.del-*`, `*.a`, `*.olb`, `*.o`, `*.obj`, `*.so`, `*.exe`, `*.Z`, `*.elc`, `*.ln`, `core`, `.svn/`, `.git/`, `.bzr/`.

#### Mail

- `MAIL_ON=0` - включение / отключение функции отправки сообщений на электронную почту.
- `MAIL_FROM='mail@example.org'` - адрес отправителя.
- `MAIL_TO=('mail@example.com' 'mail@example.info')` - массив адресов получателей.
- `MAIL_SMTP_SERVER='smtp[s]://[USER[:PASS]@]SERVER[:PORT]'` - адрес внешнего SMTP-сервера с авторизацией.
- `MAIL_SMTP_AUTH='none'` - тип авторизации на внешний SMTP-сервер. По умолчанию: `none`. Принимаемые значения: `none`, `plain`, `login`, `oauthbearer`.

#### GitLab

- `GITLAB_ON=0` - включение / отключение функции отправки сообщений в GitLab.
- `GITLAB_API='http://example.org/api/v4'` - API URL.
- `GITLAB_PROJECT='0'` - ID проекта.
- `GITLAB_TOKEN='TOKEN'` - токен пользователя.

### Приложение

Приложение забирает параметры из файла настроек и обрабатывает значения.

### Задание

Задание запускает скрипт каждый день в `22:15` (после рабочего дня).

## Восстановление

Набор команд, описывающий алгоритм восстановления резервной копии базы данных.

### GPG

- Расшифровать архив базы данных `DB_NAME.xz.gpg` при помощи секретной фразы `SECRET`:

```bash
f='DB_NAME.xz.gpg'; p='SECRET'; gpg --batch --passphrase "${p}" --output "${f%.*}" --decrypt "${f}"
```

### OpenSSL

{{< alert "important" >}}
При использовании OpenSSL параметры дешифрования должны соответствовать параметрам шифрования. Без знания параметров шифрования, дешифровать данные не получится.
{{< /alert >}}

- Расшифровать архив базы данных `DB_NAME.xz.ssl` при помощи секретной фразы `SECRET`, дайджеста (`-md`) `sha512` и количества итераций (`-iter`) `65536`:

```bash
f='DB_NAME.xz.ssl'; p='SECRET'; openssl enc -aes-256-cfb -in "${f}" -out "${f%.*}" -pass "pass:${p}" -d -md 'sha512' -iter '65536' -salt -pbkdf2
```

### MongoDB

- Восстановить базу данных `DB_NAME` из архива `DB_NAME.xz`:

```bash
mongorestore --username='root' --authenticationDatabase='admin' --archive='DB_NAME.xz' --nsInclude='DB_NAME.*' --oplogReplay --drop
```

### MariaDB

- Удалить базу данных `DB_NAME`:

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

- Импортировать данные в новую базу данных `DB_NAME` из файла `DB_NAME.xz`:

```bash
d='DB_NAME'; f="${d}.sql"; xz -d "${f}.xz" && mariadb --user='root' --password --database="${d}" < "${f}"
```

### PostgreSQL

- Удалить базу данных `DB_NAME`:

```bash
sudo -u 'postgres' dropdb --if-exists 'DB_NAME'
```

- Создать базу данных `DB_NAME` с владельцем `DB_USER`:

```bash
sudo -u 'postgres' createdb --owner='DB_USER' 'DB_NAME'
```

- Восстановить базу данных `DB_NAME` под пользователем `DB_USER` из файла `DB_NAME.xz`:

```bash
u='DB_USER'; d='DB_NAME'; f="${d}.sql"; xz -d "${f}.xz" && psql --host='127.0.0.1' --port='5432' --username="${u}" --password --dbname="${d}" --file="${f}" --no-psqlrc --single-transaction
```
