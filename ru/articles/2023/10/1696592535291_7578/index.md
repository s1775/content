---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Установка сертификата НУЦ Минцифры'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'windows'
  - 'security'
tags:
  - 'bash'
  - 'powershell'
  - 'минцифры'
  - 'сертификаты'
authors:
  - 'KaiKimera'
sources:
  - 'https://www.gosuslugi.ru/crt'
  - 'https://developers.sber.ru/help/certificates/how-to'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2023-10-06T14:42:15+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '75075788930846b7f5312008cb35f7d0da04ee73'
uuid: '75075788-9308-56b7-b531-2008cb35f7d0'
slug: '75075788-9308-56b7-b531-2008cb35f7d0'

draft: 0
---

Рассказываю о нескольких способах установки сертификатов от НУЦ Минцифры. Установка производится в ОС MS {{< tag "Windows" >}} и {{< tag "Linux" >}}.

<!--more-->

## MS Windows

### Установка корневого сертификата

- [Скачать](https://gu-st.ru/content/Other/doc/russian_trusted_root_ca.cer) корневой сертификат.
- Открыть скаченный файл `russian_trusted_root_ca.cer` и нажать кнопку {{< key "Установить сертификат..." >}}.
- В **Мастере импорта сертификатов** выбрать *Текущий пользователь*.
  - Выбрать *Поместить все сертификаты в следующее хранилище*.
  - Нажать {{< key "Обзор" >}} и выбрать *Доверенные корневые центры сертификации*.
  - В окне **Завершение мастера импорта сертификатов** нажать {{< key "Готово" >}}.

### Установка выпускающего сертификата

- [Скачать](https://gu-st.ru/content/Other/doc/russian_trusted_sub_ca.cer) выпускающий сертификат.
- Открыть скаченный файл `russian_trusted_sub_ca.cer` и нажать кнопку {{< key "Установить сертификат..." >}}.
- В **Мастере импорта сертификатов** выбрать *Текущий пользователь*.
  - Выбрать *Автоматически выбрать хранилище на основе типа сертификата*.
  - В окне **Завершение мастера импорта сертификатов** нажать {{< key "Готово" >}}.


### PowerShell

При помощи {{< tag "PowerShell" >}} можно установить сертификат одной строчкой, состоящей из нескольких команд:

- `Invoke-WebRequest` - скачивает файл с внешнего веб-ресурса.
- `Import-Certificate` - импортирует сертификат в указанное хранилище.
- `${DIR}` - переменная, определяющая директорию `Downloads` (`Загрузки`) для текущего пользователя.

```powershell
$CERT_ROOT = 'russian_trusted_root_ca.cer'; $CERT_SUB = 'russian_trusted_sub_ca.cer'; $DIR = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path; Invoke-WebRequest "https://gu-st.ru/content/Other/doc/${CERT_ROOT}" -OutFile "${DIR}\${CERT_ROOT}" && Import-Certificate -FilePath "${DIR}\${CERT_ROOT}" -CertStoreLocation 'Cert:\CurrentUser\Root' && Invoke-WebRequest "https://gu-st.ru/content/Other/doc/${CERT_SUB}" -OutFile "${DIR}\${CERT_SUB}" && Import-Certificate -FilePath "${DIR}\${CERT_SUB}" -CertStoreLocation 'Cert:\CurrentUser\CA'
```

## Linux

Для {{< tag "Linux" >}} можно воспользоваться пакетом сертификатов в формате `.PEM` от {{< tag "MacOS" >}}. Положительным моментом подобного пакета является то, что {{< tag "PEM" >}} содержит в себе сразу два сертификата: корневой и выпускающий.

### Установка корневого и выпускающего сертификатов

- [Скачать](https://gu-st.ru/content/Other/doc/russiantrustedca.pem) файл с корневым и выпускающим сертификатами.
- Добавить скаченный файл `russiantrustedca.pem` в хранилище доверенных сертификатов в зависимости от дистрибутива {{< tag "Linux" >}}.
  - DEB-based: `/usr/local/share/ca-certificates/`.
  - RHEL-based: `/etc/pki/ca-trust/source/anchors/`.
  - Arch Linux: `/etc/ca-certificates/trust-source/anchors/`.
- Обновить хранилище сертификатов следующими командами.
  - DEB-based: `update-ca-certificates --fresh`.
  - RHEL-based: `update-ca-trust force-enable` и `update-ca-trust extract`.

### Bash

Установить сертификат можно одной командой. Команды вводится от пользователя `root`. Как выше приводилось, для {{< tag "DEB" >}}-based и {{< tag "RHEL" >}}-based дистрибутивов, пути хранилища сертификатов различаются. Поэтому, я привожу две команды под каждые версии дистрибутивов.

#### DEB-based дистрибутивы

```bash
CERT='russiantrustedca.pem'; curl -o "/usr/local/share/ca-certificates/${CERT}" "https://gu-st.ru/content/Other/doc/${CERT}" && update-ca-certificates --fresh
```

#### RHEL-based дистрибутивы

```bash
CERT='russiantrustedca.pem'; curl -o "/etc/pki/ca-trust/source/anchors/${CERT}" "https://gu-st.ru/content/Other/doc/${CERT}" && update-ca-trust force-enable && update-ca-trust extract
```
