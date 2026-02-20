---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'MS Exchange: Работа с почтовыми ящиками'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'inDev'
  - 'windows'
tags:
  - 'mail'
  - 'exchange'
  - 'user'
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

date: '2025-11-20T18:06:18+03:00'
publishDate: '2025-11-20T18:06:18+03:00'
lastMod: '2025-11-20T18:06:18+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '3a636c1367e3133fd107a0871f39ec7b75193183'
uuid: '3a636c13-67e3-533f-b107-a0871f39ec7b'
slug: '3a636c13-67e3-533f-b107-a0871f39ec7b'

draft: 0
---

Рассмотрим команды по работе с почтовыми ящиками пользователей. Команды вводятся в терминале **Exchange PowerShell** от имени **Администратора**.

<!--more-->

## Анализ

- Посмотреть список почтовых ящиков:

```powershell
Get-Mailbox -ResultSize 'Unlimited' | Sort-Object 'DisplayName' | Format-Table 'DisplayName', 'PrimarySmtpAddress', 'ServerName', 'Database'
```

- Посмотреть статистику почтовых ящиков:

```powershell
Get-Mailbox -ResultSize 'Unlimited' | Get-MailboxStatistics | Sort-Object 'DisplayName' | Format-Table 'DisplayName', 'PrimarySmtpAddress', 'TotalItemSize', 'ItemCount'
```

- Посмотреть статистику почтовых ящиков и отсортировать по размеру:

```powershell
Get-Mailbox -ResultSize 'Unlimited' | Get-MailboxStatistics | Sort-Object 'TotalItemSize' -Descending | Select-Object 'DisplayName', 'TotalItemSize'
```

- Посмотреть информацию о последнем входе в почтовый ящик:

```powershell
Get-Mailbox -ResultSize 'Unlimited' -RecipientTypeDetails 'UserMailbox' | ForEach-Object { Get-MailboxStatistics $_.PrimarySmtpAddress.ToString() } | Sort-Object 'LastLogonTime' -Descending | Select-Object 'DisplayName', 'LastLogonTime', @{n="DaysSinceLastLogOn";e={(New-TimeSpan -Start $_.LastLogonTime -End (Get-Date)).Days}}
```

- Посмотреть список арбитражных почтовых ящиков:

```powershell
Get-Mailbox -Arbitration | Format-Table 'DisplayName', 'ServerName', 'Database'
```

- Посмотреть информацию о почтовом ящике `john.doe@example.com`:

```powershell
Get-Mailbox 'john.doe@example.com' | Format-Table 'DisplayName', 'PrimarySmtpAddress', 'ServerName', 'Database', 'ArchiveDatabase'
```

## Создание

- Создать почтовый ящик пользователя `John Doe`:

```powershell
Get-User 'John Doe' | Enable-Mailbox
```

- Создать почтовый ящик пользователя `John Doe` в базе данных `DB01`

```powershell
Get-User 'John Doe' | Enable-Mailbox -Database 'DB01'
```

- Массовое создание почтовых ящиков из AD `OU=Finance,OU=Users,OU=Company,DC=example,DC=local`:

```powershell
Get-User -OrganizationalUnit 'OU=Finance,OU=Users,OU=Company,DC=exoip,DC=local' | Enable-Mailbox
```
