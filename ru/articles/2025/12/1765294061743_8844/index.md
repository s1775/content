---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Настройка служб на использование SNI'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'security'
tags:
  - 'debian'
  - 'angie'
  - 'dovecot'
  - 'postfix'
authors:
  - 'KaiKimera'
sources:
  - 'https://garlicspace.com/2025/01/06/nginx-configuration-for-multiple-certificates/'
  - 'https://jakondo.ru/ispolzovanie-server-name-indication-sni-v-postfix-i-dovecot/'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2025-12-09T18:27:43+03:00'
publishDate: '2025-12-09T18:27:43+03:00'
lastMod: '2025-12-09T18:27:43+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '676656fd26a91d4529cd46c4affdc943ef60c68a'
uuid: '676656fd-26a9-5d45-99cd-46c4affdc943'
slug: '676656fd-26a9-5d45-99cd-46c4affdc943'

draft: 0
---

Разбираемся как настроить работу служб с несколькими доменами и их сертификатами.

<!--more-->

## Исходные данные

Имеется три домена:

- `mail.example.com`
- `mail.example.org`
- `mail.example.net`

Для каждого домена необходим отдельный сертификат, который будет использоваться различными сервисами. Сервисы при помощи TLS/SSL-расширения **SNI** будут выбирать сертификат домена в зависимости от запроса клиента.

{{< alert "tip" >}}
**Server Name Indication (SNI)** - расширение компьютерного протокола TLS, которое позволяет клиенту сообщать имя хоста, с которым он желает соединиться во время процесса «рукопожатия». Это позволяет серверу предоставлять несколько сертификатов на одном IP-адресе и TCP-порту, и, следовательно, позволяет работать нескольким безопасным (HTTPS) сайтам (или другим сервисам поверх TLS) на одном IP-адресе без использования одного и того же сертификата на всех сайтах.
{{< /alert >}}

## Angie

- Установить и настроить Angie при помощи статьи {{< uuid "b825cd19-f0f5-5a63-acb2-00784311b738" >}}.
- Создать файл `/etc/angie/conf.d/90-http.ssl.map.conf` со следующим содержанием:

{{< file "angie.http.ssl.map.conf" "nginx" >}}

- В конфигурации сервера изменить параметры у директив `ssl_certificate` и `ssl_certificate_key` на `$cert` и `$key` соответственно:

```nginx {hl_lines=["3-4"]}
server {
  # <...>
  ssl_certificate $cert;
  ssl_certificate_key $key;
  # <...>
}
```

- Перезапустить службу:

```bash
systemctl restart angie.service
```

## Postfix

- Создать файл `/etc/postfix/ssl.map` со следующим содержанием:

{{< file "postfix.ssl.map" >}}

- Построить карту для файла `ssl.map`:

```bash
postmap -F 'hash:/etc/postfix/ssl.map'
```

- В файле `/etc/postfix/main.cf` закомментировать параметры `smtpd_tls_key_file` и `smtpd_tls_cert_file`, добавить параметры `smtpd_tls_chain_files` и `tls_server_sni_maps`:

```ini
#smtpd_tls_key_file = /etc/ssl/default.key
#smtpd_tls_cert_file = /etc/ssl/default.crt
smtpd_tls_chain_files =
    /etc/ssl/default.key,
    /etc/ssl/default.crt
tls_server_sni_maps = hash:/etc/postfix/ssl.map
```

- Перезапустить службу:

```bash
systemctl restart postfix.service
```

## Dovecot

- В файле `/etc/dovecot/dovecot.conf` указать сертификат и ключ по умолчанию в параметрах `ssl_cert` и `ssl_key`:

```ini
ssl_cert = </etc/ssl/default.crt
ssl_key = </etc/ssl/default.key
```

- В файле `/etc/dovecot/dovecot.conf` в самый низ добавить:

```
!include *.map
```

- Создать файл `/etc/dovecot/ssl.map` со следующим содержанием:

{{< file "dovecot.ssl.map" >}}

- Перезапустить службу:

```bash
systemctl restart dovecot.service
```

## Проверка

Для проверки корректного предоставления сертификата домена можно воспользоваться следующей командой (`d` - имя домена):

```bash
d='mail.example.com'; (sleep 1; echo . logout) | openssl s_client -connect "${d}:imap" -starttls imap -servername "${d}" 2>/dev/null | openssl x509 -noout -subject -dates
```

В выводе команде необходимо смотреть на параметр `subject=CN`, он должен содержать корректное имя домена.
