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
  - 'email'
  - 'exchange'
  - 'database'
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

draft: 1
---

Summary...

<!--more-->

## Анализ

- Посмотреть список почтовых ящиков:

```powershell
Get-Mailbox | Format-Table Name, ServerName, Database, AdminDisplayVersion
```

- Посмотреть список арбитражных почтовых ящиков:

```powershell
Get-Mailbox -Arbitration | Format-Table Name, ServerName, Database, AdminDisplayVersion
```

- Посмотреть информацию о почтовом ящике `john.doe@example.com`:

```powershell
Get-Mailbox 'john.doe@example.com' | Format-Table Name, PrimarySmtpAddress, Database, ArchiveDatabase
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
