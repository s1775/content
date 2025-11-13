<#PSScriptInfo
.VERSION      0.1.0
.GUID         b590ec0a-a68d-437f-b662-781ba086d606
.AUTHOR       Jason Fossen / Kai Kimera
.AUTHOREMAIL  mail@kai.kim
.COMPANYNAME  Library Online
.COPYRIGHT    2024 Library Online. All rights reserved.
.TAGS         windows server firewall ip allow block
.LICENSEURI   https://choosealicense.com/licenses/mit/
.PROJECTURI   https://libsys.ru/ru/2024/11/e756e17a-f806-5c8a-995d-92f13b436bbc/
#>

<#
.SYNOPSIS
Allow/Block all IP addresses listed in a text file using the Windows Firewall.

.DESCRIPTION
Script will create inbound and outbound rules in the Windows Firewall to allow/block all the IPv4 and/or IPv6 addresses
listed in an input text file. IP address ranges can be defined with CIDR notation (10.4.0.0/16) or with a dash
(10.4.0.0-10.4.255.255). Comments and blank lines are ignored in the input file. The script deletes and recreates the
rules each time the script is run, so don't edit the rules by hand. Requires admin privileges. Multiple rules will be
created if the input list is large. Requires Windows Vista, Windows 7, Server 2008 or later operating system.
Blocking more than 5000 IP address ranges does delay initial connections, will slow the loading of the Windows Firewall
snap-in, and will lengthen the time to disable/enable a network interface. This script is just a wrapper for the
netsh.exe tool. You can block individual IP addresses too, you do not need to use CIDR notation for this (10.1.1.1/32),
though this does work.

.PARAMETER File
File containing IP addresses and ranges to block; IPv4 and IPv6 supported.
By default, the script will look for and use a file named 'blocklist.txt'.

.PARAMETER RuleName
When used with -DeleteOnly, just give the rule basename without the "-#1".

.PARAMETER ProfileType
Comma-delimited list of network profile types for which the blocking rules will apply: public, private, domain, any.
(Default = any).

.PARAMETER InterfaceType
Comma-delimited list of interface types for which the blocking rules will apply: wireless, ras, lan, any.
(Default = any).

.PARAMETER Action
Specifies that matching firewall rules of the indicated action are created. This parameter specifies the action to take
on traffic that matches this rule. The acceptable values for this parameter are: Allow or Block.
(Default = block).

.PARAMETER Description
Specifies that matching firewall rules of the indicated description are created.

.PARAMETER RuleIn
Adding rules to the firewall's inbound rules list.

.PARAMETER RuleOut
Adding rules to the firewall's outbound rules list.

.PARAMETER DeleteOnly
Matching firewall rules will be deleted, none will be created.
When used with '-RuleName', leave off the "-#1" at the end of the "RuleName".

.EXAMPLE
.\app.firewall.ip.ps1 -File 'ip.db.txt' -RuleIn

.EXAMPLE
.\app.firewall.ip.ps1 -File 'ip.db.txt' -RuleIn -ProfileType public,private

.EXAMPLE
.\app.firewall.ip.ps1 -File 'ip.db.txt' -RuleIn -InterfaceType wireless,lan

.EXAMPLE
.\app.firewall.ip.ps1 -File 'ip.db.txt' -DeleteOnly

.EXAMPLE
.\app.firewall.ip.ps1 -RuleName 'IpToBlock' -DeleteOnly

.LINK
https://libsys.ru/ru/2024/11/e756e17a-f806-5c8a-995d-92f13b436bbc/
#>

# -------------------------------------------------------------------------------------------------------------------- #
# CONFIGURATION
# -------------------------------------------------------------------------------------------------------------------- #

param(
  [Alias('F')][string]$File = 'ip.db.txt',
  [Alias('RN')][string]$RuleName = 'AUTO.RULE',
  [ValidateSet('public', 'private', 'domain', 'any')]
  [Alias('PT')][string[]]$ProfileType = 'any',
  [ValidateSet('wireless', 'lan', 'ras', 'any')]
  [Alias('IT')][string[]]$InterfaceType = 'any',
  [ValidateSet('allow', 'block', 'bypass')]
  [Alias('A')][string]$Action = 'block',
  [Alias('D')][string]$Description = "Rule created by script on $(Get-Date). Do not edit rule by hand, it will be overwritten when the script is run again. By default, the name of the rule is named after the input file.",
  [Alias('RI')][Switch]$RuleIn,
  [Alias('RO')][Switch]$RuleOut,
  [Alias('DO')][Switch]$DeleteOnly
)

