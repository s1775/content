---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: '3X-UI: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'network'
  - 'security'
tags:
  - 'proxy'
  - 'vpn'
  - 'x-ui'
  - '3x-ui'
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

date: '2026-03-27T20:58:32+03:00'
publishDate: '2026-03-27T20:58:32+03:00'
lastMod: '2026-03-27T20:58:32+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '60a8071b878aa10b09bcec1951c4a915284cbdc4'
uuid: '60a8071b-878a-510b-99bc-ec1951c4a915'
slug: '60a8071b-878a-510b-99bc-ec1951c4a915'

draft: 0
---

Инструкция по установке и первичной настройке {{< tag "3x-ui" >}}.

<!--more-->

## Установка

- Скачать и распаковать `3x-ui` версии `v2.8.11`:

```bash
v='v2.8.11'; d='/usr/local'; [[ -d "${d}/x-ui" ]] && rm -rf "${d}/x-ui"; curl -fSLo '/tmp/x-ui-linux-amd64.tar.gz' "https://github.com/MHSanaei/3x-ui/releases/download/${v}/x-ui-linux-amd64.tar.gz" && tar -xzf '/tmp/x-ui-linux-amd64.tar.gz' -C "${d}" && chmod +x "${d}/x-ui/x-ui.sh" && { [[ -L "${d}/bin/x-ui" ]] && unlink "${d}/bin/x-ui"; ln -s "${d}/x-ui/x-ui.sh" "${d}/bin/x-ui"; }
```

- Скачать `x-ui.service` в директорию `/etc/systemd/system` и запустить службу:

```bash
f=('x-ui.service'); d='/etc/systemd/system'; s='https://libsys.ru/ru/2026/03/60a8071b-878a-510b-99bc-ec1951c4a915'; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}" "${s}/${i}"; done && systemctl daemon-reload && { for i in "${f[@]}"; do systemctl enable --now "${i}"; done; }
```

- Скачать задачу `x-ui` в директорию `/etc/cron.d`:

```bash
f=('x-ui'); d='/etc/cron.d'; s='https://libsys.ru/ru/2026/03/60a8071b-878a-510b-99bc-ec1951c4a915'; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}" "${s}/${i}"; done
```

## Настройка

Настроить панель можно по адресу `http://SERVER_IP:2053/`.

### Безопасность

Для большей безопасности, необходимо изменить стандартные пути и порты панели. Идём в настройки и прописываем следующие параметры (можно поменять на свои):

- Panel Settings:
  - General:
    - Listen Port: `64801`.
    - URI Path: `/0728a4S93v964W9y/`.
  - Subscription:
    - Listen Port: `64802`.
    - URI Path: `/38s2ibK4728j71Tr/`.

### Обратный прокси

В качество обратного прокси я буду использовать **Angie** из статьи {{< uuid "b825cd19-f0f5-5a63-acb2-00784311b738" >}}. Также я усилил защиту панели HTTP-аутентификацией самого Angie. Начинаем настройку работы совместно с обратным прокси:

- Создать ключ и сертификат в директории `/etc/ssl/`.
- Создать файл `/etc/angie/users.conf` с пользователями и паролями при помощи этого [сайта](https://hostingcanada.org/htpasswd-generator/) (режим **Bcrypt**).
- Откорректировать настройки панели:
  - Panel Settings:
    - General:
      - Public Key Path: `/etc/ssl/example.org.crt`.
      - Private Key Path: `/etc/ssl/example.org.key`.
    - Subscription:
      - Reverse Proxy URI: `https://example.org:64800/38s2ibK4728j71Tr/`.
      - Public Key Path: `/etc/ssl/example.org.crt`.
      - Private Key Path: `/etc/ssl/example.org.key`.
- Создать файл `/etc/angie/http.d/example.org.conf` со следующим содержанием:

{{< file "angie.conf" "nginx" >}}
