---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Многоточие в выводе PowerShell в табличном формате. Как исправить?'
description: ''
icon: 'far fa-circle-question'
tags:
  - 'powershell'
authors:
  - 'KaiKimera'
sources:
  - ''

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2023-10-31T22:52:35+03:00'
publishDate: '2023-10-31T22:52:35+03:00'
lastMod: '2023-10-31T22:52:35+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'faq'
hash: 'edf745173e6eee1cda6b8ee0335670b45684e278'
uuid: 'edf74517-3e6e-5e1c-aa6b-8ee0335670b4'
slug: 'edf74517-3e6e-5e1c-aa6b-8ee0335670b4'

draft: 0
---

Когда PowerShell выводит информацию в табличном формате, некоторые строки не влезают в ширину столбца и происходит обрезание контента. Как сделать так, чтобы PowerShell подстраивал ширину столбца под размер контента?

<!--more-->

```terminal {os="windows"}
Get-Service -DisplayName 'win*'

Status   Name               DisplayName
------   ----               -----------
Running  AudioEndpointBuil… Windows Audio Endpoint Builder
Running  Audiosrv           Windows Audio
Running  EventLog           Windows Event Log
Running  FontCache          Windows Font Cache Service
Stopped  FrameServer        Windows Camera Frame Server
Stopped  FrameServerMonitor Windows Camera Frame Server Monitor
Stopped  icssvc             Windows Mobile Hotspot Service
Running  LicenseManager     Windows License Manager Service
Stopped  MixedRealityOpenX… Windows Mixed Reality OpenXR Service
Running  mpssvc             Windows Defender Firewall
Stopped  msiserver          Windows Installer
Stopped  perceptionsimulat… Windows Perception Simulation Service
Stopped  PushToInstall      Windows PushToInstall Service
Stopped  SDRSVC             Windows Backup
Running  SecurityHealthSer… Windows Security Service
```
