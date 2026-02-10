---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'GitLab: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
  - 'inDev'
tags:
  - 'debian'
  - 'apt'
  - 'gitlab'
  - 'install'
authors:
  - 'KaiKimera'
sources:
  - 'https://gitlab.com/gitlab-org/gitlab/-/tree/master/lib/support/nginx'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2025-02-06T18:28:09+03:00'
publishDate: '2025-02-06T18:28:09+03:00'
lastMod: '2025-02-06T18:28:09+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'f2d035758435b182025dac2a22100055e6b81721'
uuid: 'f2d03575-8435-5182-925d-ac2a22100055'
slug: 'f2d03575-8435-5182-925d-ac2a22100055'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "GitLab" >}}.

<!--more-->

## Репозиторий

- Скачать и установить ключ репозитория:

```bash
curl -fsSL 'https://libsys.ru/ru/2025/02/f2d03575-8435-5182-925d-ac2a22100055/gitlab.asc' | gpg --dearmor -o '/etc/apt/keyrings/gitlab.gpg'
```

- Создать файл репозитория `/etc/apt/sources.list.d/gitlab.sources`:

```bash
. '/etc/os-release' && echo -e "X-Repolib-Name: GitLab\nTypes: deb\nURIs: https://packages.gitlab.com/gitlab/gitlab-ee/${ID}\n#URIs: https://mirror.yandex.ru/mirrors/packages.gitlab.com/gitlab/gitlab-ce\nSuites: ${VERSION_CODENAME}\nComponents: main\nSigned-By: /etc/apt/keyrings/gitlab.gpg\n" | tee '/etc/apt/sources.list.d/gitlab.sources' > '/dev/null'
```

- Для использования всех возможностей поискового движка необходимо установить {{< tag "ElasticSearch" >}} по инструкции {{< uuid "6542fa14-41f4-5309-98c0-a3bac519b93d" >}} или {{< tag "OpenSearch" >}} по инструкции {{< uuid "0c18558e-b4e1-5713-aead-9b767d14e99c" >}}.

## Установка

- Установить пакеты:

```bash
apt update && apt install --yes gitlab-ee
```

## Настройка

- Добавить в конец файла `/etc/gitlab/gitlab.rb` вызов локальной конфигурации:

```bash
f='/etc/gitlab/gitlab.rb'; [[ -f "${f}" && ! -f "${f}.orig" ]] && mv "${f}" "${f}.orig" && cp "${f}.orig" "${f}" && echo -e '\nfrom_file "/etc/gitlab/gitlab.local.rb"\n' | tee -a "${f}" > '/dev/null'
```

- Скачать файл локальной конфигурации в `/etc/gitlab/`:

```bash
f=('gitlab'); d='/etc/gitlab'; s='https://libsys.ru/ru/2025/02/f2d03575-8435-5182-925d-ac2a22100055'; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}.local.rb" "${s}/${i}.rb"; done
```

## Миграция

### Angie

- Установить {{< tag "Angie" >}} по материалу {{< uuid "b825cd19-f0f5-5a63-acb2-00784311b738" >}}.
- Скачать файл сайта `gitlab-ssl.conf` в `/etc/angie/http.d/`:

```bash
f=('gitlab-ssl'); d='/etc/angie/http.d'; s='https://libsys.ru/ru/2025/02/f2d03575-8435-5182-925d-ac2a22100055'; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}.conf" "${s}/${i}.conf"; done
```

### PostgreSQL

- Установить {{< tag "PostgreSQL" >}} по материалу {{< uuid "9c234b3c-704e-599f-9fd9-b3fbb70f7897" >}}.

