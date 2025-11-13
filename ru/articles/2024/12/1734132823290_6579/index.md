---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Zabbix: Aggregated compressed column not found'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
tags:
  - 'zabbix'
  - 'error'
  - 'timescale'
  - 'timescaledb'
authors:
  - 'KaiKimera'
sources:
  - 'https://github.com/timescale/timescaledb/issues/7410'
  - 'https://github.com/timescale/timescaledb/pull/7415#issuecomment-2500314015'
  - 'https://support.zabbix.com/browse/ZBX-25609'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-12-14T02:33:43+03:00'
publishDate: '2024-12-14T02:33:43+03:00'
lastMod: '2024-12-14T02:33:43+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'e1a04b27253c7e50d08a84fcd50f5579557786ab'
uuid: 'e1a04b27-253c-5e50-808a-84fcd50f5579'
slug: 'e1a04b27-253c-5e50-808a-84fcd50f5579'

draft: 0
---

При использовании фильтров времени, Zabbix может выдать ошибку `aggregated compressed column not found`. Эту ошибку можно исправить через конфигурационный файл PostgreSQL.

<!--more-->

## Определение ошибки

Ошибка происходит в TimescaleDB `v2.17.*` и в тот момент, когда фильтр времени выбирает большой период (от 30 дней).

{{< imgur name="AhjF0hV.png" >}}Ошибка `aggregated compressed column not found` в графиках Zabbix.{{< /imgur >}}

В логах присутствуют следующие строки:

```terminal
cat /var/log/zabbix/zabbix_server.log
<...>
2024-11-26 10:50:10.777 UTC [127989] zabbix@zabbix ERROR:  aggregated compressed column not found
2024-11-26 10:50:10.777 UTC [127989] zabbix@zabbix DETAIL:  Assertion 'value_column_description != NULL' failed.
2024-11-26 10:50:10.777 UTC [127989] zabbix@zabbix STATEMENT:  SELECT itemid,COUNT(*) AS count,AVG(value) AS avg,MIN(value) AS min,MAX(value) AS max,round(1607.0*(clock-1731963600)/86399,0) AS i,MAX(clock) AS clock FROM history WHERE itemid='50441' AND clock>='1731963600' AND clock<='1732049999' GROUP BY itemid,round(1607.0*(clock-1731963600)/86399,0)
<...>
```

## Исправление ошибки

В конфигурационный файл `/etc/postgresql/<VERSION>/main/postgresql.conf` необходимо добавить строку:

```ini
timescaledb.enable_vectorized_aggregation = off
```

...и перезапустить PostgreSQL.
