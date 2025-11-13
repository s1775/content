---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Windows Server 2022 для рабочей станции'
description: ''
icon: 'far fa-file-lines'
cover:
  crop: 'center'
categories:
  - 'windows'
tags:
  - 'server'
  - 'powershell'
authors:
  - 'KaiKimera'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2022-05-09T14:53:26+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '360586503f354ed5c5650aa7d8800c28e9616318'
uuid: '36058650-3f35-5ed5-9565-0aa7d8800c28'
slug: '36058650-3f35-5ed5-9565-0aa7d8800c28'

draft: 0
---

В этой небольшой заметке я расскажу, как перенастроить серверную версию ОС {{< tag "Windows" >}} для работы на обычном стационарном ПК.

<!--more-->

## Настройка служб

На сервере нет необходимости использовать поисковые механизмы и вывод звука, поэтому они отключены. Но на рабочей станции эти параметры необходимы. Для включения звука и поискового механизма, необходимо настроить запуск соответствующих служб.

- Services
  - Windows Audio
    - Startup type
      - Automatic
  - Windows Audio Endpoint
    - Startup type
      - Automatic
  - Windows Search
    - Startup type
      - Automatic (Delayed Start)

## Отключение Shutdown Event Tracker

Сервер должен работать бесперебойно. Любое отключение сервера, по хорошему, должно записываться в специальный журнал. Но так как у нас рабочая станция, записывать каждые перезагрузку или выключение нет необходимости. Включаем службы.

- Local Group Policy
  - Computer Configuration / Administrative Templates / System
    - Display Shutdown Event Tracker
      - Disabled

## Отключение строгой системы безопасности IE

Сервер использует строгие параметры системы безопасности {{< tag "IE" >}}. Но на рабочей станции в этих параметрах нет необходимости и они будут только мешать. Отключаем их.

- Server Manager / Local Server
  - IE Enhanced Security Configuration
    - Off

## Оптимизация производительности для приложений

По умолчанию, на сервере оптимизация включена для фоновых служб. На рабочей станции необходима оптимизация для программ. Включаем оптимизацию для программ.

- System / Advanced System Settings / Advanced / Performance / Advanced
  - Adjust for best performance of
    - Programs

## Отключение DEP

По умолчанию, [Data Execution Prevention (DEP)](https://docs.microsoft.com/en-us/windows/win32/memory/data-execution-prevention) включена абсолютно для всех программ и сервисов. Такая излишняя защита на рабочей станции не нужна. Поэтому, переключаем выполнение {{< tag "DEP" >}} только для программ и сервисов самой ОС Windows.

- System / Advanced System Settings / Advanced / Performance / Data Execution Prevention
  - Turn on DEP for essential Windows programs and services only

## Включение Memory Compression, Operation API и PageCombining

В ОС {{< tag "Windows" >}} для обычных компьютеров включены Memory Compression, Operation API и PageCombining. Поэтому, перенастраиваем серверную версию ОС на такую же конфигурацию. Для этого запускаем {{< tag "PowerShell" >}} от имени Администратора и выполняем команду:

```powershell
Enable-MMAgent -MemoryCompression -OperationAPI -PageCombining
```