{{< alert "important" >}}
Необходимо внимательно подбирать версию PostgreSQL под [рекомендуемые требования](https://docs.gitlab.com/install/requirements/#postgresql) GitLab.
{{< /alert >}}

- Остановить все сервисы GitLab, кроме {{< tag "PostgreSQL" >}}:

```bash
gitlab-ctl stop && gitlab-ctl start postgresql && gitlab-ctl status
```

- Экспортировать базу данных `gitlabhq_production` в файл `/tmp/gitlabhq_production.sql`:

```bash
sudo -u 'gitlab-psql' '/opt/gitlab/embedded/bin/pg_dump' --host='/var/opt/gitlab/postgresql' --username='gitlab-psql' --dbname='gitlabhq_production' --clean --create --file='/tmp/gitlabhq_production.sql'
```

- Создать роль `gitlab` и базу данных `gitlabhq_production` на внешнем {{< tag "PostgreSQL" >}}:

```bash
u='gitlab'; d='gitlabhq_production'; sudo -u 'postgres' createuser --pwprompt "${u}" && sudo -u 'postgres' createdb --owner="${u}" "${d}"
```

- Создать расширения для базы данных `gitlabhq_production` на внешнем {{< tag "PostgreSQL" >}}:

```bash
d='gitlabhq_production'; echo 'create extension if not exists pg_trgm; create extension if not exists btree_gist; create extension if not exists plpgsql;' | sudo -u 'postgres' psql "${d}"
```

- Импортировать файл `/tmp/gitlabhq_production.sql` на внешний {{< tag "PostgreSQL" >}}:

```bash
sudo -u 'postgres' psql --dbname='gitlabhq_production' --file='/tmp/gitlabhq_production.sql' --single-transaction
```

- Добавить настройки в файл конфигурации `/etc/gitlab/gitlab.rb`:

```ruby
postgresql['enable'] = false
gitlab_rails['db_adapter'] = 'postgresql'
gitlab_rails['db_encoding'] = 'unicode'
gitlab_rails['db_host'] = '/run/postgresql'
gitlab_rails['db_password'] = '*****'
```

## Лицензия

{{< alert "important" >}}
Лицензия предоставляется как есть и исключительно для изучения и тестирования возможностей GitLab. Обязательно приобретите настоящую лицензию для получения технической поддержки и полноценного использования GitLab.
{{< /alert >}}

### Генератор лицензии

- Скачать и распаковать генератор:

```bash
f=('license.gen'); d="${HOME}"; s='https://libsys.ru/ru/2025/02/f2d03575-8435-5182-925d-ac2a22100055'; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}.tar.xz" "${s}/${i}.tar.xz" && tar -xJf "${d}/${i}.tar.xz"; done
```

- Запустить создание образа:

```bash
docker build "${HOME}/license.gen" -t 'gitlab-license-generator:main'
```

- Создать ключ лицензии в директории `./license`:

```bash
docker run --rm -it -v './license:/license-generator/build' -e LICENSE_NAME='GitLab' -e LICENSE_COMPANY='GitLab' -e LICENSE_EMAIL='license@example.org' -e LICENSE_PLAN='ultimate' -e LICENSE_USER_COUNT='2147483647' -e LICENSE_EXPIRE_YEAR='2500' 'gitlab-license-generator:main'
```

### Готовая лицензия

- Скачать открытый ключ в директорию `/opt/gitlab/embedded/service/gitlab-rails` и заменить им оригинальный файл `license_encryption_key.pub`:

```bash
f=('public'); d='/opt/gitlab/embedded/service/gitlab-rails'; s='https://libsys.ru/ru/2025/02/f2d03575-8435-5182-925d-ac2a22100055'; [[ -f "${d}/.license_encryption_key.pub" && ! -f "${d}/.license_encryption_key.pub.orig" ]] && mv "${d}/.license_encryption_key.pub" "${d}/.license_encryption_key.pub.orig"; for i in "${f[@]}"; do curl -fsSLo "${d}/.license_encryption_key.pub" "${s}/${i}.key"; done
```

- Установить [файл лицензии](license.key) в Admin / Settings / General / Add License.

## ZFS

{{< alert "important" >}}
В этом разделе приведены параметры файловой системы ZFS, на которую будет устанавливаться GitLab. Эти параметры необходимо настроить до начала установки GitLab.
{{< /alert >}}

- Создать тома `elasticsearch` и `gitlab` с алгоритмом компрессии `zstd` в пуле `data`:

```bash
for i in 'elasticsearch' 'gitlab'; do zfs create -o 'compression=zstd' "data/${i}"; done
```

- Установить точку монтирования тома `gitlab` на `/var/opt/gitlab`:

```bash
p='data'; v='gitlab'; zfs set "mountpoint=/var/opt/${v}" "${p}/${v}"
```
