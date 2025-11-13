---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Включение DNS over TLS (DoT) в OPNsense'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'network'
tags:
  - 'dns'
  - 'opnsense'
  - 'dot'
  - 'nat'
authors:
  - 'KaiKimera'
sources:
  - 'https://docs.opnsense.org/manual/unbound.html'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2022-08-14T21:16:34+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'badb30a90471cdab542285422c0ac61167683b43'
uuid: 'badb30a9-0471-5dab-a422-85422c0ac611'
slug: 'badb30a9-0471-5dab-a422-85422c0ac611'

draft: 0
---

Почитав несколько статей на тему {{< tag "DoT" >}}, я решил написать небольшую заметку по настройки {{< tag "OPNsense" >}} на использование этого протокола.

<!--more-->

**DNS поверх TLS** или {{< tag "DoT" >}} это протокол, при помощи которого происходит шифрование запросов и ответов к {{< tag "DNS" >}} через {{< tag "TLS" >}}. Таким образом, повышается конфиденциальность и безопасность пользователей в интернете.

Не все публичные сервера поддерживают {{< tag "DoT" >}}. Список наиболее предпочтительных, по моему мнению, я приведу в таблице в конце статьи. А теперь, по пунктам, я расскажу как правильно настроить {{< tag "OPNsense" >}}, чтобы она задействовала протокол {{< tag "DoT" >}} в своей работе. Для этого нужно выполнить всего несколько шагов...

## Настройка OPNsense

- System / Settings / General
  - Удалить все записи о DNS, если они имеются.
  - Отключить параметр **Allow DNS server list to be overridden by DHCP/PPP on WAN**.
  - Отключить параметр **Do not use the local DNS service as a nameserver for this system**.
- Services / Unbound DNS / General
  - Включить сервис, поставив галочку напротив **Enable**.
  - Выбрать в параметре **Network Interfaces** пункт локальной сети, в данном случае, *LAN*.
  - Включить **DNSSEC**, поставив галочку напротив парамера **Enable DNSSEC Support**.
  - Остальные параметры можно не трогать.
- Services / Unbound DNS / DNS over TLS
  - Добавить публичные сервера DNS из списка ниже.

## Публичные сервера DNS

Ниже я привожу список публичных серверов {{< tag "DNS" >}}, которые поддерживают функцию DNS over TLS ({{< tag "DoT" >}}).

### Cloudflare

{{< table "table-striped table-bordered table-responsive w-50" >}}
| Server IP | Server Port | Verify CN |
| --------- | ----------- | --------- |
| `1.1.1.1` | `853` | `cloudflare-dns.com` |
| `1.0.0.1` | `853` | `cloudflare-dns.com` |
| `2606:4700:4700::1111` | `853` | `cloudflare-dns.com` |
| `2606:4700:4700::1001` | `853` | `cloudflare-dns.com` |
{{< /table >}}

### Google

{{< table "table-striped table-bordered table-responsive w-50" >}}
| Server IP | Server Port | Verify CN |
| --------- | ----------- | --------- |
| `8.8.8.8` | `853` | `dns.google` |
| `8.8.4.4` | `853` | `dns.google` |
| `2001:4860:4860::8888` | `853` | `dns.google` |
| `2001:4860:4860::8844` | `853` | `dns.google` |
{{< /table >}}

### Quad9

{{< table "table-striped table-bordered table-responsive w-50" >}}
| Server IP | Server Port | Verify CN |
| --------- | ----------- | --------- |
| `9.9.9.9` | `853` | `dns.quad9.net` |
| `149.112.112.112` | `853` | `dns.quad9.net` |
| `2620:fe::fe` | `853` | `dns.quad9.net` |
| `2620:fe::9` | `853` | `dns.quad9.net` |
{{< /table >}}

### Cisco Umbrella

{{< table "table-striped table-bordered table-responsive w-50" >}}
| Server IP | Server Port | Verify CN |
| --------- | ----------- | --------- |
| `208.67.222.222` | `853` | `dns.opendns.com` |
| `208.67.220.220` | `853` | `dns.opendns.com` |
| `2620:119:35::35` | `853` | `dns.opendns.com` |
| `2620:119:53::53` | `853` | `dns.opendns.com` |
{{< /table >}}

### CleanBrowsing

{{< table "table-striped table-bordered table-responsive w-50" >}}
| Server IP | Server Port | Verify CN |
| --------- | ----------- | --------- |
| `185.228.168.9` | `853` | `security-filter-dns.cleanbrowsing.org` |
| `185.228.169.9` | `853` | `security-filter-dns.cleanbrowsing.org` |
| `2a0d:2a00:1::2` | `853` | `security-filter-dns.cleanbrowsing.org` |
| `2a0d:2a00:2::2` | `853` | `security-filter-dns.cleanbrowsing.org` |
{{< /table >}}

### AdGuard DNS

{{< table "table-striped table-bordered table-responsive w-50" >}}
| Server IP | Server Port | Verify CN |
| --------- | ----------- | --------- |
| `94.140.14.14` | `853` | `dns.adguard-dns.com` |
| `94.140.15.15` | `853` | `dns.adguard-dns.com` |
| `2a10:50c0::ad1:ff` | `853` | `dns.adguard-dns.com` |
| `2a10:50c0::ad2:ff` | `853` | `dns.adguard-dns.com` |
{{< /table >}}
