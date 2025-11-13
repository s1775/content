---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Работа с ZFS'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'inDev'
tags:
  - 'linux'
  - 'fs'
  - 'zfs'
authors:
  - 'KaiKimera'
sources:
  - 'https://openzfs.github.io/openzfs-docs/man'
  - 'https://docs.oracle.com/cd/E19253-01/819-5461'
license: 'CC-BY-SA-4.0'
complexity: '1'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-03-08T13:29:06+03:00'
publishDate: '2024-03-08T13:29:06+03:00'
lastMod: '2024-03-08T13:29:06+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '6c7a038ff41e0a453285b99fdacf82d4c66dbbd1'
uuid: '6c7a038f-f41e-5a45-a285-b99fdacf82d4'
slug: '6c7a038f-f41e-5a45-a285-b99fdacf82d4'

draft: 0
---

Я всё чаще стал использовать файловую систему {{< tag "ZFS" >}} и для себя составил шпаргалку по работе с ней. Может быть, кому то ещё пригодится.

<!--more-->

## Исходные данные

В работе с {{< tag "ZFS" >}} я использую ОС {{< tag "Debian" >}} и пути к дискам (`by-path`). Если кто-то захочет использовать идентификаторы (`by-id`) дисков, то просто замените в командах пути на идентификаторы. В командах этой статьи я работаю в пулом под названием `data`.

### Названия переменных

В командах я использую следующие переменные:

- `p` - название пула.
- `v` - название тома.
- `d` - устройство (диск).
- `b` - устройство (блочное устройство).
- `o` - свойство пула.
- `O` - свойство тома.
- `s` - название снимка.
- `r*` - работа с устройствами RAID-массива.
- `rz*` - работа с устройствами RAIDZ-массива.

### Список дисков и их расположение

Вывести список дисков и их расположение (путь) в системе:

```bash
ls -l '/dev/disk/by-path/'
```

### Список дисков и их идентификаторы

Вывести список дисков и их идентификаторы в системе:

```bash
ls -l '/dev/disk/by-id/'
```

## Пулы

Рассмотрим различные варианты работы с пулами {{< tag "ZFS" >}}.

### Создание пула

- Создать обычный пул `data` из одного диска `pci-0000:01:00.0-scsi-0:1:0:0`:

```bash
p='data'; d=('pci-0000:01:00.0-scsi-0:1:0:0'); o=('-o' 'ashift=12'); O=('-O' 'atime=off'); zpool create "${o[@]}" "${O[@]}" "${p}" "${d[@]}"
```

### Расширение пула

Расширение пула происходит путём добавления дополнительного диска или увеличением размера виртуального диска.

#### Добавление диска в пул

- Добавить диск `pci-0000:01:00.0-scsi-0:1:1:0` в пул `data`:

```bash
p='data'; d=('pci-0000:01:00.0-scsi-0:1:1:0'); zpool add "${p}" "${d[@]}"
```

#### Расширение диска в пуле

- Обновить информацию об устройстве `sdb`, на котором располагается пул `data` и расширить его:

```bash
p='data'; b='sdb'; d=('pci-0000:03:00.0-scsi-0:1:0:0'); echo 1 > "/sys/block/${b}/device/rescan" && zpool online -e "${p}" "${d[@]}"
```

{{< alert "tip" >}}
При необходимости можно включить автоматическое расширение пула `data`:

```bash
p='data'; o=('-o' 'autoexpand=on'); zpool set "${o[@]}" "${p}"
```
{{< /alert >}}

### Подключение и отключение дисков

Подключение и отключение дисков осуществляются командами `attach` и `detach`, соответственно.

#### Подключение второго диска (для создания зеркала)

- Подключить новый диск `pci-0000:03:00.0-scsi-0:1:1:0` к существующему диску `pci-0000:03:00.0-scsi-0:1:0:0` в пуле `data` для создания зеркала:

```bash
p='data'; d=('pci-0000:03:00.0-scsi-0:1:0:0' 'pci-0000:03:00.0-scsi-0:1:1:0'); zpool attach "${p}" "${d[@]}"
```

