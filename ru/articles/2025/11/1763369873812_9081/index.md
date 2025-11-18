---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'MS Exchange: Установка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'inDev'
  - 'windows'
tags:
  - 'email'
  - 'exchange'
  - 'install'
authors:
  - 'KaiKimera'
sources:
  - 'https://itproblog.ru/category/exchange/'
  - 'https://www.alitajran.com/exchange-database-best-practices/'
  - 'https://www.alitajran.com/move-exchange-database-to-another-drive/'
  - 'https://learn.microsoft.com/en-us/exchange/plan-and-deploy/deployment-ref/storage-configuration'
license: 'CC-BY-SA-4.0'
complexity: '1'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2025-11-17T11:57:55+03:00'
publishDate: '2025-11-17T11:57:55+03:00'
lastMod: '2025-11-17T11:57:55+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'ccafbaad18987c91bc31637d635b5f6ba43b8291'
uuid: 'ccafbaad-1898-5c91-9c31-637d635b5f6b'
slug: 'ccafbaad-1898-5c91-9c31-637d635b5f6b'

draft: 1
---

Summary...

<!--more-->

## Сервер

### Создание виртуальной машины

- Виртуальная машина для MS Exchange создаётся со следующими дисками:
  - `Disk 1` - диск `C:`, операционная система. Размер `60 GB`.
  - `Disk 2` - диск `D:`, дополнительные данные, чтобы не ковырять системный диск. Размер `5 GB`. Форматирование с размером блока `4 KB`.
  - `Disk 3...9` - набор дисков для баз данных MS Exchange. Размер `5 GB`. Форматирование с размером блока `64 KB`. В дальнейшем размеры дисков можно увеличить до необходимого размера.
- Диски создаются в режиме **Thick provisioned, eagerly zeroed**.
- Для CD-ROM в операционной системе указывается буква `X:`.

### Настройка файловой структуры

- Перед установкой MS Exchange на диске `C:` создаются директории:
  - `C:\Exchange\Database\` - директория для монтирования баз данных.
  - `C:\Exchange\Log\` - директория для хранения логов.
  - `C:\Exchange\Server\` - директория для установки MS Exchange Server.
  - `C:\Exchange\Update\` - директория для обновлений.

Прикладываю команду (`cmd.exe` запускается от имени администратора) для быстрого создания структуры директорий MS Exchange:

```batch
for %i in ("Server" "Database" "Log" "Update") do ( if not exist "C:\Exchange\%i" md "C:\Exchange\%i" )
```

Команда для проверки размера сектора у дисков:

```powershell
Get-CimInstance -ClassName 'Win32_Volume' | Select-Object Name, FileSystem, Label, BlockSize | Sort-Object Name | Format-Table -AutoSize
```

#### Базы данных

- Каждая база данных должна располагаться на отдельном диске.
- Диски для баз данных необходимо форматировать в NTFS или ReFS с размером блока `64 KB`.
- Диски для баз данных подключаются при помощи точек монтирования (НЕ буквы).
- Точки монтирования располагаются в директории `C:\Exchange\Database\`.
- База данных `DB00` является стартовой базой данных, создаваемой при установке MS Exchange.

Прикладываю команду (`cmd.exe` запускается от имени администратора) для быстрого создания структуры директорий точек монтирования:

```batch
for %i in ("DB00" "DB01" "DB02" "DB03" "DB04") do ( if not exist "C:\Exchange\Database\%i" md "C:\Exchange\Database\%i" )
```

{{< alert "tip" >}}
При использовании точек монтирования на **VMware**, MS Windows может уведомлять ошибкой `Device status: This device cannot start. (Code 10)` в **Device Manager**. Для исправления этой ошибки, необходимо в конфигурации виртуальной машины добавить параметр и значение `devices.hotplug:FALSE`.
{{< /alert >}}

## MS Exchange

- Создать файл `C:\Exchange\exchange.ini` со следующим содержанием:

{{< file "exchange.ini" "ini" >}}

- К диску `X:` (CD-ROM) подключить ISO с дистрибутивом MS Exchange.

### Подготовка Active Directory

- От имени администратора запустить `cmd.exe` и выполнить команду:

```
X:\Setup.exe /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF /PrepareAD /OrganizationName:"Example Corp"
```

```
repadmin /syncall
```

### Установка MS Exchange

{{< alert "warning" >}}
При установке MS Exchange нельзя менять размер окна терминала. Это приведёт к сбою и вылету установщика:

```
[04-25-2022 21:42:28.0313] [0] [WARNING] Exception has been thrown by the target of an invocation.
[04-25-2022 21:42:28.0320] [0] [WARNING] Exception has been thrown by the target of an invocation.
[04-25-2022 21:42:28.0321] [0] [WARNING] Exception has been thrown by the target of an invocation.
[04-25-2022 21:42:28.0321] [0] [WARNING] The value must be greater than or equal to zero and less than the console's buffer size in that dimension.
Parameter name: left
```
{{< /alert >}}

- От имени администратора запустить `cmd.exe` и выполнить команду:

```
X:\Setup.exe /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF /Mode:Install /Roles:Mailbox /InstallWindowsComponents /TargetDir:"C:\Exchange\Server" /AnswerFile:"C:\Exchange\exchange.ini"
```

{{< file "exchange.ps1" "powershell" >}}
