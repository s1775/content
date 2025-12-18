---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'PowerShell: Обработка запросов и рассылка email'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'scripts'
tags:
  - 'mail'
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

date: '2025-12-17T10:34:06+03:00'
publishDate: '2025-12-17T10:34:06+03:00'
lastMod: '2025-12-17T10:34:06+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '91f3c9a4e6a87403042b7004f234bff2eb48c820'
uuid: '91f3c9a4-e6a8-5403-b42b-7004f234bff2'
slug: '91f3c9a4-e6a8-5403-b42b-7004f234bff2'

draft: 0
---

На работе появилась задача обрабатывать текстовые файлы запросов и рассылать их содержимое пользователям. Посмотрим на решение этой задачи...

<!--more-->

## Шаблон

Шаблон текстового файла, который обработает скрипт и отправит {{< tag "email" >}} по указанным в шаблоне параметрам:

```text
To: user1@example.com,user2@example.com
Subject: Request #1
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam elementum sem ex, in mattis leo ornare in.
```

## Скрипт

[Скрипт](https://github.com/pkgstore/pwsh-mail-request) обрабатывает содержимое текстовых файлов определённого шаблона и отправляет содержимое этих файлов на {{< tag "email" >}} пользователям.

Скрипт состоит из следующих компонентов:

- `app.mail.request.ini` - файл с настройками.
- `app.mail.request.ps1` - приложение.
- `task.mail.request.xml` - задача для Windows Task Scheduler.

### Установка

```powershell
$App = "mail-request"; Invoke-Command -ScriptBlock $([scriptblock]::Create((Invoke-WebRequest -Uri "https://pkgstore.github.io/pwsh.install.txt").Content)) -ArgumentList ($args + @($App))
```

### Настройка

Файл настройки `app.mail.request.ini` представляет собой простой файл `.ini`, содержащий в себе приватные параметры.

#### Параметры

- `Server` - IP-адрес сервера.
- `Port` - SMTP-порт сервера.
- `User` - имя пользователя для SMTP-аутентификации.
- `Password` - пароль пользователя для SMTP-аутентификации.

### Приложение

Приложение `app.mail.request.ps1` забирает параметры из файла настроек, а также обрабатывает значения, переданные в терминале.

#### Параметры

- `Request` - путь к файлам запросов.
- `From` - поле "От".
- `Cc` - поле "Копия".
- `Bcc` - поле "Скрытая копия".
- `Priority` - приоритет email. Значения:
  - `Low` - низкий приоритет.
  - `Normal` - стандартный приоритет.
  - `High` - высокий приоритет.
- `LogPath` - путь к файлу журнала. По умолчанию: `${PSScriptRoot}\log.mail.request.txt`.
- `LogSize` - размер файла журнала. Файл журнала будет помещён в ZIP-архив при превышении этого значения. По умолчанию: `50MB`.
- `Attach` - если указано, файл запроса будет прикреплён к email.
- `Save` - если указано, файл запроса не будут удалён после отправки email.
- `HTML` - если указано, email будет иметь разметку HTML.
- `SSL` - если указано, подключение к SMTP-серверу будет осуществляться при помощи протокола SSL.
- `BypassCertValid` - если указано, проверка валидности сертификата при подключении к SMTP-серверу через протокол SSL будет отключена.

### Логирование

Для логирования используются функции `Start-Transcript` и `Stop-Transcript`. Журнал выполнения сохраняется в директории скрипта в файле `log.mail.request.txt`.

## Примеры

- Скрипт обрабатывает запросы `*.txt` в директории `C:\Request\` и рассылает письма от `request@example.com`:

```powershell
.\app.mail.request.ps1 -Domain 'example.org' -From 'request@example.com' -Request 'C:\Request\*.txt'
```

- Скрипт обрабатывает запросы `*.txt` в директории `C:\Request\` и рассылает письма от `request@example.com`, а также отправляет копии писем на `mail@example.net` и `mail@example.biz`:

```powershell
.\app.mail.request.ps1 -Domain 'example.org' -From 'request@example.com' -Request 'C:\Request\*.txt' -Cc 'mail@example.net', 'mail@example.biz'
```

- Скрипт обрабатывает запросы `*.txt` в директории `C:\Request\` и рассылает письма от `request@example.com`, а также отправляет скрытые копии писем на `mail@example.net` и `mail@example.biz`:

```powershell
.\app.mail.request.ps1 -Domain 'example.org' -From 'request@example.com' -Request 'C:\Request\*.txt' -Bcc 'mail@example.net', 'mail@example.biz'
```

- Скрипт обрабатывает запросы `*.txt` в директории `C:\Request\` и рассылает письма от `request@example.com` при этом подключаясь к SMTP-серверу через SSL с обходом проверки валидации сертификата:

```powershell
.\app.mail.request.ps1 -Domain 'example.org' -From 'request@example.com' -Request 'C:\Request\*.txt' -SSL -BypassCertValid
```
