---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'MS Exchange: Работа с базами данных'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'inDev'
  - 'windows'
tags:
  - 'email'
  - 'exchange'
  - 'database'
  - 'powershell'
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

date: '2025-11-20T15:57:32+03:00'
publishDate: '2025-11-20T15:57:32+03:00'
lastMod: '2025-11-20T15:57:32+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '68f0c64fa386e552eff1b38a9339fd8311b5a28c'
uuid: '68f0c64f-a386-5552-aff1-b38a9339fd83'
slug: '68f0c64f-a386-5552-aff1-b38a9339fd83'

draft: 1
---

Основы работы с MS Exchange. Запустить **Exchange PowerShell** от имени **Администратора**.

<!--more-->

## Анализ

- Посмотреть список баз данных:

```powershell
Get-MailboxDatabase -IncludePreExchange -Status | Sort Name | Format-Table Name, Server, Mounted, AdminDisplayVersion
```

- Посмотреть размер баз данных:

```powershell
Get-MailboxDatabase -IncludePreExchange -Status | Select Name, DatabaseSize, AvailableNewMailboxSpace
```

- Посмотреть размер баз данных в удобном виде:

```powershell
Get-MailboxDatabase -IncludePreExchange -Status | Sort-Object -Descending AvailableNewMailboxSpace | Select Name,@{Name='DatabaseSize (GB)';Expression={$_.DatabaseSize.ToGb()}},@{Name='AvailableNewMailboxSpace (GB)';Expression={$_.AvailableNewMailboxSpace.ToGb()}}
```

## Переименование

- Показать базы данных:

```powershell
Get-MailboxDatabase
```

- Переименовать базу данных `DB01` в `DB02`:

```powershell
Set-MailboxDatabase 'DB01' -Name 'DB02'
```

## Перемещение

- Показать базы данных:

```powershell
Get-MailboxDatabase | Format-List Name, EdbFilePath, LogFolderPath
```

- Переместить базу данных `DB01` на диск `E` и директорию логов на диск `F`:

```powershell
Move-DatabasePath 'DB01' -EdbFilePath 'E:\DB01\DB01.edb' -LogFolderPath 'F:\DB01'
```

## Квоты

- Посмотреть квоты всех баз данных:

```powershell
Get-MailboxDatabase -IncludePreExchange | Format-Table Name, IssueWarningQuota, ProhibitSendQuota, ProhibitSendReceiveQuota
```

- Установить квоты для базы данных `DB01`:

```powershell
Get-MailboxDatabase 'DB01' | Set-MailboxDatabase -IssueWarningQuota '5GB' -ProhibitSendQuota '6GB' -ProhibitSendReceiveQuota '10GB'
```

- Установить квоты для баз данных `DB01` и `DB02`:

```powershell
'DB01','DB02' | Set-MailboxDatabase -IssueWarningQuota '5GB' -ProhibitSendQuota '6GB' -ProhibitSendReceiveQuota '10GB'
```

- Установить квоты для всех баз данных на сервере `SRV-MX`:

```powershell
Get-MailboxDatabase -Server 'SRV-MX' | Set-MailboxDatabase -IssueWarningQuota '5GB' -ProhibitSendQuota '6GB' -ProhibitSendReceiveQuota '10GB'
```
