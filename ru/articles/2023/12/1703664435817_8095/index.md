---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'MikroTik: Настройка DoH'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'network'
  - 'security'
tags:
  - 'mikrotik'
  - 'doh'
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

date: '2023-12-27T11:07:16+03:00'
publishDate: '2023-12-27T11:07:16+03:00'
lastMod: '2024-03-31T00:29:00+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'b6c7c5cd1b0dbfcdedd2f28f87a5064c68b9c659'
uuid: 'b6c7c5cd-1b0d-5fcd-8dd2-f28f87a5064c'
slug: 'b6c7c5cd-1b0d-5fcd-8dd2-f28f87a5064c'

draft: 0
---

Небольшая заметка по настройке DNS over HTTPS ({{< tag "DoH" >}}) на {{< tag "MikroTik" >}}.

<!--more-->

## Установка набора сертификатов

Для работы DoH необходимо наличие сертификатов в базе MikroTik. Пакет сертификатов я беру с сайта `curl.se`:

```text
/tool fetch url="https://curl.se/ca/cacert.pem" dst-path="ros.cacert.pem"
```

Импортируем сертификаты:

```text
/certificate import file-name="ros.cacert.pem" passphrase="" name="CA"
```

## Настройка DoH

После установки сертификатов, приступаем к настройке DoH.

### Стандартные DNS

```text
/ip dns set allow-remote-requests=yes servers=1.1.1.1,1.0.0.1 use-doh-server="https://cloudflare-dns.com/dns-query" verify-doh-cert=yes
```

В этой команде присутствуют следующие параметры:

- DNS 01: `1.1.1.1`.
- DNS 02: `1.0.0.1`.
- Сервер DoH: `https://cloudflare-dns.com/dns-query`.

### DNS с блокировкой вредоносного ПО

```text
/ip dns set allow-remote-requests=yes servers=1.1.1.2,1.0.0.2 use-doh-server="https://security.cloudflare-dns.com/dns-query" verify-doh-cert=yes
```

В этой команде присутствуют следующие параметры:

- DNS 01: `1.1.1.2`.
- DNS 02: `1.0.0.2`.
- Сервер DoH: `https://security.cloudflare-dns.com/dns-query`.

### DNS с блокировкой вредоносного ПО и контента для взрослых

```text
/ip dns set allow-remote-requests=yes servers=1.1.1.3,1.0.0.3 use-doh-server="https://family.cloudflare-dns.com/dns-query" verify-doh-cert=yes
```

В этой команде присутствуют следующие параметры:

- DNS 01: `1.1.1.3`.
- DNS 02: `1.0.0.3`.
- Сервер DoH: `https://family.cloudflare-dns.com/dns-query`.
