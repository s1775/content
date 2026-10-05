---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'OpenSSL: Certificate Authority (CA)'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'terminal'
  - 'scripts'
  - 'linux'
tags:
  - 'openssl'
  - 'ssl'
  - 'bash'
  - 'ca'
  - 'cert'
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

date: '2026-10-01T17:18:45+03:00'
publishDate: '2026-10-01T17:18:45+03:00'
lastMod: '2026-10-01T17:18:45+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'bc2ffc508d2651509c98951a81b17bbb09b63097'
uuid: 'bc2ffc50-8d26-5150-bc98-951a81b17bbb'
slug: 'bc2ffc50-8d26-5150-bc98-951a81b17bbb'

draft: 1
---

Summary...

<!--more-->

## Certificate Authority (CA)

- Скачать скрипты разворачивания CA:

```bash
f=('app.ca.sh' 'app.ca.cert.sh' 'app.ca.sign.sh'); d="${HOME}/ca"; s="https://raw.githubusercontent.com/pkgstore/bash-ssl/refs/heads/main"; mkdir "${d}" && for i in ${f[@]}; do curl -fsSLo "${d}/${i}" "${s}/${i}"; done && { cd "${d}" || exit 1; }
```

- Развернуть основной ЦС (Root CA):

```bash
bash "${HOME}/ca/app.ca.sh" 'ca_0'
```

- Развернуть промежуточный ЦС (Intermediate CA):

```bash
bash "${HOME}/ca/app.ca.sh" 'ca_1'
```

### Сертификаты

- Создать сертификат для домена `example.com` под именем `example.com` с `subjectAltName = DNS:example.com, DNS:*.example.com, IP:127.0.0.1`, периодом в `3650` дней и расширением `cert_server`:

```bash
bash "${HOME}/ca/app.ca.cert.sh" 'example.com' 'DNS:example.com, DNS:*.example.com, IP:127.0.0.1' '3650' 'cert_server'
```

#### Расширения

- `cert_code` - расширение сертификата для подписания кода.
- `cert_client` - расширение сертификата для клиента.
- `cert_server` - расширение сертификата для сервера.

### Подписи

- Создать сертификат под именем `example.com` для подписи `example.com.csr` периодом в `3650` дней и расширением `cert_server`:

```bash
bash "${HOME}/ca/app.ca.sign.sh" 'example.com' 'example.com.csr' '3650' 'cert_server'
```

## Self-Signed Certificate

Я написал небольшой скрипт для быстрого создания само-подписанного сертификата. Настройки скрипта необходимо адаптировать под себя.

### Скрипт

[Генератор](https://github.com/pkgstore/bash-ssl/blob/main/app.ssc.sh) корректных SSL-сертификатов. Перед генерацией сертификата, необходимо откорректировать переменные в скрипте под проект.

#### Использование

Скрипт можно удалённо запросить из репозитория или запустить локально на хосте. Скрипт принимает следующие параметры согласно очерёдности:

- `CN` - CN (Common Name).
- `subjectAltName` - subjectAltName (Alternative Name).
- `keyUsage` - использование ключа (key usage extension).
  - `digitalSignature`
  - `nonRepudiation`
  - `keyEncipherment`
  - `dataEncipherment`
  - `keyAgreement`
  - `keyCertSign`
  - `cRLSign`
  - `encipherOnly`
  - `decipherOnly`
- `extendedKeyUsage` - расширенное использование ключа (extended key usage).
  - `serverAuth` - SSL/TLS WWW Server Authentication.
  - `clientAuth` - SSL/TLS WWW Client Authentication.
  - `codeSigning` - Code Signing.
  - `emailProtection` - E-mail Protection (S/MIME).
  - `timeStamping` - Trusted Timestamping.
  - `OCSPSigning` - OCSP Signing.
  - `ipsecIKE` - ipsec Internet Key Exchange.
  - `msCodeInd` - Microsoft Individual Code Signing (authenticode).
  - `msCodeCom` - Microsoft Commercial Code Signing (authenticode).
  - `msCTLSign` - Microsoft Trust List Signing.
  - `msEFS` - Microsoft Encrypted File System.
- `[TRUE|FALSE]` - является ли сертификат сертификатом центра сертификации и можно ли при помощи него заверять другие сертификаты. Параметр принимает значение `TRUE` или `FALSE`. По умолчанию `FALSE`.

#### Удалённый запрос скрипта

В терминале выполнить команду, подставив свои значения:

```bash
curl -sL 'https://raw.githubusercontent.com/pkgstore/bash-ssl/refs/heads/main/app.ssc.sh' | bash -s -- '<CN>' '<subjectAltName>' '<keyUsage>' '<extendedKeyUsage>' '[TRUE|FALSE]'
```

```bash
wget -qO - 'https://raw.githubusercontent.com/pkgstore/bash-ssl/refs/heads/main/app.ssc.sh' | bash -s -- '<CN>' '<subjectAltName>' '<keyUsage>' '<extendedKeyUsage>' '[TRUE|FALSE]'
```

Например:

```bash
curl -sL 'https://raw.githubusercontent.com/pkgstore/bash-ssl/refs/heads/main/app.ssc.sh' | bash -s -- 'example.org' 'DNS:example.org, DNS:*.example.org, IP:127.0.0.1, IP:192.168.1.2' 'digitalSignature, nonRepudiation, keyEncipherment' 'serverAuth' 'FALSE'
```

```bash
wget -qO - 'https://raw.githubusercontent.com/pkgstore/bash-ssl/refs/heads/main/app.ssc.sh' | bash -s -- 'example.org' 'DNS:example.org, DNS:*.example.org, IP:127.0.0.1, IP:192.168.1.2' 'digitalSignature, nonRepudiation, keyEncipherment' 'serverAuth' 'FALSE'
```

Таким образом, сертификат будет сгенерирован с заданными параметрами и заверен собственной подписью.

#### Создание PFX

Чтобы создать PFX-файл, необходимо выполнить следующую команду:

```bash
f='example.org'; openssl pkcs12 -export -nomac -inkey "${f}.key" -in "${f}.crt" -out "${f}.pfx"
```

Где:

- `f` - переменная, содержащая общее название файла.

{{< alert "tip" >}}

Для режима совместимости со старыми системами можно использовать следующую команду:

```bash
f='example.org'; openssl pkcs12 -export -certpbe PBE-SHA1-3DES -keypbe PBE-SHA1-3DES -nomac -inkey "${f}.key" -in "${f}.crt" -out "${f}.pfx"
```
{{< /alert >}}
