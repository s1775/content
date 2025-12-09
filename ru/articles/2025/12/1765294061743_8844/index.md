---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: '1765294061743_8844'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'cat_01'
  - 'cat_02'
  - 'cat_03'
tags:
  - 'tag_01'
  - 'tag_02'
  - 'tag_03'
authors:
  - 'JohnDoe'
  - 'JaneDoe'
sources:
  - ''
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

draft: 1
---

Summary...

<!--more-->

## Angie

{{< file "angie.module.http.ssl.map.conf" >}}

## Postfix

```ini
smtpd_tls_chain_files =
    /etc/ssl/acme/rsa2048/denita.info.key,
    /etc/ssl/acme/rsa2048/denita.info.crt
tls_server_sni_maps = hash:/etc/postfix/sni.map
```

{{< file "postfix.ssl.map" >}}

```bash
postmap -F 'hash:/etc/postfix/ssl.map'
```

## Dovecot

{{< file "dovecot.ssl.map" >}}

## Testing

```bash
d='mail.example.com'; (sleep 1; echo . logout) | openssl s_client -connect $d:imap -starttls imap -servername $d 2>/dev/null | openssl x509 -noout -subject -dates
```
