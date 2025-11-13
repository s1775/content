<#PSScriptInfo
.VERSION      0.1.0
.GUID         c04a9c7b-cfcd-4f25-b7a0-51bfe7dfc986
.AUTHOR       Kai Kimera
.AUTHOREMAIL  mail@kai.kim
.COMPANYNAME  Library Online
.COPYRIGHT    2024 Library Online. All rights reserved.
.TAGS         windows tls ssl
.LICENSEURI   https://choosealicense.com/licenses/mit/
.PROJECTURI   https://libsys.ru/ru/2024/11/c915c17d-8e2a-5020-8d55-c81075f4fb65/
#>

<#
.SYNOPSIS

.DESCRIPTION

.PARAMETER Protocols

.PARAMETER Path

.PARAMETER Disable

.EXAMPLE
.\app.tls.ps1

.EXAMPLE
.\app.tls.ps1 -Protocols 'SSL 2.0', 'SSL 3.0', 'TLS 1.0', 'TLS 1.1' -Disable

.LINK
https://libsys.ru/ru/2024/11/c915c17d-8e2a-5020-8d55-c81075f4fb65/
#>

# -------------------------------------------------------------------------------------------------------------------- #
# CONFIGURATION
# -------------------------------------------------------------------------------------------------------------------- #

param(
  [ValidateSet('SSL 2.0', 'SSL 3.0', 'TLS 1.0', 'TLS 1.1', 'TLS 1.2', 'TLS 1.3', IgnoreCase = $false)]
  [Parameter(Mandatory)][Alias('L')][string[]]$Protocols = @('TLS 1.2'),
  [Alias('P')][string]$Path = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols',
  [Alias('D')][switch]$Disable
)

# -------------------------------------------------------------------------------------------------------------------- #
# INITIALIZATION
# -------------------------------------------------------------------------------------------------------------------- #

function Start-Script() { Set-Protocols }

# -------------------------------------------------------------------------------------------------------------------- #
# SETTING PROTOCOLS
# -------------------------------------------------------------------------------------------------------------------- #

function Set-Protocols {
  if ($Disable) {
    $Enabled = 0
    $Disabled = 1
    $Text = 'Disabled'
  } else {
    $Enabled = 1
    $Disabled = 0
    $Text = 'Enabled'
  }

  foreach ($Protocol in $Protocols) {
    foreach ($Type in @('Server', 'Client')) {
      $FullPath = "${Path}\${Protocol}\${Type}"
      $DataDisabled = @{ Path = "${FullPath}"; Name = 'DisabledByDefault'; }
      $DataEnabled = @{ Path = "${FullPath}"; Name = 'Enabled'; }

      if (!(Test-Path -Path "${FullPath}")) { New-Item -Path "${FullPath}" -Force | Out-Null }

      if ($null -eq (Get-ItemProperty @DataDisabled -ErrorAction 'SilentlyContinue')) {
        New-ItemProperty @DataDisabled -Value $Disabled -PropertyType 'DWord' | Out-Null
      } else {
        Set-ItemProperty @DataDisabled -Value $Disabled | Out-Null
      }

      if ($null -eq (Get-ItemProperty @DataEnabled -ErrorAction 'SilentlyContinue')) {
        New-ItemProperty @DataEnabled -Value $Enabled -PropertyType 'DWord' | Out-Null
      } else {
        Set-ItemProperty @DataEnabled -Value $Enabled | Out-Null
      }
    }

    Write-Host "${Text} ${Protocol} registry keys for client and server SCHANNEL communications!" -ForegroundColor 'Yellow'
  }
}

# -------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------< RUNNING SCRIPT >------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

Start-Script
