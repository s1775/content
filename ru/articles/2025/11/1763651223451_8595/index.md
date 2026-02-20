---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'MS Exchange: Миграция данных'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'inDev'
  - 'windows'
tags:
  - 'mail'
  - 'exchange'
  - 'migration'
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

date: '2025-11-20T18:07:04+03:00'
publishDate: '2025-11-20T18:07:04+03:00'
lastMod: '2025-11-20T18:07:04+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '050bc9b4bc96009f3ea6e386fdea2a153bef89e8'
uuid: '050bc9b4-bc96-509f-8ea6-e386fdea2a15'
slug: '050bc9b4-bc96-509f-8ea6-e386fdea2a15'

draft: 0
---

Рассмотрим команды по миграции данных в MS Exchange. Команды вводятся в терминале **Exchange PowerShell** от имени **Администратора**.

<!--more-->

## Анализ

- Посмотреть статус всех миграций:

```powershell
Get-MoveRequest -ResultSize 'Unlimited' | Get-MoveRequestStatistics
```

- Посмотреть статус выполняемых миграций:

```powershell
Get-MoveRequest -ResultSize 'Unlimited' -MoveStatus 'InProgress' | Get-MoveRequestStatistics
```

- Посмотреть статус выполненных миграций с предупреждениями:

```powershell
Get-MoveRequest -ResultSize 'Unlimited' -MoveStatus 'CompletedWithWarning' | Get-MoveRequestStatistics
```

## Общая миграция

{{< alert "tip" >}}
Наилучшей практикой является не перемещать почтовые ящики мониторинга между базами данных.

- Отключить почтовые ящики мониторинга перед перемещением почтовых ящиков из базы данных `DB01`:

```powershell
Get-Mailbox -Database 'DB01' -Monitoring | Disable-Mailbox -Confirm:$false
```
{{< /alert >}}

- Запустить миграцию всех почтовых ящиков из базы данных `DB01` в базу данных `DB02`:

```powershell
Get-Mailbox -Database 'DB01' -ResultSize 'Unlimited' | New-MoveRequest -TargetDatabase 'DB02' -BatchName 'DB01-DB02'
```

- Запустить миграцию нескольких почтовых ящиков из списка `C:\Users.txt` в базу данных `DB02`:

```powershell
Get-Content 'C:\Users.txt' | ForEach-Object { New-MoveRequest "${_}" -TargetDatabase 'DB02' }
```

- Запустить миграцию почтового ящика `john.doe@example.com` в базу данных `DB02`:

```powershell
New-MoveRequest 'john.doe@example.com' -TargetDatabase 'DB02'
```

{{< alert "tip" >}}
- Запустить миграцию основного и архивного почтовых ящиков пользователя `john.doe@example.com` в разные базы данных:

```powershell
New-MoveRequest 'john.doe@example.com' -TargetDatabase 'DB02_MAIN' -ArchiveTargetDatabase 'DB02_ARCHIVE'
```

- Запустить миграцию только основного почтового ящика пользователя `john.doe@example.com` в базу данных `DB02`:

```powershell
New-MoveRequest 'john.doe@example.com' -TargetDatabase 'DB02' -PrimaryOnly
```

- Запустить миграцию только архивного почтового ящика пользователя `john.doe@example.com` в базу данных `DB02`:

```powershell
New-MoveRequest 'john.doe@example.com' -ArchiveTargetDatabase 'DB02' -ArchiveOnly
```
{{< /alert >}}

## Специализированная миграция

- Запустить миграцию всех арбитражных почтовых ящиков из базы данных `DB01` в базу данных `DB02`:

```powershell
Get-Mailbox -Database 'DB01' -Arbitration | New-MoveRequest -TargetDatabase 'DB02'
```

- Запустить миграцию арбитражных почтовых ящиков с сервера `MX_OLD` на новый сервер в базу данных `DB02`:

```powershell
Get-Mailbox -Arbitration -Server 'MX_OLD' | New-MoveRequest -TargetDatabase 'DB02'
```

- Запустить миграцию всех архивных почтовых ящиков из базы данных `DB01` в базу данных `DB02`:

```powershell
Get-Mailbox -ResultSize 'Unlimited' | Where-Object {$_.ArchiveDatabase -like 'DB01'} | New-MoveRequest -ArchiveTargetDatabase 'DB02'
```

- Запустить миграцию публичных директорий из базы данных `DB01` в базу данных `DB02`:

```powershell
Get-Mailbox -Database 'DB01' -PublicFolder | New-MoveRequest -TargetDatabase 'DB02'
```

- Запустить миграцию журнала аудита из базы данных `DB01` в базу данных `DB02`:

```powershell
Get-Mailbox -Database 'DB01' -AuditLog | New-MoveRequest -TargetDatabase 'DB02'
```

## Удаление миграции

- Удалить завершённые миграции:

```powershell
Get-MoveRequest -MoveStatus 'Completed' -ResultSize 'Unlimited' | Remove-MoveRequest -Confirm:$false
```
