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

Написал [скрипт](https://github.com/pkgstore/pwsh-mail), позволяющий отправлять email через терминал {{< tag "PowerShell" >}}.

<!--more-->

## Скрипт

[Скрипт](https://github.com/pkgstore/pwsh-mail) позволяет отправлять {{< tag "email" >}} через терминал {{< tag "PowerShell" >}}.

Скрипт состоит из следующих компонентов:

- `app.mail.ini` - файл с настройками.
- `app.mail.ps1` - приложение.
- `lib.mail.subject` - заголовок email.
- `lib.mail.body` - содержание email
- `lib.mail.sign` - подпись в email.

### Установка

```powershell
$App = "mail"; Invoke-Command -ScriptBlock $([scriptblock]::Create((Invoke-WebRequest -Uri "https://pkgstore.github.io/pwsh.install.txt").Content)) -ArgumentList ($args + @($App))
```

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
- `Storage` - директория для хранения отправленных вложений. По умолчанию: `C:\Storage\Email`. При каждом новом email, в хранилище создаётся контейнер (директория) с названием в виде метки времени UNIX и содержанием вложений.
- `Count` - количество контейнеров (директорий) в хранилище. При превышении этого значения, наиболее старый контейнер (директория) в хранилище удаляется. Таким образом обеспечивается ротация контейнеров (директорий) в хранилище. По умолчанию: `5`.
- `DateTime` - включить название контейнеров (директорий) в виде даты `2019-06-27.17-45-52`.
- `Wildcard` - включить поддержку регулярных выражений в параметре `File`.
- `FileMove` - переместить вложения в хранилище после отправки email.
- `FileRemove` - удалить вложения после отправки email.
- `FileList` - вставить в содержимое email список файлов, которые были использованы в качестве вложений в email. При этом сами вложения НЕ прикрепляются к email.
- `HTML` - если указано, email будет иметь разметку HTML.
- `SSL` - если указано, подключение к SMTP-серверу будет осуществляться при помощи протокола SSL.
- `NoSign` - отключить добавление подписи в email.
- `NoMeta` - отключить добавление meta-информации в email.
- `BypassCertValid` - если указано, отключить проверку валидности сертификата при подключении к SMTP-серверу через протокол SSL.

### Логирование

Для логирования используется функции `Start-Transcript` и `Stop-Transcript`. Журнал выполнения сохраняется в директории скрипта в файле `log.mail.txt`. Содержимое файла перезаписывается при каждом запуске скрипта.

## Примеры

- Письмо отправляется от `mail@example.com` для `mail@example.org`:

```terminal {os="windows",lang="pwsh"}
.\app.mail.ps1 -From 'mail@example.com' -To 'mail@example.org'
```

- Письмо отправляется от `mail@example.com` для `mail@example.org` с вложениями `C:\file.01.txt` и `C:\file.02.txt`:

```terminal {os="windows",lang="pwsh"}
.\app.mail.ps1 -From 'mail@example.com' -To 'mail@example.org' -File 'C:\file.01.txt', 'C:\file.02.txt'
```

- Письмо отправляется от `mail@example.com` для `mail@example.org` со всеми вложениями, имеющими расширение `*.txt` (`C:\*.txt`):

```terminal {os="windows",lang="pwsh"}
.\app.mail.ps1 -From 'mail@example.com' -To 'mail@example.org' -File 'C:\*.txt' -Wildcard
```

- Письмо отправляется от `mail@example.com` для `mail@example.org` с вложениями `C:\file.01.txt` и `C:\file.02.txt`. После отправки email, вложения перемещаются в хранилище:

```terminal {os="windows",lang="pwsh"}
.\app.mail.ps1 -From 'mail@example.com' -To 'mail@example.org' -File 'C:\file.01.txt', 'C:\file.02.txt' -FileMove
```

- Письмо отправляется от `mail@example.com` для `mail@example.org` с вложениями `C:\file.01.txt` и `C:\file.02.txt`. После отправки email, вложения перемещаются в хранилище `D:\Email`, ротация контейнеров (директорий) в хранилище в переделах `3`:

```terminal {os="windows",lang="pwsh"}
.\app.mail.ps1 -From 'mail@example.com' -To 'mail@example.org' -File 'C:\file.01.txt', 'C:\file.02.txt' -Storage 'D:\Email' -Count 3 -FileMove
```

- Письмо отправляется от `mail@example.com` для `mail@example.org` с вложениями `C:\file.01.txt` и `C:\file.02.txt`. После отправки email, вложения удаляются:

```terminal {os="windows",lang="pwsh"}
.\app.mail.ps1 -From 'mail@example.com' -To 'mail@example.org' -File 'C:\file.01.txt', 'C:\file.02.txt' -FileRemove
```

- Письмо отправляется от `mail@example.com` для `mail@example.org` в формате `HTML`:

```terminal {os="windows",lang="pwsh"}
.\app.mail.ps1 -From 'mail@example.com' -To 'mail@example.org' -HTML
```

- Письмо отправляется от `mail@example.com` для `mail@example.org` в высоким приоритетом:

```terminal {os="windows",lang="pwsh"}
.\app.mail.ps1 -From 'mail@example.com' -To 'mail@example.org' -Priority 'High'
```

- Письмо отправляется от `mail@example.com` для `mail@example.org` с копией к `mail@example.net` и `mail@example.biz`:

```terminal {os="windows",lang="pwsh"}
.\app.mail.ps1 -From 'mail@example.com' -To 'mail@example.org' -Cc 'mail@example.net', 'mail@example.biz'
```
