---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Установка ядра XanMod в Debian'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
tags:
  - 'debian'
  - 'xanmod'
  - 'kernel'
authors:
  - 'KaiKimera'
sources:
  - 'https://xanmod.org'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2022-01-14T01:44:15+03:00'
publishDate: '2022-01-14T01:44:15+03:00'
lastMod: '2023-10-17T01:23:00+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '06ef2fab2ae2735691547ca1e486d27df6601183'
uuid: '06ef2fab-2ae2-5356-9154-7ca1e486d27d'
slug: '06ef2fab-2ae2-5356-9154-7ca1e486d27d'

draft: 0
---

Приветствую! В этой небольшой заметке приведу команду, при помощи которой можно добавить репозиторий ядра {{< tag "XanMod" >}} в {{< tag "Debian" >}}.

<!--more-->

## Что такое ядро XanMod?

Ядро {{< tag "XanMod" >}} имеет ряд патчей и оптимизаций. Список изменений по сравнению с ванильным ядром, я взял с [официального сайта](https://xanmod.org):

- Kernel built w/ LLVM's ThinLTO, Software Pipelining, Polyhedral and specific x86_64 optimizations.
- Core and Process Scheduling, Load Balancing, Caching, Virtual Memory Manager and CPUFreq Governor optimized for heavy workloads.
- Block layer runqueue requests for high IOPS throughput.
- ORC Unwinder for kernel stack traces (debuginfo) implementation.
- Google's Multigenerational LRU framework [default].
- Real-time Linux kernel (PREEMPT_RT) build available [6.18-rt].
- Process schedulers class sched_ext (SCX) support.
- Third-party patchset available: [patches](https://gitlab.com/xanmod/linux-patches)
  - AMD's 3D V-Cache optimizer driver [as module: amd_3d_vcache].
  - Cloudflare's TCP collapse processing for high throughput and low latency [info](https://blog.cloudflare.com/optimizing-tcp-for-high-throughput-and-low-latency).
  - Google's BBRv3 TCP congestion control [built-in: tcp_bbr] [default].
  - Netfilter nf_tables RFC3489 full-cone NAT support.
  - Netfilter FLOWOFFLOAD target to speed up processing of packets.
  - NT synchronization primitives emulation driver [as module: ntsync].
  - Valve's Steam Deck EC sensors / MFD core and LEDs driver support
  - [as module: steamdeck, steamdeck-hwmon, leds-steamdeck].
  - PCIe ACS Override for bypassing IOMMU groups support.
  - Graysky's additional GCC and Clang CPU options.
  - Clear Linux patchset [partial].
  - Android Binder IPC driver for Waydroid [as module: binder_linux].
- Generic packages for compatibility with any Debian or Ubuntu based distribution.
- GPLv2 license. Can be built for any distribution or purpose.

Стоит заметить, что ядро {{< tag "XanMod" >}} не единственное, которое интегрирует в себя оптимизации. Есть ещё ядро [**Liquorix**](https://liquorix.net), которое занимается практически тем же самым. Но, посмотрев [обзор и тесты](https://www.phoronix.com/scan.php?page=article&item=ryzen5-xanmod-liquorix) на Phoronix'е, я сделал выбор в пользу {{< tag "XanMod" >}}.

## Установка XanMod

Однострочная команда по добавлению ядра {{< tag "XanMod" >}} в репозиторий {{< tag "Debian" >}}'а приведена ниже. Она дробится на следующие под-команды:

1. Добавление файла `xanmod-kernel.list` в директорию `/etc/apt/sources.list.d`.
2. Скачивание файла подписи `archive.key` и размещение его в директорию `/etc/apt/trusted.gpg.d` с названием `xanmod-kernel.gpg`.
3. Обновление информации из репозитория при помощи команды `apt update`.

```bash
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/xanmod-kernel.gpg] http://deb.xanmod.org releases main' | tee /etc/apt/sources.list.d/xanmod-kernel.list && curl -fsSL 'https://dl.xanmod.org/archive.key' | gpg --dearmor | tee /etc/apt/trusted.gpg.d/xanmod-kernel.gpg > /dev/null && apt update
```

После выполнения вышеприведённой команды, установка ядра {{< tag "XanMod" >}} происходит таким образом:

```bash
apt install linux-xanmod-[ABI]
```

Где:
- `[ABI]` - версия архитектуры. Список версий архитектур можно посмотреть ниже.

### Примеры

Установить ядро {{< tag "XanMod" >}} с версией архитектуры `x64v1`:

```bash
apt install linux-xanmod-x64v1
```

Установить ядро {{< tag "XanMod" >}} с версией архитектуры `x64v2`:

```bash
apt install linux-xanmod-x64v2
```

Установить ядро {{< tag "XanMod" >}} с версией архитектуры `x64v3`:

```bash
apt install linux-xanmod-x64v3
```

Установить ядро {{< tag "XanMod" >}} с версией архитектуры `x64v4`:

```bash
apt install linux-xanmod-x64v4
```

Для установки Mainline-версии ядра команда будет такой:

```bash
apt install linux-xanmod-edge-x64v3
```

## Версии архитектур XanMod

Версия архитектуры зависит от ядра процессора и поддерживаемых им инструкций. Версию архитектуры можно узнать из списка ниже.

### x86-64 (LEGACY)

Суффикс для установки ядра: `x64v1`.

**Поддерживаемые архитектуры:**

- AMD K8-family
- AMD K10-family
- AMD Family 10h (Barcelona)
- Intel Pentium 4 / Xeon (Nocona)
- Intel Core 2 (all variants)
- All x86-64 CPUs

### x86-64-v2

Суффикс для установки ядра: `x64v2`.

**Поддерживаемые архитектуры:**

- AMD Family 14h (Bobcat)
- AMD Family 16h (Jaguar)
- AMD Family 15h (Bulldozer)
- AMD Family 15h (Piledriver)
- AMD Family 15h (Steamroller)
- Intel 1st Gen Core (Nehalem)
- Intel 1.5 Gen Core (Westmere)
- Intel 2nd Gen Core (Sandybridge)
- Intel 3rd Gen Core (Ivybridge)
- Intel low-power Silvermont
- Intel Goldmont (Apollo Lake)
- Intel Goldmont (Denverton)
- Intel Goldmont Plus (Gemini Lake)

### x86-64-v3

Суффикс для установки ядра: `x64v3`.

**Поддерживаемые архитектуры:**

- AMD Family 15h (Excavator)
- AMD Family 17h (Zen)
- AMD Family 17h (Zen+)
- AMD Family 17h (Zen 2)
- AMD Family 19h (Zen 3)
- Intel 4th Gen Core (Haswell)
- Intel 5th Gen Core (Broadwell)
- Intel 6th Gen Core (Skylake)
- Intel 7th Gen Core (Kaby Lake)
- Intel 8/9th Gen Core (Coffee Lake)
- Intel 10th Gen Core (Comet Lake)
- Intel 12th Gen (Alder Lake)
- Intel 13th Gen (Raptor Lake)
- Intel 14th Gen (Raptor Lake Refresh)
- Intel 15th Gen (Lunar / Arrow Lake)

### x86-64-v4 (AVX-512)

Суффикс для установки ядра: `x64v4`.

**Поддерживаемые архитектуры:**

- AMD Family 19h (Zen 4 / Zen 4c)
- AMD Family 1Ah (Zen 5 / Zen 5c)
- Intel 6th Gen Core (Skylake X)
- Intel 8th Gen Core i3 (Cannon Lake)
- Intel Xeon / 10th Gen Core (Ice Lake)
- Intel Xeon (Cascade Lake)
- Intel Xeon (Cooper Lake)
- Intel 3rd Gen 10nm++ (Tiger Lake)
- Intel 4th Gen 10nm++ (Sapphire Rapids)
- Intel 5th Gen 10nm++ (Emerald Rapids)
- Intel 11th Gen (Rocket Lake)
