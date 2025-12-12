---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'PowerShell: Отправка email из терминала'
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

date: '2025-12-01T15:43:11+03:00'
publishDate: '2025-12-01T15:43:11+03:00'
lastMod: '2025-12-01T15:43:11+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '1f77872ed835f10b0dc099ac3b4abadf37e3c67b'
uuid: '1f77872e-d835-510b-9dc0-99ac3b4abadf'
slug: '1f77872e-d835-510b-9dc0-99ac3b4abadf'

draft: 0
---

Написал небольшой [скрипт](https://github.com/pkgstore/pwsh-mail), позволяющий отправлять email через терминал {{< tag "PowerShell" >}}.

<!--more-->

## Скрипт

[Скрипт](https://github.com/pkgstore/pwsh-mail) позволяет отправлять {{< tag "email" >}} через терминал {{< tag "PowerShell" >}}.

Скрипт состоит из двух компонентов:

- `app.mail.ini` - файл с настройками.
- `app.mail.ps1` - приложение.
- `lib.mail.subject` - заголовок email.
- `lib.mail.body` - содержание email
- `lib.mail.sign` - подпись в email.

### Установка

- Скопировать файлы `app.mail.ps1` и `app.mail.ini` в директорию `C:\Apps\Email`.
- Изменить параметры скрипта в файле `app.mail.ini`.

### Настройка

Файл настройки представляет собой простой файл `.ini`, содержащий в себе приватные параметры.

#### Параметры

- `Server` - IP-адрес сервера.
- `Port` - SMTP-порт сервера.
- `User` - имя пользователя для SMTP-аутентификации.
- `Password` - пароль пользователя для SMTP-аутентификации.

### Приложение

Приложение забирает параметры из файла настроек, а также обрабатывает значения, переданные в терминале.

#### Параметры

- `Hostname` - название машины, с которой отправляется email.
- `Subject` - заголовок email. Если параметр не задан, информация берётся из файла `lib.mail.subject`.
- `Body` - содержание email. Если параметр не задан, информация берётся из файла `lib.mail.body`.
- `Sign`- содержание подписи email. Если параметр не задан, информация берётся из файла `lib.mail.sign`.
- `From` - поле "От".
- `To` - поле "Кому".
- `Cc` - поле "Копия".
- `Bcc` - поле "Скрытая копия".
- `File` - путь к файлу или файлам для вложения в email.
- `Priority` - приоритет email. Значения:
  - `Low` - низкий приоритет.
  - `Normal` - стандартный приоритет.
  - `High` - высокий приоритет.
- `Wildcard` - включить поддержку регулярных выражений в параметре `File`.
- `FileRename` - переименовать файлы вложений после отправки email.
- `FileRemove` - удалить файлы вложений после отправки email.
- `FileList` - вставить в содержимое email список файлов и их путей, которые были использованы в качестве вложений в email.
- `HTML` - если указано, email будет иметь разметку HTML.
- `SSL` - если указано, подключение к SMTP-серверу будет осуществляться при помощи протокола SSL.
- `NoSign` - отключить добавление подписи в email.
- `NoMeta` - отключить добавление meta-информации в email.
- `BypassCertValid` - если указано, отключить проверку валидности сертификата при подключении к SMTP-серверу через протокол SSL.

### Логирование

Для логирования используется функции `Start-Transcript` и `Stop-Transcript`. Журнал выполнения сохраняется в директории скрипта в файле `log.mail.txt`. Содержимое файла перезаписывается при каждом запуске скрипта.

## Примеры

Набор примеров для работы со скриптом.

### Обычное письмо

- Письмо отправляется от `mail@example.com` для `mail@example.org`:

```terminal {os="windows",lang="pwsh"}
C:\Apps\Email\app.mail.ps1 -Subject 'Example' -Body 'Hello world!' -From 'mail@example.com' -To 'mail@example.org'
```

#### Письмо с вложениями

- Письмо отправляется от `mail@example.com` для `mail@example.org` с вложениями `C:\file.01.txt` и `C:\file.02.txt`:

```terminal {os="windows",lang="pwsh"}
C:\Apps\Email\app.mail.ps1 -Subject 'Example' -Body 'Hello world!' -From 'mail@example.com' -To 'mail@example.org' -Attachment 'C:\file.01.txt', 'C:\file.02.txt'
```

#### HTML-письмо

- Письмо отправляется от `mail@example.com` для `mail@example.org` в формате `HTML`:

```terminal {os="windows",lang="pwsh"}
C:\Apps\Email\app.mail.ps1 -Subject 'Example' -Body 'Hello world!' -From 'mail@example.com' -To 'mail@example.org' -HTML
```

#### Письмо с приоритетом

- Письмо отправляется от `mail@example.com` для `mail@example.org` в высоким приоритетом:

```terminal {os="windows",lang="pwsh"}
C:\Apps\Email\app.mail.ps1 -Subject 'Example' -Body 'Hello world!' -From 'mail@example.com' -To 'mail@example.org' -Priority 'High'
```

#### Письмо с копией

- Письмо отправляется от `mail@example.com` для `mail@example.org` с копией к `mail@example.net` и `mail@example.biz`:

```terminal {os="windows",lang="pwsh"}
C:\Apps\Email\app.mail.ps1 -Subject 'Example' -Body 'Hello world!' -From 'mail@example.com' -To 'mail@example.org' -Cc 'mail@example.net', 'mail@example.biz'
```
