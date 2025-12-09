---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: "Работа с сертификатами Let's Encrypt"
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'network'
  - 'security'
  - 'terminal'
  - 'inDev'
  - 'scripts'
tags:
  - 'debian'
  - 'acme'
  - 'lego'
  - 'ssl'
authors:
  - 'KaiKimera'
sources:
  - 'https://go-acme.github.io/lego/'
  - 'https://github.com/go-acme/lego/blob/master/docs/data/zz_cli_help.toml'
  - 'https://github.com/acmesh-official/acme.sh/wiki/TLS-ALPN-without-downtime'
  - 'https://docs.iredmail.org/letsencrypt.html'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2025-03-28T23:40:30+03:00'
publishDate: '2025-03-28T23:40:30+03:00'
lastMod: '2025-03-28T23:40:30+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '481a0666eb21855fe58f0c2d695b9a741bbce47f'
uuid: '481a0666-eb21-555f-858f-0c2d695b9a74'
slug: '481a0666-eb21-555f-858f-0c2d695b9a74'

draft: 0
---

Рассматриваем работу с сертификатами Let’s Encrypt при помощи утилиты {{< tag "LeGo" >}}.

<!--more-->

## Установка LeGo

- [Скачать](https://github.com/go-acme/lego/releases/latest) {{< tag "LeGo" >}} и распаковать в директорию `/root/apps/acme/`.
- [Установить](#hook) файл `app.hook.sh` в директорию `/root/apps/acme/`.
- Изучить [документацию](https://go-acme.github.io/lego/) и [справку](https://github.com/go-acme/lego/blob/master/docs/data/zz_cli_help.toml) по командам для составления запросов на получение и обновление сертификатов.
- Выбрать метод получения и обновления сертификатов.

## Метод HTTP-01

Let’s Encrypt выдаёт клиенту токен, клиент записывает этот токен в файл на web-сервере по пути `http://example.org/.well-known/acme-challenge/<TOKEN>`.

Плюсы метода:

- Легко автоматизировать без дополнительных знаний о домене.
- Работает со всеми web-серверами.
- Можно использовать для проверки IP-адресов.

Минусы метода:

- Не работает, если провайдер блокирует порт `80`.
- Не позволяет получать wildcard-сертификаты.

### Получение сертификата

- Зарегистрировать адрес `mail@example.org` и получить сертификат с типом ключа `ec256` для доменов `example.org` и `mail.example.org` в директорию `/root/apps/acme/`:

```bash
"${HOME}/apps/acme/lego" --accept-tos --path="${HOME}/apps/acme" --email='mail@example.org' --domains='example.org' --domains='mail.example.org' --pem --pfx --key-type='ec256' --http --http.port=':8080' run
```

- Зарегистрировать адрес `mail@example.org` и получить сертификат с типом ключа `rsa4096` для доменов `example.org` и `mail.example.org` в директорию `/root/apps/acme/`:

```bash
"${HOME}/apps/acme/lego" --accept-tos --path="${HOME}/apps/acme" --email='mail@example.org' --domains='example.org' --domains='mail.example.org' --pem --pfx --key-type='rsa4096' --http --http.port=':8080' run
```

#### Параметры

- `--accept-tos` - автоматически принять соглашение.
- `--path` - путь к хранилищу сертификатов (`/root/apps/acme/`).
- `--email` - адрес электронной почты для регистрации и восстановления сертификата Let’s Encrypt (`mail@example.org`).
- `--domains` - список доменов для получения сертификата (`example.org` и `mail.example.co`).
- `--http` - получение сертификата методом `HTTP-01`.
- `--http.port` - порт `8080`, на котором работает LeGo. Angie из статьи {{< uuid "b825cd19-f0f5-5a63-acb2-00784311b738" >}} перебрасывает запросы к `.well-known/acme-challenge` на порт `8080`.

### Обновление сертификата

- Обновить сертификат с типом ключа `ec256` для доменов `example.org` и `mail.example.org` в директории `/root/apps/acme/` и запустить файл `hook.sh` при успешном обновлении:

```bash
"${HOME}/apps/acme/lego" --path="${HOME}/apps/acme" --email='mail@example.org' --domains='example.org' --domains='mail.example.org' --pem --pfx --key-type='ec256' --http --http.port=':8080' --renew-hook="${HOME}/apps/acme/app.hook.sh" renew
```

- Обновить сертификат с типом ключа `rsa4096` для доменов `example.org` и `mail.example.org` в директории `/root/apps/acme/` и запустить файл `hook.sh` при успешном обновлении:

```bash
"${HOME}/apps/acme/lego" --path="${HOME}/apps/acme" --email='mail@example.org' --domains='example.org' --domains='mail.example.org' --pem --pfx --key-type='rsa4096' --http --http.port=':8080' --renew-hook="${HOME}/apps/acme/app.hook.sh" renew
```

#### Параметры

- `--renew-hook` - выполнение специального скрипта только после успешного обновления сертификата.

#### Задание

- Создать файл `/etc/cron.d/app_acme_example_com` со следующим содержанием:

{{< file "app_acme_example_com.http" "bash" >}}

## Метод DNS-01

Let’s Encrypt проверяет принадлежность домена клиенту при помощи специальной TXT-записи `_acme-challenge.example.org` для доменного имени.

Плюсы метода:

- Позволяет получать wildcard-сертификаты.
- Работает со множеством серверов.

Минусы метода:

- Необходимо хранить данные API от DNS-провайдера на сервере.
- DNS-провайдер может не предоставлять специальный API для изменения записей домена.
- Нельзя использовать для проверки IP-адресов.

### Получение сертификата

- Зарегистрировать адрес `mail@example.org` и получить сертификат с типом ключа `ec256` для доменов `example.org` и `*.example.org` в директорию `/root/apps/acme/`:

```bash
CF_DNS_API_TOKEN='TOKEN'; "${HOME}/apps/acme/lego" --accept-tos --path="${HOME}/apps/acme" --email='mail@example.org' --domains='example.org' --domains='*.example.org' --pem --pfx --key-type='ec256' --dns='cloudflare' --dns.resolvers '1.1.1.1:53' --dns.resolvers '8.8.8.8:53' --dns.resolvers '77.88.8.8:53' run
```

- Зарегистрировать адрес `mail@example.org` и получить сертификат с типом ключа `rsa4096` для доменов `example.org` и `*.example.org` в директорию `/root/apps/acme/`:

```bash
CF_DNS_API_TOKEN='TOKEN'; "${HOME}/apps/acme/lego" --accept-tos --path="${HOME}/apps/acme" --email='mail@example.org' --domains='example.org' --domains='*.example.org' --pem --pfx --key-type='rsa4096' --dns='cloudflare' --dns.resolvers '1.1.1.1:53' --dns.resolvers '8.8.8.8:53' --dns.resolvers '77.88.8.8:53' run
```

#### Параметры
- `CF_DNS_API_TOKEN` - токен доступа {{< tag "LeGo" >}} к редактированию зоны `example.org`.
- `--accept-tos` - автоматически принять соглашение.
- `--path` - путь к хранилищу сертификатов (`/root/apps/acme`).
- `--email` - адрес электронной почты для регистрации и восстановления сертификата Let’s Encrypt (`mail@example.org`).
- `--domains` - список доменов для получения сертификата (`example.org` и `*.example.org`).
- `--dns` - получение сертификата методом `DNS-01`.
- `--dns.resolvers` - список внешних серверов DNS для доменных имён.

### Обновление сертификата

- Обновить сертификат с типом ключа `ec256` для доменов `example.org` и `*.example.org` в директории `/root/apps/acme/` и запустить файл `hook.sh` при успешном обновлении:

```bash
CF_DNS_API_TOKEN='TOKEN'; "${HOME}/apps/acme/lego" --path="${HOME}/apps/acme" --email='mail@example.org' --domains='example.org' --domains='*.example.org' --pem --pfx --key-type='ec256' --dns='cloudflare' --dns.resolvers '1.1.1.1:53' --dns.resolvers '8.8.8.8:53' --dns.resolvers '77.88.8.8:53' --renew-hook="${HOME}/apps/acme/app.hook.sh" renew
```

- Обновить сертификат с типом ключа `rsa4096` для доменов `example.org` и `*.example.org` в директории `/root/apps/acme/` и запустить файл `hook.sh` при успешном обновлении:

```bash
CF_DNS_API_TOKEN='TOKEN'; "${HOME}/apps/acme/lego" --path="${HOME}/apps/acme" --email='mail@example.org' --domains='example.org' --domains='*.example.org' --pem --pfx --key-type='rsa4096' --dns='cloudflare' --dns.resolvers '1.1.1.1:53' --dns.resolvers '8.8.8.8:53' --dns.resolvers '77.88.8.8:53' --renew-hook="${HOME}/apps/acme/app.hook.sh" renew
```

#### Параметры

- `--renew-hook` - выполнение специального скрипта только после успешного обновления сертификата.

#### Задание

- Создать файл `/etc/cron.d/app_acme_example_com` со следующим содержанием:

{{< file "app_acme_example_com.dns" "bash" >}}

## Метод TLS-ALPN-01

Проверка TLS-ALPN-01 выполняется через TLS handshake на порте `443`. Применяется специальный протокол `ALPN`, чтобы на запросы валидации отвечали только серверы, знающие о таком типе проверки. Присутствует возможность использовать поле `SNI`, совпадающее с именем домена, для которого проводится валидация, для увеличения надёжности проверки.

Плюсы метода:

- Работает при закрытом порте `80`.
- Проверка выполняется исключительно на уровне TLS.
- Можно использовать для проверки IP-адресов.

Минусы метода:

- Возможно, какие-то web-серверы не поддерживают данный метод проверки.
- Не позволяет получать wildcard-сертификаты.

### Настройка Angie

К сожалению, метод проверки требует не занятого порта `443`. Если какой то сервис уже занимает порт `443`, то этот сервис на время проверки необходимо выключить. Чтобы обойти данное ограничение, можно до-настроить Angie таким образом, чтобы он перенаправлял соединения `TLS-ALPN` на сервис проверки сертификатов, а остальные соединения направлял на виртуальные хосты HTTPS.

- На всех виртуальных хостах изменить порт `443` на `8443`.
- Создать балансировщик нагрузки `ALPN`, добавив в файл `/etc/angie/angie.conf` следующую конфигурацию:

```nginx
# -------------------------------------------------------------------------------------------------------------------- #
# ACME: TLS-ALPN
# -------------------------------------------------------------------------------------------------------------------- #

stream {
  map $ssl_preread_alpn_protocols $tls_port {
    ~\bacme-tls/1\b 10443;
    default 8443;
  }

  server {
    listen 443;
    proxy_pass 127.0.0.1:$tls_port;
    ssl_preread on;
  }
}
```

### Получение сертификата

- Зарегистрировать адрес `mail@example.org` и получить сертификат с типом ключа `ec256` для доменов `example.org` и `mail.example.org` в директорию `/root/apps/acme/`:

```bash
"${HOME}/apps/acme/lego" --accept-tos --path="${HOME}/apps/acme" --email='mail@example.org' --domains='example.org' --domains='mail.example.org' --pem --pfx --key-type='ec256' --tls --tls.port=':10443' run
```

- Зарегистрировать адрес `mail@example.org` и получить сертификат с типом ключа `rsa4096` для доменов `example.org` и `mail.example.org` в директорию `/root/apps/acme/`:

```bash
"${HOME}/apps/acme/lego" --accept-tos --path="${HOME}/apps/acme" --email='mail@example.org' --domains='example.org' --domains='mail.example.org' --pem --pfx --key-type='rsa4096' --tls --tls.port=':10443' run
```

#### Параметры

- `--accept-tos` - автоматически принять соглашение.
- `--path` - путь к хранилищу сертификатов (`/root/apps/acme/`).
- `--email` - адрес электронной почты для регистрации и восстановления сертификата Let’s Encrypt (`mail@example.org`).
- `--domains` - список доменов для получения сертификата (`example.org` и `mail.example.co`).
- `--tls` - получение сертификата методом `TLS-ALPN-01`.
- `--tls.port` - номер порта для работы {{< tag "LeGo" >}} (`10443`).

### Обновление сертификата

- Обновить сертификат с типом ключа `ec256` для доменов `example.org` и `mail.example.org` в директории `/root/apps/acme/` и запустить файл `hook.sh` при успешном обновлении:

```bash
"${HOME}/apps/acme/lego" --path="${HOME}/apps/acme" --email='mail@example.org' --domains='example.org' --domains='mail.example.org' --pem --pfx --key-type='ec256' --tls --tls.port=':10443' --renew-hook="${HOME}/apps/acme/app.hook.sh" renew
```

- Обновить сертификат с типом ключа `rsa4096` для доменов `example.org` и `mail.example.org` в директории `/root/apps/acme/` и запустить файл `hook.sh` при успешном обновлении:

```bash
"${HOME}/apps/acme/lego" --path="${HOME}/apps/acme" --email='mail@example.org' --domains='example.org' --domains='mail.example.org' --pem --pfx --key-type='rsa4096' --tls --tls.port=':10443' --renew-hook="${HOME}/apps/acme/app.hook.sh" renew
```

#### Параметры

- `--renew-hook` - выполнение специального скрипта только после успешного обновления сертификата.

#### Задание

- Создать файл `/etc/cron.d/app_acme_example_com` со следующим содержанием:

{{< file "app_acme_example_com.tls" "bash" >}}

## Hook

Я написал [специальный hook](https://github.com/pkgstore/bash-acme), который должен выполняться при успешном получении сертификата. В основном, работа hook'а заключается в том, чтобы перемещать файлы сертификатов необходимые директории и перезапускать сервисы.

### Установка

- Сохранить файлы `app.hook.conf` и `app.hook.sh` в директорию `/root/apps/acme/`.

## Конфигурация приложений

В этом разделе представлены настройки использования сертификата Let’s Encrypt для различных приложений.

### Postfix

- Настроить параметры в `/etc/postfix/main.cf` для домена `example.org`:

```ini
# -------------------------------------------------------------------------------------------------------------------- #
# SSL / TLS
# -------------------------------------------------------------------------------------------------------------------- #

smtpd_tls_cert_file = /etc/ssl/acme/example.org.crt
smtpd_tls_key_file = /etc/ssl/acme/example.org.key
smtpd_tls_CAfile = /etc/ssl/acme/example.org.crt
```

- Настроить параметры в `/etc/postfix/main.cf` для домена `example.org` с использованием сертификатов с несколькими шифрами:

```ini
# -------------------------------------------------------------------------------------------------------------------- #
# SSL / TLS
# -------------------------------------------------------------------------------------------------------------------- #

smtpd_tls_chain_files =
    /etc/ssl/acme/example.org.rsa.key,
    /etc/ssl/acme/example.org.rsa.crt,
    /etc/ssl/acme/example.org.ecc.key,
    /etc/ssl/acme/example.org.ecc.crt
```

### Dovecot

- Настроить параметры в `/etc/dovecot/dovecot.conf` для домена `example.org`:

```ini
# -------------------------------------------------------------------------------------------------------------------- #
# SSL / TLS
# -------------------------------------------------------------------------------------------------------------------- #

ssl_cert = </etc/ssl/acme/example.org.crt
ssl_key = </etc/ssl/acme/example.org.key
ssl_ca = </etc/ssl/acme/example.org.crt
```

### MariaDB

- Настроить параметры в `/etc/mysql/my.cnf` для домена `example.org`:

```ini
[mariadbd]

# -------------------------------------------------------------------------------------------------------------------- #
# SSL / TLS
# -------------------------------------------------------------------------------------------------------------------- #

ssl_cert = '/etc/ssl/acme/example.org.crt'
ssl_key = '/etc/ssl/acme/example.org.key'
ssl_ca = '/etc/ssl/acme/example.org.crt'
```

### OpenLDAP

- Настроить параметры в `/etc/ldap/slapd.conf` для домена `example.org`:

```
# -------------------------------------------------------------------------------------------------------------------- #
# SSL / TLS
# -------------------------------------------------------------------------------------------------------------------- #

TLSCertificateFile /etc/ssl/acme/example.org.crt
TLSCertificateKeyFile /etc/ssl/acme/example.org.key
TLSCACertificateFile /etc/ssl/acme/example.org.crt
```

## Скрипт

[Скрипт](https://github.com/pkgstore/bash-acme) состоит из следующих компонентов:

- `app.acme.conf` - файл с общими настройками.
- `app.acme.sh` - приложение ACME.
- `app.hook.conf` - файл с настройками hook'а.
- `app.hook.sh` - приложение hook'а.
- `job.acme` - задание для CRON.
- `example.org_dns` - пример конфигурации домена `example.org` для метода DNS-01.
- `example.org_http` - пример конфигурации домена `example.org` для метода HTTP-01.

### Установка

- Скачать и установить скрипт:

```bash
curl -sL 'https://raw.githubusercontent.com/pkgstore/bash-install/refs/heads/main/install.sh' | bash -s -- '/root/apps/acme' 'bash-acme' 'main'
```

- [Скачать](https://github.com/go-acme/lego/releases/latest) {{< tag "LeGo" >}} и распаковать в директорию `/root/apps/acme/`.

### Настройка

Параметры скрипта переопределяемые. Переопределение идёт в такой последовательности:

- Общие параметры скрипта (`app_acme.conf`).
  - Параметры домена (`example.org`).

Общие параметры скрипта можно переопределить параметрами домена.

#### Общие параметры

Общие параметры для выполнения скрипта.

- `SERVER` - сервер запроса сертификата ACME.
- `RESOLVERS` - DNS-серверы для разрешения CNAME и определения основного домена. При проверке методом DNS-01 запрос направляется на авторитарный DNS-сервер. Синтаксис: `HOST:PORT`. По умолчанию используются публичные DNS-серверы.
- `DNS` - DNS-провайдер домена для получения сертификата методом DNS-01.
- `PFX_PASS` - пароль для сертификата формата PFX. По умолчанию: `changeit`.
- `PFX_FORMAT` - формат кодирования для шифрования файла `.pfx`. По умолчанию: `RC2`.
  - `RC2` - формат кодирования `RC2`.
  - `DES` - формат кодирования `DES`.
  - `SHA256` - формат кодирования `SHA256`.
- `PORT` - порт или интерфейс, который будет прослушиваться при получении сертификата методом HTTP-01. По умолчанию: `:8080`.
- `DAYS` - количество дней, оставшихся до истечения срока действия сертификата, необходимого для его продления. По умолчанию: `30`.
- `PROXY_HEADER` - выполнять проверку по указанному заголовку HTTP при заказе сертификата методом HTTP-01 за обратным PROXY-сервером. По умолчанию: `Host`.
- `HTTP_TIMEOUT` - значение тайм-аута HTTP в секундах. По умолчанию: `0`.
- `DNS_TIMEOUT` - значение тайм-аута DNS в секундах. Используется только при авторитарных запросов к DNS-серверу. По умолчанию: `10`.
- `CERT_TIMEOUT` - значение тайм-аута сертификата в секундах. Используется только при получении сертификатов. По умолчанию: `30`.
- `REQUEST_LIMIT` - общий лимит запросов ACME. По умолчанию: `18`.
- `USER_AGENT` - user-agent для идентификации запросов от приложения, отправляемых в CA. По умолчанию: `ACME-LEGO/DOMAIN_FILE`.

#### Параметры домена

Параметры для конфигурации домена.

- `DOMAINS` - массив домена и его суб-доменов.
- `EMAIL` - email для регистрации на сервере ACME.
- `TYPE` - тип проверки.
  - `dns` - тип проверки DNS-01.
  - `http` - тип проверки HTTP-01.

#### Параметры hook'а

Параметры для выполнения hook'а при получении или обновлении сертификата.

- `DATA` - директория для хранения сертификатов.
- `SERVICES` - массив сервисов, которым необходимо дать задание на перечитывание конфигурации при обновлении сертификата.

### Синтаксис

Скрипт принимает параметры в следующей очередности:

```bash
"${HOME}/apps/acme/app.acme.sh" 'DOMAIN_FILE' 'KEY' 'ACTION'
```

- `DOMAIN_FILE` - файл с конфигурацией домена. Желательно название файла указывать согласно имени домена.
- `KEY` - тип ключа сертификата.
  - `rsa2048` - тип ключа `RSA2048`
  - `rsa3072` - тип ключа `RSA3072`
  - `rsa4096` - тип ключа `RSA4096`
  - `rsa8192` - тип ключа `RSA8192`
  - `ec256` - тип ключа `EC256`
  - `ec384` - тип ключа `EC384`
- `ACTION` - действие скрипта.
  - `run` - получить новый сертификат для домена.
  - `renew` - запросить обновление сертификата для домена.


#### Примеры

- Запустить **получение** сертификата ACME с типом ключа `rsa2048` для домена `example.org` (файл конфигурации имеет название `example.org`):

```bash
"${HOME}/apps/acme/app.acme.sh" 'example.org' 'rsa2048' 'run'
```

- Запустить **получение** сертификата ACME с типом ключа `ec256` для домена `example.org` (файл конфигурации имеет название `example.org`):

```bash
"${HOME}/apps/acme/app.acme.sh" 'example.org' 'ec256' 'run'
```

- Запустить **обновление** сертификата ACME с типом ключа `ec256` для домена `example.org` (файл конфигурации имеет название `example.org`):

```bash
"${HOME}/apps/acme/app.acme.sh" 'example.org' 'ec256' 'renew'
```

### Задание

Задание запускает скрипт каждый день в `03:35` и `04:35` для типа ключа `RSA2048` и `EC256`, соответственно.
