---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'VictoriaLogs: Установка и настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'terminal'
  - 'inDev'
tags:
  - 'debian'
  - 'apt'
  - 'victoria'
  - 'logs'
  - 'victoria-logs'
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

date: '2026-06-18T17:56:24+03:00'
publishDate: '2026-06-18T17:56:24+03:00'
lastMod: '2026-06-18T17:56:24+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'a807265d2e268de04dc3921efb6341b3c534cbf0'
uuid: 'a807265d-2e26-5de0-bdc3-921efb6341b3'
slug: 'a807265d-2e26-5de0-bdc3-921efb6341b3'

draft: 0
---

Инструкция по установке и настройке {{< tag "VictoriaLogs" >}}.

<!--more-->

## Установка

- Создать пользователя `victoria-logs`, а также директории `/opt/victoria-logs` и `/var/lib/victoria-logs`:

```bash
u='victoria-logs'; adduser --system --disabled-login --group --home "/var/lib/${u}" "${u}"; mkdir -p "/opt/${u}" && chown -R "${u}":"${u}" "/opt/${u}"; mkdir "/run/${u}" && chown "${u}":"${u}" "/run/${u}"
```

- Скачать и распаковать `victoria-logs-linux-amd64-*.tar.gz` версии `v1.51.0` в директорию `/opt/victoria-logs`:

```bash
v='v1.51.0'; u='victoria-logs'; d="/opt/${u}"; curl -fSLo "/tmp/${u}-linux-amd64-${v}.tar.gz" "https://github.com/VictoriaMetrics/VictoriaLogs/releases/download/${v}/${u}-linux-amd64-${v}.tar.gz" && tar -xzf "/tmp/${u}-linux-amd64-${v}.tar.gz" -C "${d}" && chown -R "${u}":"${u}" "${d}"
```

### Systemd

- Создать файл `/etc/systemd/system/victoria-logs.service` со следующим содержанием:

{{< file "victoria-logs.service" "ini" >}}

- Запустить службу `victoria-logs.service`:

```
systemctl daemon-reload && systemctl enable --now victoria-logs.service
```

## Syslog-NG

- Включить опцию `--no-caps`:

```bash
sed -i 's|#SYSLOGNG_OPTS=|SYSLOGNG_OPTS=|g' '/etc/default/syslog-ng' && systemctl restart syslog-ng.service
```

- Перенаправить данные от Syslog-NG в базу данных VictoriaLogs при помощи unix-socket'а `/run/victoria-logs/victoria-logs.sock`:

```ruby
destination d_victoria_logs {
  # syslog('127.0.0.1' transport('tcp') port(29514));
  unix-stream('/run/victoria-logs/victoria-logs.sock' flags(syslog-protocol));
};

log {
  destination(d_victoria_logs);
};
```
