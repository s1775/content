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

### Пользователь и директории

- Создать пользователя `victoria-logs`, а также директории `/opt/victoria-logs` и `/var/lib/victoria-logs`:

```bash
u='victoria-logs'; adduser --system --disabled-login --group --home "/var/lib/${u}" "${u}" && mkdir -p "/opt/${u}" && chown -R "${u}":"${u}" "/opt/${u}"
```

### Юнит SystemD

- Создать файл `/etc/systemd/system/victoria-logs.service` со следующим содержанием:

```ini
[Unit]
Description=VictoriaLogs - High-performance log management and analytics
After=network.target

[Service]
Type=simple
User=victoria-logs
Group=victoria-logs
LimitNOFILE=65536
ExecStart=/opt/victoria-logs/victoria-logs-prod \
  -storageDataPath=/var/lib/victoria-logs \
  -retentionPeriod=30d \
  -syslog.listenAddr.tcp=:29514
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

- Запустить службу `victoria-logs.service`:

```
systemctl daemon-reload && systemctl enable --now victoria-logs.service
```

## Настройка

- Перенаправить логи от Syslog-NG в базу данных VictoriaLogs:

```
destination d_victoria_logs {
  syslog('127.0.0.1' transport('tcp') port(29514));
};

log {
  destination(d_victoria_logs);
};
```
