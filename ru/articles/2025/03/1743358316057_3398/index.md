---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Dovecot: Полнотекстовый поиск'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
tags:
  - 'debian'
  - 'email'
  - 'dovecot'
  - 'fts'
  - 'xapian'
  - 'decode2text'
authors:
  - 'KaiKimera'
sources:
  - 'https://forum.iredmail.org/post88511.html#p88511'
  - 'https://github.com/grosjo/fts-xapian'
  - 'https://doc.dovecot.org/main/core/man/doveadm-force-resync.1.html'
  - 'https://doc.dovecot.org/main/core/man/doveadm-fts.1.html'
  - 'https://doc.dovecot.org/main/core/man/doveadm-index.1.html'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2025-03-30T21:11:57+03:00'
publishDate: '2025-03-30T21:11:57+03:00'
lastMod: '2025-03-30T21:11:57+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '7d3b9bd5e43d42a7b662e58a0819c91aa3723680'
uuid: '7d3b9bd5-e43d-52a7-9662-e58a0819c91a'
slug: '7d3b9bd5-e43d-52a7-9662-e58a0819c91a'

draft: 0
---

Чем больше писем у пользователей, тем дольше выполняется поиск по ним. Поэтому, рекомендуется подключать полнотекстовый поиск.

<!--more-->

## Установка

- Установить пакеты:

```bash
apt install --yes -t 'stable-backports' dovecot-fts-xapian && apt install --yes xapian-tools
```

## Настойка

- В файле `/etc/dovecot/dovecot.conf` к директиве `mail_plugins` добавить `fts fts_xapian`.
- В файл `/etc/dovecot/dovecot.conf` добавить следующее содержимое:

{{< file "dovecot.conf" >}}

- Перезапустить сервис `dovecot` и запустить индексирование писем:

```bash
systemctl restart dovecot.service && doveadm index -A -q \*
```

### Декодирование вложений

{{< alert "important" >}}
Данный скрипт переделан под актуальную версию Bash, использовать аккуратно, не проверялся.
{{< /alert >}}

- Создать файл `/usr/lib/dovecot/decode2text.sh` со следующим содержанием:

{{< file "decode2text.sh" "bash" >}}

- Применить к файлу `/usr/lib/dovecot/decode2text.sh` бит исполнения:

```bash
chmod +x '/usr/lib/dovecot/decode2text.sh'
```

- Раскомментировать строки `service decode2text { <...> }` в файле `/etc/dovecot/dovecot.conf`.

## Задание

- Создать файл `/etc/cron.d/dovecot_fts_optimize` со следующим содержанием:

{{< file "dovecot_fts_optimize" "bash" >}}

## Команды

- Восстановить повреждённые почтовые ящики всех пользователей:

```bash
doveadm force-resync -A \*
```

- Восстановить повреждённый почтовый ящик пользователя `bob`:

```bash
doveadm force-resync -u 'bob' \*
```

- Просканировать и сопоставить письма в почтовых ящиках с письмами в индексе полнотекстового поиска для всех пользователей:

```bash
doveadm fts rescan -A
```

- Просканировать и сопоставить письма в почтовом ящике с письмами в индексе полнотекстового поиска для пользователя `bob`:

```bash
doveadm fts rescan -u 'bob'
```

- Добавить неиндексированные письма из почтовых ящиков в файл индекса/кэша для всех пользователей:

```bash
doveadm index -A -q \*
```

- Добавить неиндексированные письма из почтового ящика в файл индекса/кэша для пользователя `bob`:

```bash
doveadm index -u 'bob' -q \*
```