#### Отключение второго диска

- Отключить диск `pci-0000:03:00.0-scsi-0:1:1:0` в пуле `data`:

```bash
p='data'; d=('pci-0000:03:00.0-scsi-0:1:1:0'); zpool detach "${p}" "${d[@]}"
```

### Экспортирование пула

- Экспортировать все пулы:

```bash
zpool export -a
```

- Экспортировать пул `data`:

```bash
p='data'; zpool export "${p}"
```

### Импортирование пула

- Посмотреть список пулов для импорта:

```bash
zpool import
```

- Импортировать пул `data`:

```bash
p='data'; zpool import "${p}"
```

- Импортировать пул `data` с новым именем `data_NEW`:

```bash
p=('data' 'data_NEW'); zpool import "${p[@]}"
```

- Импортировать пул `data`, состоящий из дисков `pci-0000:01:00.0-scsi-0:1:0:0` и `pci-0000:01:00.0-scsi-0:1:1:0`:

```bash
p='data'; d=('-d' 'pci-0000:01:00.0-scsi-0:1:0:0' '-d' 'pci-0000:01:00.0-scsi-0:1:1:0'); zpool import "${d[@]}" "${p}"
```

- ...или можно разрешить {{< tag "ZFS" >}} автоматически поискать диски пула `data`:

```bash
p='data'; d=('-d' '/dev/disk/by-path/'); zpool import "${d[@]}" "${p}"
```

### Переименования пула

- Экспортировать пул `data`:

```bash
p='data'; zpool export "${p}"
```

- Импортировать пул `data` с новым именем `data_NEW`:

```bash
p=('data' 'data_NEW'); zpool import "${p[@]}"
```

### Обновление пула

- Проверить необходимость обновления пула `data`:

```bash
zpool status -v
```

- При появлении надписи `status: Some supported features are not enabled on the pool...` запустить обновление пула `data`:

```bash
p='data'; zpool upgrade "${p}"
```

- ...или обновить сразу все пулы:

```bash
zpool upgrade -a
```

### Удаление пула

- Удалить пул `data`:

```bash
p='data'; zpool destroy "${p}"
```

### Восстановление пула

- Показать список уничтоженных пулов:

```bash
zpool import -D
```

- Восстановить уничтоженный пул `data`:

```bash
p='data'; zpool import -D "${p}"
```

### Список пулов

Вывести список всех пулов в системе:

```bash
zpool list
```

### Статус пула

- Проверить статус пула `data`:

```bash
p='data'; zpool status -v "${p}"
```

### Свойства пула

- Показать все свойства всех пулов:

```bash
zpool get all
```

- Показать все свойства пула `data`:

```bash
p='data'; zpool get all "${p}"
```

- Показать свойства `autoexpand`, `ashift` и `fragmentation` всех пулов:

```bash
o=('autoexpand' 'ashift' 'fragmentation'); zpool get "$( echo "${o[@]}" | tr ' ' ',' )"
```

- Показать свойства `autoexpand`, `ashift` и `fragmentation` пула `data`:

```bash
p='data'; o=('autoexpand' 'ashift' 'fragmentation'); zpool get "$( echo "${o[@]}" | tr ' ' ',' )" "${p}"
```

- Установить свойство `autoexpand` в `on` пула `data`:

```bash
p='data'; o=('-o' 'autoexpand=on'); zpool set "${o[@]}" "${p}"
```

### Работа с RAID

Рассмотрим команды создания пула {{< tag "ZFS" >}} из нескольких дисков.

#### Stripe (RAID0)

- Создать **RAID-0** из дисков `pci-0000:01:00.0-scsi-0:1:0:0` и `pci-0000:01:00.0-scsi-0:1:1:0`:

```bash
p='data'; r0=('pci-0000:01:00.0-scsi-0:1:0:0' 'pci-0000:01:00.0-scsi-0:1:1:0'); o=('-o' 'ashift=12'); O=('-O' 'atime=off'); zpool create "${o[@]}" "${O[@]}" "${p}" "${r0[@]}"
```