$File = Get-Item "${File}" -ErrorAction 'SilentlyContinue'

# -------------------------------------------------------------------------------------------------------------------- #
# INITIALIZATION
# -------------------------------------------------------------------------------------------------------------------- #

function Start-Script() {
  if ($DeleteOnly) { Remove-Rules } else { Add-Rules }
}

# -------------------------------------------------------------------------------------------------------------------- #
# REMOVING RULES
# -------------------------------------------------------------------------------------------------------------------- #

function Remove-Rules() {
  $CurrentRules = (netsh.exe advfirewall firewall show rule name='all') | Select-String '^[Rule Name|Имя правила]+:\s+(.+$)'| ForEach-Object { $_.Matches[0].Groups[1].Value }
  if ($CurrentRules.Count -lt 3) { Write-Error 'Problem getting a list of current firewall rules!' }

  $CurrentRules | ForEach-Object {
    if ($_ -like "${RuleName} #*"){ (netsh.exe advfirewall firewall delete rule name="${_}") | Out-Null }
  }
}

# -------------------------------------------------------------------------------------------------------------------- #
# ADDING RULES
# -------------------------------------------------------------------------------------------------------------------- #

function Add-Rules() {
  # Any existing firewall rules which match the name are deleted every time the script runs.
  Remove-Rules

  $Ranges = Get-Content $File | Where-Object {
    ($_.Trim().Length -ne 0) -and ($_ -Match '^[0-9a-f]{1,4}[\.\:]')
  }

  if (-not $?) { Write-Error "Could not parse ${File}!" }

  $LineCount = $Ranges.Count
  if ($LineCount -eq 0) { Write-Warning "Zero IP addresses to block!" -WarningAction 'Stop' }

  $MaxRangesPerRule = 100
  $i = 1
  $Start = 1
  $End = $MaxRangesPerRule

  do {
    $Count = $i.ToString().PadLeft(4,'0')
    if ($End -gt $LineCount) { $End = $LineCount }
    $TextRanges = [System.String]::Join(',',$($Ranges[$($Start - 1)..$($End - 1)]))

    if($RuleIn) { Start-NetshIn -Count "${Count}" -Ranges "${TextRanges}" }
    if($RuleOut) { Start-NetshOut -Count "${Count}" -Ranges "${TextRanges}" }

    $i++
    $Start += $MaxRangesPerRule
    $End += $MaxRangesPerRule
  } while ($Start -le $LineCount)
}

# -------------------------------------------------------------------------------------------------------------------- #
# NETSH.EXE INBOUND FIREWALL RULE
# -------------------------------------------------------------------------------------------------------------------- #

function Start-NetshIn() {
  param(
    [string]$Count,
    [string]$Ranges
  )

  Write-Host "Creating an inbound firewall rule named '${RuleName} #${Count}' for IP ranges ${Start} - ${End}..."
  netsh.exe advfirewall firewall add rule name="${RuleName} #${Count}" dir='in' action="${Action}" localIp='any' remoteIp="${Ranges}" description="${Description}" profile="$([System.String]::Join(',',$ProfileType))" interfaceType="$([System.String]::Join(',',$InterfaceType))"
  if (-not $?) { Write-Host "Failed to create '${RuleName} #${Count}' inbound rule for some reason, continuing anyway..." }
}

# -------------------------------------------------------------------------------------------------------------------- #
# NETSH.EXE OUTBOUND FIREWALL RULE
# -------------------------------------------------------------------------------------------------------------------- #

function Start-NetshOut() {
  param(
    [string]$Count,
    [string]$Ranges
  )

  Write-Host "Creating an outbound firewall rule named '${RuleName} #${Count}' for IP ranges ${Start} - ${End}..."
  netsh.exe advfirewall firewall add rule name="${RuleName} #${Count}" dir='out' action="${Action}" localIp='any' remoteIp="${Ranges}" description="${Description}" profile="$([System.String]::Join(',',$ProfileType))" interfaceType="$([System.String]::Join(',',$InterfaceType))"
  if (-not $?) { Write-Host "Failed to create '${RuleName} #${Count}' outbound rule for some reason, continuing anyway..." }
}

# -------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------< RUNNING SCRIPT >------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

Start-Script
