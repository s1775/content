---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'MS Exchange: Установка и миграция'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'inDev'
  - 'windows'
tags:
  - 'email'
  - 'exchange'
  - 'install'
  - 'powershell'
  - 'migration'
authors:
  - 'KaiKimera'
sources:
  - 'https://itproblog.ru/category/exchange/'
  - 'https://www.alitajran.com/exchange-database-best-practices/'
  - 'https://www.alitajran.com/move-exchange-database-to-another-drive/'
  - 'https://learn.microsoft.com/en-us/exchange/plan-and-deploy/deployment-ref/storage-configuration'
  - 'https://clintboessen.blogspot.com/2019/08/preparing-exchange-topology-preparead.html'
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

Установка и миграция MS Exchange в организации.

<!--more-->

## Сервер

### Создание виртуальной машины

- Виртуальная машина для MS Exchange создаётся со следующими дисками:
  - `Disk 1` - диск `C:`, операционная система. Размер `60 GB`.
  - `Disk 2` - диск `D:`, дополнительные данные, чтобы не ковырять системный диск. Размер `5 GB`. Форматирование с размером блока `4 KB`.
  - `Disk 3...9` - набор дисков для баз данных MS Exchange. Размер `5 GB`. Форматирование с размером блока `64 KB`. В дальнейшем размеры дисков можно увеличить до необходимого размера.
- Для CD-ROM в операционной системе указывается буква `X:`.

### Подготовка файловой структуры

- Перед установкой MS Exchange на диске `C:` создаются директории:
  - `C:\Exchange\Database\` - директория для монтирования баз данных.
  - `C:\Exchange\Log\` - директория для хранения логов.
  - `C:\Exchange\Server\` - директория для установки MS Exchange Server.
  - `C:\Exchange\Update\` - директория для обновлений.

{{< alert "tip" >}}
Команда (`cmd.exe` запускается от имени администратора) для быстрого создания структуры директорий для установки MS Exchange:

```batch
for %i in ("Server" "Database" "Log" "Update") do ( if not exist "C:\Exchange\%i" md "C:\Exchange\%i" )
```
{{< /alert >}}

#### Базы данных

- Каждая база данных должна располагаться на отдельном диске.
- Диски для баз данных необходимо форматировать в NTFS или ReFS с размером блока `64 KB`.
- Диски для баз данных подключаются при помощи точек монтирования (НЕ буквы).
- Точки монтирования располагаются в директории `C:\Exchange\Database\`.
- База данных `DB00` является стартовой базой данных, создаваемой при установке MS Exchange.

{{< alert "tip" >}}
Команда PowerShell для проверки размера сектора у дисков:

```powershell
Get-CimInstance -ClassName 'Win32_Volume' | Select-Object Name, FileSystem, Label, BlockSize | Sort-Object Name | Format-Table -AutoSize
```
{{< /alert >}}

{{< alert "tip" >}}
Команда (`cmd.exe` запускается от имени администратора) для быстрого создания структуры директорий для точек монтирования:

```batch
for %i in ("DB00" "DB01" "DB02" "DB03" "DB04") do ( if not exist "C:\Exchange\Database\%i" md "C:\Exchange\Database\%i" )
```
{{< /alert >}}

{{< alert "important" >}}
При использовании точек монтирования на **VMware**, MS Windows может уведомлять ошибкой `Device status: This device cannot start. (Code 10)` в **Device Manager**. Для исправления этой ошибки, необходимо в конфигурации виртуальной машины добавить параметр и значение `devices.hotplug:FALSE`.
{{< /alert >}}

## MS Exchange

- Создать файл `C:\Exchange\exchange.ini` со следующим содержанием:

{{< file "exchange.ini" "ini" >}}

- К диску `X:` (CD-ROM) подключить ISO с дистрибутивом MS Exchange.

### Подготовка AD

- Добавить пользователя, под которым будет производиться установка, в группы **Schema Admins** и **Enterprise Admins**.
- От имени администратора запустить `cmd.exe`.
- Выполнить команду для расширения схемы AD:

```
X:\Setup.exe /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF /PrepareSchema
```

- Выполнить команду для подготовки AD:

```
X:\Setup.exe /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF /PrepareAD
```

{{< alert "tip" >}}
Если в организации устанавливается первый сервер MS Exchange, то в команду добавляется опция `/OrganizationName` с названием организации `Example Corp`:

```
X:\Setup.exe /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF /PrepareAD /OrganizationName:"Example Corp"
```

Без этой опции, организация в MS Exchange будет называться `First Organization`.
{{< /alert >}}

- После успешной подготовки Active Directory, на сервере DC выполнить синхронизацию:

```
repadmin /syncall
```

- Подготовить домен `example.com` для установки MS Exchange:

```
X:\Setup.exe /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF /PrepareDomain:"example.com"
```

### Установка

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

### Настройка

#### Список обслуживаемых доменов

- Показать текущие домены:

```powershell
Get-AcceptedDomain
```

- Создать новый домен example.com:

```powershell
New-AcceptedDomain -DomainName 'example.com' -DomainType Authoritative -Name 'Example COM'
```

#### Коннектор отправки

- Показать текущие коннекторы отправки:

```powershell
Get-SendConnector | Format-Table Identity, AddressSpaces, SourceTransportServers, MaxMessageSize, Enabled
```

- Создать новый коннектор отправки:

```powershell
New-SendConnector -Name 'Internet' -Usage 'Internet' -SourceTransportServers 'SRV-MX' -AddressSpaces ('SMTP:*;1')
```

## Миграция

### Переключение SMTP траффика

### Перемещение почтовых ящиков

#### Арбитражные ящики

- Посмотреть арбитражные ящики:

```powershell
Get-Mailbox -Arbitration
```

- Переместить арбитражные ящики из сервера `MX_OLD` на новый сервер в базу данных `DB_NEW`:

```powershell
Get-Mailbox -Arbitration -Server 'MX_OLD' | New-MoveRequest -TargetDatabase 'DB_NEW'
```

- Посмотреть процесс миграции:

```powershell
Get-MoveRequest -ResultSize 'Unlimited' | Get-MoveRequestStatistics
```

- Удалить завершённые процессы миграции:

```powershell
Get-MoveRequest -MoveStatus 'Completed' -ResultSize 'Unlimited' | Remove-MoveRequest -Confirm:$False
```

#### Пользовательские ящики

- Посмотреть почтовые ящики пользователей:

```powershell
Get-Mailbox | Format-Table Name, ServerName, Database, AdminDisplayVersion
```

- Переместить почтовые ящики пользователей из базы дынных `DB_OLD` старого сервера в базу данных `DB_NEW` нового сервера:

```powershell
Get-Mailbox -Database 'DB_OLD' -ResultSize 'Unlimited' | New-MoveRequest -TargetDatabase 'DB_NEW'
```

- Посмотреть процесс миграции:

```powershell
Get-MoveRequest -ResultSize 'Unlimited' | Get-MoveRequestStatistics
```

- Удалить завершённые процессы миграции:

```powershell
Get-MoveRequest -MoveStatus 'Completed' -ResultSize 'Unlimited' | Remove-MoveRequest -Confirm:$False
```
