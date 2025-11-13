---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Работа с сетевыми интерфейсами в PowerShell'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'windows'
  - 'terminal'
  - 'network'
  - 'scripts'
tags:
  - 'powershell'
authors:
  - 'KaiKimera'
sources:
  - 'https://learn.microsoft.com/en-us/powershell/module/netadapter/get-netadapter'
  - 'https://learn.microsoft.com/en-us/powershell/module/netconnection/get-netconnectionprofile'
  - 'https://learn.microsoft.com/en-us/powershell/module/nettcpip/new-netipaddress'
  - 'https://learn.microsoft.com/en-us/powershell/module/nettcpip/set-netipinterface'
  - 'https://learn.microsoft.com/en-us/powershell/module/nettcpip/remove-netipaddress'
  - 'https://learn.microsoft.com/en-us/powershell/module/nettcpip/remove-netroute'
  - 'https://learn.microsoft.com/en-us/powershell/module/dnsclient/set-dnsclientserveraddress'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2023-10-31T20:16:31+03:00'
publishDate: '2023-10-31T20:16:31+03:00'
lastMod: '2023-10-31T20:16:31+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '430b916dfd5cbd445c248b98f41e03558d4e8100'
uuid: '430b916d-fd5c-5d44-8c24-8b98f41e0355'
slug: '430b916d-fd5c-5d44-8c24-8b98f41e0355'

draft: 0
---

Разберём основные команды, которые пригодятся нам при настройке сети в ОС {{< tag "Windows" >}} через {{< tag "PowerShell" >}}.

<!--more-->

## Сетевые адаптеры

Получить список сетевых адаптеров и их интерфейсов:

```powershell
Get-NetAdapter
```

Получить список обычных и скрытых сетевых адаптеров:

```powershell
Get-NetAdapter –IncludeHidden
```

Получить конфигурацию по интерфейсу `5`:

```powershell
Get-NetAdapter -InterfaceIndex 5 | Get-NetIPConfiguration
```

Получить детальную конфигурацию по интерфейсу `5`:

```powershell
Get-NetAdapter -InterfaceIndex 5 | Get-NetIPConfiguration -Detailed
```

Отключить адаптер с интерфейсом `5`:

```powershell
Get-NetAdapter -InterfaceIndex 5 | Disable-NetAdapter
```

## Сетевые профили

Вывести информацию по текущим сетевым профилям:

```powershell
Get-NetConnectionProfile
```

Получить информацию только по профилю сети интерфейса `5`:

```powershell
Get-NetAdapter -InterfaceIndex 5 | Get-NetConnectionProfile
```

Изменить профиль сети интерфейса `5` на публичный (`Public`).

```powershell
Get-NetAdapter -InterfaceIndex 5 | Set-NetConnectionProfile -NetworkCategory 'Public'
```

Изменить профиль сети интерфейса `5` на приватный (`Private`).

```powershell
Get-NetAdapter -InterfaceIndex 5 | Set-NetConnectionProfile -NetworkCategory 'Private'
```

Изменить профиль сети интерфейса `5` на доменный (`DomainAuthenticated`).

```powershell
Get-NetAdapter -InterfaceIndex 5 | Set-NetConnectionProfile -NetworkCategory 'DomainAuthenticated'
```

## Настройка IP-адреса

Отключить DHCP на интерфейсе `5`:

```powershell
Get-NetAdapter -InterfaceIndex 5 | Set-NetIPInterface -Dhcp 'Disabled'
```

Установить новый IP-адрес и шлюз на интерфейсе `5`:

```powershell
Get-NetAdapter -InterfaceIndex 5 | New-NetIPAddress –IPAddress '192.168.0.10' -PrefixLength '24' -DefaultGateway '192.168.0.1'
```

Изменить IP-адрес на интерфейсе `5`:

```powershell
Get-NetAdapter -InterfaceIndex 5 | Set-NetIPAddress -IPAddress '192.168.0.12'
```

Удалить IP-адрес на интерфейсе `5`:

```powershell
Get-NetAdapter -InterfaceIndex 5 | Remove-NetIPAddress -Confirm:$false
```

Удаление шлюза на интерфейсе `5`:

```powershell
Get-NetAdapter -InterfaceIndex 5 | Remove-NetRoute -Confirm:$false
```

## Настройка DNS

Установить IP-адреса серверов {{< tag "DNS" >}} на интерфейсе `5`:

```powershell
Get-NetAdapter -InterfaceIndex 5 | Set-DNSClientServerAddress –ServerAddresses ('192.168.0.2','192.168.1.2')
```

Сбросить IP-адреса серверов DNS на параметры по умолчанию на интерфейсе `5`:

```powershell
Get-NetAdapter -InterfaceIndex 5 | Set-DnsClientServerAddress -ResetServerAddresses
```

Очистить кэш {{< tag "DNS" >}}:

```powershell
Clear-DnsClientCache
```

## Настройка DHCP

Включить {{< tag "DHCP" >}} на интерфейсе `5`:

```powershell
Get-NetAdapter -InterfaceIndex 5 | Set-NetIPInterface -Dhcp 'Enabled'
```

Перезапустить интерфейс с именем `Ethernet` для получения параметров от {{< tag "DHCP" >}}:

```powershell
Get-NetAdapter -InterfaceIndex 5 | Restart-NetAdapter
```

## Автоматизация

Скрипт не имеет вводных параметров. Все параметры настраиваются вручную через редактирование скрипта. Далее, скрипт запускается и применяет указанные параметры.

{{< file "pwsh.set.ip.ps1" "pwsh" >}}
