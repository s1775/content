---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Расширение пробного периода Veritas Backup Exec'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'scripts'
  - 'windows'
tags:
  - 'veritas'
  - 'backup'
  - 'exec'
authors:
  - 'KaiKimera'
sources:
  - 'https://forum.ru-board.com/topic.cgi?forum=35&topic=5286'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2025-03-27T20:58:55+03:00'
publishDate: '2025-03-27T20:58:55+03:00'
lastMod: '2025-03-27T20:58:55+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '0e079d06d87d60dec8e2713a8ddb8fd61b1cf670'
uuid: '0e079d06-d87d-50de-b8e2-713a8ddb8fd6'
slug: '0e079d06-d87d-50de-b8e2-713a8ddb8fd6'

draft: 0
---

В этой заметке я расскажу о способе увеличения пробного периода Veritas Backup Exec при помощи специального скрипта на {{< tag "PowerShell" >}}.

<!--more-->

## Подготовка

- Установить чистый Veritas Backup Exec.
- Зайти в настройки Backup Exec и отключить:
  - Preferences:
    - Show splash screen at startup.
    - Enable auto synchronization of the licenses with the Licensing Portal.
    - Allow Backup Exec to report anonymous usage information.
  - Arctera Update:
    - Check for updates daily.
- Создать и запустить какое-нибудь задание.
- Проверить, что в директориях появились следующие файлы:
  - `C:\Program Files\Veritas\Backup Exec\Data\ETL_COPY.txt`.
  - `C:\ProgramData\Veritas Shared\Licenses\Backup Exec\<BE_VER>\<BE_ID>_QTY999999_BACKUP_EXEC_UNLIMITED_CAPACITY_INITIAL_60_DAY_EVALUATION_LICENSE_<BE_ID>.slf`.
- Запустить скрипт `app.be.trial.ps1`.

## Скрипт

Скрипт изменяет реестр ОС MS {{< tag "Windows" >}} и увеличивает пробный период работы Veritas Backup Exec до 2050 года.

### Приложение

{{< file "app.be.trial.ps1" "powershell" >}}

#### Параметры

- `-Version` - версия Veritas Backup Exec. Формат: `NN.N`. По умолчанию: `23.0`.

#### Примеры

- Увеличить пробный период работы Veritas Backup Exec версии `25.0` до 2050 года:

```terminal {os=windows,mode=root}
D:\Downloads\app.be.trial.ps1 -Version '25.0'
```
