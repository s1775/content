---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'PowerShell: Определение разрядности ОС Windows'
description: ''
icon: 'far fa-file-lines'
cover:
  crop: 'bottom'
categories:
  - 'windows'
  - 'terminal'
tags:
  - 'powershell'
authors:
  - 'KaiKimera'
sources:
  - 'https://stackoverflow.com/a/70893061'
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2023-10-21T20:42:05+03:00'
publishDate: '2023-10-21T20:42:05+03:00'
lastMod: '2023-10-21T20:42:05+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '0028821ec96c601451dd8963c161b170abc35807'
uuid: '0028821e-c96c-5014-a1dd-8963c161b170'
slug: '0028821e-c96c-5014-a1dd-8963c161b170'

draft: 0
---

Нашёл на Stack Overflow хорошую функцию по определению разрядности ОС и процесса {{< tag "PowerShell" >}}. Запишу, обязательно пригодится.

<!--more-->

## Разрядность ОС

Разрядность ОС можно определить следующей функцией:

```powershell
function Get-Architecture {
  # What bitness does Windows use.
  switch ([Environment]::Is64BitOperatingSystem) { # Needs '.NET 4'.
    $true   { 64; break }
    $false  { 32; break }
    default {
      (Get-WmiObject -Class Win32_OperatingSystem).OSArchitecture -replace '\D'
      # Or do any of these:
      # (Get-WmiObject -Class Win32_ComputerSystem).SystemType -replace '\D' -replace '86', '32'
      # (Get-WmiObject -Class Win32_Processor).AddressWidth # This is slow...
    }
  }
}
```

Можно записать эту функцию в файл и запустить файл в терминале, или же внедрить в крупный проект и вызывать по имени `Get-Architecture`.

### Результат

```terminal {os="windows"}
.\arch.ps1
64
```

## Разрядность ОС и PowerShell

Расширенная версия, которая позволяет определить разрядность ОС и процесса PowerShell, под которым выполняется функция.

```powershell
function Get-Architecture {
  # What bitness does Windows use.
  $windowsBitness = switch ([Environment]::Is64BitOperatingSystem) { # Needs '.NET 4'.
    $true   { 64; break }
    $false  { 32; break }
    default {
      (Get-WmiObject -Class Win32_OperatingSystem).OSArchitecture -replace '\D'
      # Or do any of these:
      # (Get-WmiObject -Class Win32_ComputerSystem).SystemType -replace '\D' -replace '86', '32'
      # (Get-WmiObject -Class Win32_Processor).AddressWidth # Slow...
    }
  }

  # What bitness does this PowerShell process use.
  $processBitness = [IntPtr]::Size * 8
  # Or do any of these:
  # $processBitness = $env:PROCESSOR_ARCHITECTURE -replace '\D' -replace '86|ARM', '32'
  # $processBitness = if ([Environment]::Is64BitProcess) { 64 } else { 32 }

  # Return the info as object.
  New-Object -TypeName PSObject -Property @{
    'ProcessArchitecture' = "{0} bit" -f $processBitness
    'WindowsArchitecture' = "{0} bit" -f $windowsBitness
  }
}
```

Можно записать эту функцию в файл и запустить файл в терминале, или же внедрить в крупный проект и вызывать по имени `Get-Architecture`.

### Результат

```terminal {os="windows"}
.\arch.ps1

ProcessArchitecture WindowsArchitecture
------------------- -------------------
64 bit              64 bit
```
