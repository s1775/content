---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Настройка TLS в Windows 7'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'scripts'
  - 'windows'
  - 'terminal'
  - 'security'
tags:
  - 'powershell'
  - 'ssl'
  - 'tls'
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

date: '2024-11-06T11:36:43+03:00'
publishDate: '2024-11-06T11:36:43+03:00'
lastMod: '2024-11-06T11:36:43+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'c915c17d8e2ab0208d55c81075f4fb6577776904'
uuid: 'c915c17d-8e2a-5020-8d55-c81075f4fb65'
slug: 'c915c17d-8e2a-5020-8d55-c81075f4fb65'

draft: 1
---

Summary...

<!--more-->

## Скрипт

Скрипт позволяет включать и отключать поддержку протоколов `SSL 2.0`, `SSL 3.0`, `TLS 1.0`, `TLS 1.1`, `TLS 1.2` и `TLS 1.3 (?)` для Windows 7.

### Установка

- На клиентской ОС Windows 7 должно быть установлено обновление [KB3140245](https://www.catalog.update.microsoft.com/search.aspx?q=KB3140245).
- Запустить скрипт с необходимыми параметрами.

### Приложение

{{< file "app.tls.ps1" "pwsh" >}}

#### Параметры

- `Protocols` - список протоколов. По умолчанию: `TLS 1.2`.
- `Path` - путь к ветке реестра. По умолчанию: `HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols`.
- `Disable` - переключатель отключения протоколов. Если не указан, протоколы создаются с параметром *включено*. Если указан, протоколы создаются с параметром *отключено*.

#### Синтаксис

- Включить поддержку `TLS 1.2`:

```powershell
.\app.tls.ps1
```

- Или включить поддержку `TLS 1.2` такой командой:

```powershell
.\app.tls.ps1 -Protocols 'TLS 1.2'
```

- Отключить поддержку `SSL 2.0`, `SSL 3.0`, `TLS 1.0`, `TLS 1.1`:

```powershell
.\app.tls.ps1 -Protocols 'SSL 2.0', 'SSL 3.0', 'TLS 1.0', 'TLS 1.1' -Disable
```

## Отключение и включение SMBv2

```cmd
REM # Detect:
sc.exe qc lanmanworkstation

REM # Disable:
sc.exe config lanmanworkstation depend= bowser/mrxsmb10/nsi
sc.exe config mrxsmb20 start= disabled

REM # Enable:
sc.exe config lanmanworkstation depend= bowser/mrxsmb10/mrxsmb20/nsi
sc.exe config mrxsmb20 start= auto
```