#### Mirror (RAID1)

- Создать зеркало (**RAID-1**) из дисков `pci-0000:01:00.0-scsi-0:1:0:0` и `pci-0000:01:00.0-scsi-0:1:1:0`:

```bash
p='data'; r1=('pci-0000:01:00.0-scsi-0:1:0:0' 'pci-0000:01:00.0-scsi-0:1:1:0'); o=('-o' 'ashift=12'); O=('-O' 'atime=off'); zpool create "${o[@]}" "${O[@]}" "${p}" mirror "${r1[@]}"
```

#### RAID10

- Создать **RAID-10** из дисков `pci-0000:01:00.0-scsi-0:1:0:0`, `pci-0000:01:00.0-scsi-0:1:1:0`, `pci-0000:01:00.0-scsi-0:1:2:0` и `pci-0000:01:00.0-scsi-0:1:3:0`:

```bash
p='data'; r10m1=('pci-0000:01:00.0-scsi-0:1:0:0' 'pci-0000:01:00.0-scsi-0:1:1:0'); r10m2=('pci-0000:01:00.0-scsi-0:1:2:0' 'pci-0000:01:00.0-scsi-0:1:3:0'); o=('-o' 'ashift=12'); O=('-O' 'atime=off'); zpool create "${o[@]}" "${O[@]}" "${p}" mirror "${r10m1[@]}" mirror "${r10m2[@]}"
```

#### RAIDZ-1 (RAID5)

- Создать **RAID-5** из дисков `pci-0000:01:00.0-scsi-0:1:0:0`, `pci-0000:01:00.0-scsi-0:1:1:0` и `pci-0000:01:00.0-scsi-0:1:2:0`:

```bash
p='data'; rz1=('pci-0000:01:00.0-scsi-0:1:0:0' 'pci-0000:01:00.0-scsi-0:1:1:0' 'pci-0000:01:00.0-scsi-0:1:2:0'); o=('-o' 'ashift=12'); O=('-O' 'atime=off'); zpool create "${o[@]}" "${O[@]}" "${p}" raidz "${rz1[@]}"
```

#### RAIDZ-2 (RAID6)

- Создать **RAID-6** из дисков `pci-0000:01:00.0-scsi-0:1:0:0`, `pci-0000:01:00.0-scsi-0:1:1:0`, `pci-0000:01:00.0-scsi-0:1:2:0` и `pci-0000:01:00.0-scsi-0:1:3:0`

```bash
p='data'; rz2=('pci-0000:01:00.0-scsi-0:1:0:0' 'pci-0000:01:00.0-scsi-0:1:1:0' 'pci-0000:01:00.0-scsi-0:1:2:0' 'pci-0000:01:00.0-scsi-0:1:3:0'); o=('-o' 'ashift=12'); O=('-O' 'atime=off'); zpool create "${o[@]}" "${O[@]}" "${p}" raidz2 "${rz2[@]}"
```

#### RAIDZ-3

- Создать **RAIDZ-3** из дисков `pci-0000:01:00.0-scsi-0:1:0:0`, `pci-0000:01:00.0-scsi-0:1:1:0`, `pci-0000:01:00.0-scsi-0:1:2:0`, `pci-0000:01:00.0-scsi-0:1:3:0` и `pci-0000:01:00.0-scsi-0:1:4:0`:

```bash
p='data'; rz3=('pci-0000:01:00.0-scsi-0:1:0:0' 'pci-0000:01:00.0-scsi-0:1:1:0' 'pci-0000:01:00.0-scsi-0:1:2:0' 'pci-0000:01:00.0-scsi-0:1:3:0' 'pci-0000:01:00.0-scsi-0:1:4:0'); o=('-o' 'ashift=12'); O=('-O' 'atime=off'); zpool create "${o[@]}" "${O[@]}" "${p}" raidz3 "${rz3[@]}"
```

### Работа с ARC и ZIL

Добавляем отдельные устройства для работы с **ARC** и **ZIL**.

#### ARC

- Добавить отдельный диск (**L2ARC**) `pci-0000:01:00.0-scsi-0:1:4:0` для работы с **ARC** в пул `data`:

```bash
p='data'; d=('pci-0000:01:00.0-scsi-0:1:4:0'); zpool add "${p}" cache "${d[@]}"
```

#### ZIL

- Добавить отдельный диск (**SLOG**) `pci-0000:01:00.0-scsi-0:1:5:0` для работы с **ZIL**  в пул `data`:

```bash
p='data'; d=('pci-0000:01:00.0-scsi-0:1:5:0'); zpool add "${p}" log "${d[@]}"
```

## Тома

### Создание тома

- Создать том `cloud` в пуле `data`:

```bash
p='data'; v='cloud'; zfs create "${p}/${v}"
```

- Создать том `cloud` с точкой монтирования `/opt/cloud` в пуле `data`:

```bash
p='data'; v='cloud'; o=('-o' "mountpoint=/opt/${v}"); zfs create "${o[@]}" "${p}/${v}"
```

- Создать том `cloud` с алгоритмом компрессии `zstd` в пуле `data`:

```bash
p='data'; v='cloud'; o=('-o' 'compression=zstd'); zfs create "${o[@]}" "${p}/${v}"
```

- Создать том `cloud` с алгоритмом компрессии `zstd` и точкой монтирования `/opt/cloud` в пуле `data`:

```bash
p='data'; v='cloud'; o=('-o' 'compression=zstd' '-o' "mountpoint=/opt/${v}"); zfs create "${o[@]}" "${p}/${v}"
```

### Удаление тома

- Удалить том `cloud` в пуле `data`:

```bash
p='data'; v='cloud'; zfs destroy "${p}/${v}"
```

### Создание зашифрованного тома

- Создать том `secret` и зашифровать его парольной фразой в пуле `data`:

```bash
p='data'; v='secret'; o=('-o' 'encryption=on' '-o' 'keyformat=passphrase'); zfs create "${o[@]}" "${p}/${v}"
```

Где:

- `encryption=on` - включение шифрования.
- `keyformat=passphrase` - тип шифрования "парольная фраза".

{{< alert "tip" >}}
При создании тома `secret` ZFS попросит ввести парольную фразу для шифрования данных.
{{< /alert >}}

### Свойства тома

- Показать все свойства всех томов:

```bash
zfs get all
```

- Показать все свойства тома `cloud` в пуле `data`:

```bash
p='data'; v='cloud'; zfs get all "${p}/${v}"
```

- Показать свойства `compressratio`, `compression`, `mountpoint` и `atime` тома `cloud` в пуле `data`:

```bash
p='data'; v='cloud'; o=('compressratio' 'compression' 'mountpoint' 'atime'); zfs get "$( echo "${o[@]}" | tr ' ' ',' )" "${p}/${v}"
```

- Показать свойства `compressratio`, `compression`, `mountpoint` и `atime` тома `cloud` и во всех его под-томах в пуле `data`:

```bash
p='data'; v='cloud'; o=('compressratio' 'compression' 'mountpoint' 'atime'); zfs get -r "$( echo "${o[@]}" | tr ' ' ',' )" "${p}/${v}"
```

- Установить свойство `compression` в `zstd` тома `cloud` в пуле `data`:

```bash
p='data'; v='cloud'; o=('-o' 'compression=zstd'); zfs set "${o[@]}" "${p}/${v}"
```

- Вернуть свойство `compression` к стандартному наследуемому значению тома `cloud` в пуле `data`:

```bash
p='data'; v='cloud'; o=('-o' 'compression'); zfs inherit "${o[@]}" "${p}/${v}"
```

- Вернуть свойство `compression` к стандартному наследуемому значению тома `cloud` и во всех его под-томах в пуле `data`:

```bash
p='data'; v='cloud'; o=('-o' 'compression'); zfs inherit -r "${o[@]}" "${p}/${v}"
```

## Снимки

### Список снимков

- Показать список всех снимков:

```bash
zfs list -t 'snapshot'
```

- Показать список снимков тома `cloud` в пуле `data`:

```bash
p='data'; v='cloud'; zfs list -r -t 'snapshot' -o 'name,creation' "${p}/${v}"
```

### Создание снимков

- Создать снимок `2024-08-21.19-32-02` тома `cloud` в пуле `data`:

```bash
p='data'; v='cloud'; s="$( date '+%F.%H-%M-%S' )"; zfs snapshot "${p}/${v}@${s}"
```

- Создать снимок `2024-08-21.19-32-02` тома `cloud` и всех его дочерних томов в пуле `data`:

```bash
p='data'; v='cloud'; s="$( date '+%F.%H-%M-%S' )"; zfs snapshot -r "${p}/${v}@${s}"
```

### Переименование снимков

- Переименовать снимок `name_OLD` тома `cloud` в пуле `data`:

```bash
p='data'; v='cloud'; zfs rename "${p}/${v}@name_OLD" 'name_NEW'
```

- Переименовать снимок `name_OLD` тома `cloud` и во всех его дочерних томов в пуле `data`:

```bash
p='data'; v='cloud'; zfs rename -r "${p}/${v}@name_OLD" 'name_NEW'
```

### Откат данных к снимку

- Выполнить откат данных к снимку `2024-08-21.19-32-02` тома `cloud` в пуле `data`:

```bash
p='data'; v='cloud'; s='2024-08-21.19-32-02'; zfs rollback "${p}/${v}@${s}"
```

### Удаление снимков

- Удалить снимок `2024-08-21.19-32-02` тома `cloud` в пуле `data`:

```bash
p='data'; v='cloud'; s='2024-08-21.19-32-02'; zfs destroy "${p}/${v}@${s}"
```

## Оптимизации

Специализированные настройки {{< tag "ZFS" >}} под конкретные задачи.

### PostgreSQL

- Создать основной том `pgsql` с алгоритмом компрессии `zstd`:

```bash
p='data'; v='pgsql'; o=('-o' 'compression=zstd'); zfs create "${o[@]}" "${p}/${v}"
```

- Создать специальный том `pgsql/main` с алгоритмом компрессии `zstd` и размером блока `32K` для баз данных:

```bash
p='data'; v='pgsql/main'; o=('-o' 'recordsize=32K'); zfs create "${o[@]}" "${p}/${v}" && chmod 700 "/${p}/${v}"
```

- Создать специальный том `pgsql/wal` с алгоритмом компрессии `zstd` и размером блока `32K` для WAL:

```bash
p='data'; v='pgsql/wal'; o=('-o' 'recordsize=32K'); zfs create "${o[@]}" "${p}/${v}"
```

- Откорректировать настройки {{< tag "PostgreSQL" >}}:

```ini
data_directory = '/data/pgsql/main'
full_page_writes = off
wal_init_zero = off
wal_recycle = off
```

### MySQL

- Создать основной том `mysql` с алгоритмом компрессии `zstd`:

```bash
p='data'; v='mysql'; o=('-o' 'compression=zstd' '-o' 'primarycache=metadata'); zfs create "${o[@]}" "${p}/${v}"
```

- Создать специальный том `mysql/main` с алгоритмом компрессии `zstd` и размером блока `16K` для баз данных:

```bash
p='data'; v='mysql/main'; o=('-o' 'recordsize=16K' '-o' 'logbias=throughput'); zfs create "${o[@]}" "${p}/${v}"
```

- Создать специальный том `mysql/log` с алгоритмом компрессии `zstd` для логирования:

```bash
p='data'; v='mysql/log'; zfs create "${p}/${v}"
```

- Откорректировать настройки {{< tag "MySQL" >}}:

```ini
datadir = 'data/mysql/main'
innodb_doublewrite = 0
innodb_use_native_aio = 0
innodb_use_atomic_writes = 0
```
