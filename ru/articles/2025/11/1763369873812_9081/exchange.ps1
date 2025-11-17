function Get-HostName {
  [System.Net.Dns]::GetHostName().ToLower()
}

function Get-FQDN {
  [System.Net.Dns]::GetHostEntry($env:ComputerName).HostName.ToLower()
}

function Get-WinName {
  [int]$Ver = ((Get-ComputerInfo).WindowsProductName | Select-String -Pattern '\d+' | ForEach-Object {$_.Matches.Value})
  return $Ver
}

function Install-ExFeature() {
  <#
    .SYNOPSIS
    .DESCRIPTION
    Installs one or more roles, role services, or features on either the local or a specified remote server that is
    running Windows Server.
    .EXAMPLE
    Install-ExFeature
    .LINK
    https://learn.microsoft.com/en-us/exchange/plan-and-deploy/prerequisites-2016
    .LINK
    https://learn.microsoft.com/en-us/exchange/plan-and-deploy/prerequisites
  #>

  $WinName = $(Get-WinName)

  $Features = @(
    'Web-Mgmt-Console',
    'Web-Metabase'
  ); Install-WindowsFeature -Name $Features

  if ($WinName -eq 2016) {
    $Features = @(
      'NET-Framework-45-Core',
      'NET-Framework-45-ASPNET',
      'NET-WCF-HTTP-Activation45',
      'NET-WCF-Pipe-Activation45',
      'NET-WCF-TCP-Activation45',
      'NET-WCF-TCP-PortSharing45',
      'Server-Media-Foundation',
      'RPC-over-HTTP-proxy',
      'RSAT-Clustering',
      'RSAT-Clustering-CmdInterface',
      'RSAT-Clustering-Mgmt',
      'RSAT-Clustering-PowerShell',
      'WAS-Process-Model',
      'Web-Asp-Net45',
      'Web-Basic-Auth',
      'Web-Client-Auth',
      'Web-Digest-Auth',
      'Web-Dir-Browsing',
      'Web-Dyn-Compression',
      'Web-Http-Errors',
      'Web-Http-Logging',
      'Web-Http-Redirect',
      'Web-Http-Tracing',
      'Web-ISAPI-Ext',
      'Web-ISAPI-Filter',
      'Web-Lgcy-Mgmt-Console',
      'Web-Metabase',
      'Web-Mgmt-Console',
      'Web-Mgmt-Service',
      'Web-Net-Ext45',
      'Web-Request-Monitor',
      'Web-Server',
      'Web-Stat-Compression',
      'Web-Static-Content',
      'Web-Windows-Auth',
      'Web-WMI',
      'Windows-Identity-Foundation',
      'RSAT-ADDS'
    ); Install-WindowsFeature -Name $Features
  }

  if ($WinName -ge 2019) {
    $Features = @(
      'Server-Media-Foundation',
      'NET-Framework-45-Core',
      'NET-Framework-45-ASPNET',
      'NET-WCF-HTTP-Activation45',
      'NET-WCF-Pipe-Activation45',
      'NET-WCF-TCP-Activation45',
      'NET-WCF-TCP-PortSharing45',
      'RPC-over-HTTP-proxy',
      'RSAT-Clustering',
      'RSAT-Clustering-CmdInterface',
      'RSAT-Clustering-Mgmt',
      'RSAT-Clustering-PowerShell',
      'WAS-Process-Model',
      'Web-Asp-Net45',
      'Web-Basic-Auth',
      'Web-Client-Auth',
      'Web-Digest-Auth',
      'Web-Dir-Browsing',
      'Web-Dyn-Compression',
      'Web-Http-Errors',
      'Web-Http-Logging',
      'Web-Http-Redirect',
      'Web-Http-Tracing',
      'Web-ISAPI-Ext',
      'Web-ISAPI-Filter',
      'Web-Metabase',
      'Web-Mgmt-Console',
      'Web-Mgmt-Service',
      'Web-Net-Ext45',
      'Web-Request-Monitor',
      'Web-Server',
      'Web-Stat-Compression',
      'Web-Static-Content',
      'Web-Windows-Auth',
      'Web-WMI',
      'Windows-Identity-Foundation',
      'RSAT-ADDS'
    ); Install-WindowsFeature -Name $Features
  }
}

function Import-ExCert() {
  <#
    .SYNOPSIS
    .DESCRIPTION
    .PARAMETER File
    Specifies the path for the PFX file.
    .PARAMETER Store
    Specifies the path of the store to which certificates will be imported.
    If this parameter is not specified, then the current path is used as the destination store.
    .EXAMPLE
    Import-ExCert -File 'C:\cert.pfx' -Store 'Cert:\LocalMachine\Root'
    .LINK
  #>

  param(
    [Parameter(Mandatory)][Alias('F')][string]$File,
    [Alias('S')][string]$Store = 'Cert:\LocalMachine\My'
  )

  $Password = Read-Host -AsSecureString -Prompt 'Enter password'

  $PfxCertificate = @{
    FilePath = "${File}"
    CertStoreLocation = "${Store}"
    Password = "${Password}"
    Exportable = $True
  }

  Import-PfxCertificate @PfxCertificate && Get-ExchangeCertificate | Format-List Subject,Services,Thumbprint
}

function Set-ExCert() {
  <#
    .SYNOPSIS
    .DESCRIPTION
    .PARAMETER Thumbprint
    The Thumbprint parameter specifies the thumbprint value of the certificate that you want to view.
    .EXAMPLE
    Set-ExCert -Thumbprint '5CEC8544D4743BC279E5FEA1679F79F5BD0C2B3A'
    .LINK
  #>

  param(
    [Parameter(Mandatory)][Alias('T')][string]$Thumbprint
  )

  $ExchangeCertificate = @{
    Services = 'IMAP', 'POP', 'IIS', 'SMTP'
  }

  Get-ExchangeCertificate -Thumbprint "${Thumbprint}" | Enable-ExchangeCertificate @ExchangeCertificate
}

function New-ExDB {
  <#
    .SYNOPSIS
    .DESCRIPTION
    .PARAMETER Server
    The Server parameter specifies the Exchange server where you want to run this command.
    You can use any value that uniquely identifies the server. For example:
    - Name.
    - FQDN.
    - Distinguished name (DN).
    - Exchange Legacy DN.
    .PARAMETER Name
    The Name parameter specifies the name of the new mailbox database.
    The maximum length is 64 characters. If the value contains spaces, enclose the value in quotation marks (").
    .PARAMETER EdbFile
    The EdbFilePath parameter specifies the path to the database files.
    .PARAMETER LogFolder
    The LogFolder parameter specifies the folder location for log files.
    .EXAMPLE
    New-ExDB -Server 'mx01' -Name 'DB01' -EdbFile 'D:\DB01\DB01.edb' -LogFolder 'D:\DB01\Log'
    .LINK
  #>

  param(
    [Alias('S')][string]$Server = $(Get-HostName),
    [Parameter(Mandatory)][Alias('N')][string]$Name,
    [Parameter(Mandatory)][Alias('EDB')][string]$EdbFile,
    [Parameter(Mandatory)][Alias('LOG')][string]$LogFolder
  )

  $Database = @{
    Server = "${Server}"
    Name = "${Name}"
    EdbFilePath = "${EdbFile}"
    LogFolderPath = "${LogFolder}"
  }

  New-MailboxDatabase @Database
}

function Rename-ExDB() {
  <#
    .SYNOPSIS
    .DESCRIPTION
    .PARAMETER In
    The In parameter specifies the mailbox database that you want to rename.
    You can use any value that uniquely identifies the database. For example:
    - Name.
    - Distinguished name (DN).
    - GUID.
    .PARAMETER Out
    The Out parameter specifies the unique name of the mailbox database. The maximum length is 64 characters.
    If the value contains spaces, enclose the value in quotation marks (").
    .EXAMPLE
    Rename-ExDB -In 'Mailbox Database 0974770101' -Out 'DB01'
    .LINK
  #>

  param(
    [Parameter(Mandatory)][Alias('I')][string]$In,
    [Parameter(Mandatory)][Alias('O')][string]$Out
  )

  Get-MailboxDatabase -Identity "${In}" | Set-MailboxDatabase -Name "${Out}"
}

function Move-ExDB() {
  <#
    .SYNOPSIS
    .DESCRIPTION
    .PARAMETER Identity
    The Identity parameter specifies the database that you want to move.
    You can use any value that uniquely identifies the database. For example:
    - Name.
    - Distinguished name (DN).
    - GUID.
    .PARAMETER EdbFile
    The EdbFile parameter specifies a new file path for the database. All current database files are moved to this
    location. This file path can't be the same as the path for the backup copy of the database.
    .PARAMETER LogFolder
    The LogFolder parameter specifies the folder where log files are stored.
    .EXAMPLE
    Move-ExDB -Identity 'DB01' -EdbFile 'D:\DB01\DB01.edb' -LogFolder 'D:\DB01\Log'
    .LINK
  #>

  param(
    [Parameter(Mandatory)][Alias('ID')][string]$Identity,
    [Parameter(Mandatory)][Alias('EDB')][string]$EdbFile,
    [Parameter(Mandatory)][Alias('LOG')][string]$LogFolder
  )

  $DatabasePath = @{
    Identity = "${Identity}"
    EdbFilePath = "${EdbFile}"
    LogFolderPath = "${LogFolder}"
  }

  Move-DatabasePath @DatabasePath
}

function Set-ExCAS() {
  <#
    .SYNOPSIS
    .DESCRIPTION
    .PARAMETER Identity
    The Identity parameter specifies the server with the Client Access server role installed that you want to view.
    You can use any value that uniquely identifies the server. For example:
    - Name (for example, Exchange01).
    - Distinguished name (DN) (for example, CN=Exchange01,CN=Servers,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=First Organization,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=contoso,DC=com).
    - Exchange Legacy DN (for example, /o=First Organization/ou=Exchange Administrative Group (FYDIBOHF23SPDLT)/cn=Configuration/cn=Servers/cn=Exchange01).
    - GUID (for example, bc014a0d-1509-4ecc-b569-f077eec54942).
    .PARAMETER InternalUri
    The InternalUri parameter specifies the internal URL of the Autodiscover service.
    .EXAMPLE
    Set-ExCAS -Identity 'mx01' -InternalUri 'https://mail.internal.local'
    .LINK
  #>

  param(
    [Alias('ID')][string]$Identity = $(Get-HostName),
    [Alias('IU')][string]$InternalUri = $(Get-FQDN)
  )

  $ClientAccessService = @{
    AutoDiscoverServiceInternalUri = "https://${InternalUri}/Autodiscover/Autodiscover.xml"
  }

  Get-ClientAccessService -Identity "${Identity}" | Set-ClientAccessService @ClientAccessService
}

function Set-ExVD() {
  <#
    .SYNOPSIS
    .DESCRIPTION
    .PARAMETER Server
    The Server parameter specifies the Exchange server that hosts the virtual directory.
    You can use any value that uniquely identifies the server. For example:
    - Name.
    - FQDN.
    - Distinguished name (DN).
    - ExchangeLegacyDN.
    .PARAMETER InternalUrl
    The InternalUrl parameter specifies the URL that connects to the virtual directory from inside the firewall.
    The value of this parameter is important when connections are encrypted by Transport Layer Security (TLS).
    .PARAMETER ExternalUrl
    The ExternalUrl parameter specifies the URL that connects to the virtual directory from outside the firewall.
    The value of this parameter is important when connections are encrypted by Transport Layer Security (TLS).
    .EXAMPLE
    Set-ExVD -Server 'mx01' -InternalUrl 'https://mail.internal.local' -ExternalUrl 'https://mail.example.com'
    .LINK
  #>

  param(
    [Alias('SRV')][string]$Server = $(Get-HostName),
    [Alias('IU')][string]$InternalUrl = $(Get-FQDN),
    [Alias('EU')][string]$ExternalUrl = $(Get-FQDN)
  )

  $ECP = @{
    InternalUrl = "https://${InternalUrl}/ecp"
    ExternalUrl = "https://${ExternalUrl}/ecp"
  }

  $EWS = @{
    InternalUrl = "https://${InternalUrl}/EWS/Exchange.asmx"
    ExternalUrl = "https://${ExternalUrl}/EWS/Exchange.asmx"
  }

  $MAPI = @{
    InternalUrl = "https://${InternalUrl}/mapi"
    ExternalUrl = "https://${ExternalUrl}/mapi"
  }

  $MSA = @{
    InternalUrl = "https://${InternalUrl}/Microsoft-Server-ActiveSync"
    ExternalUrl = "https://${ExternalUrl}/Microsoft-Server-ActiveSync"
  }

  $OAB = @{
    InternalUrl = "https://${InternalUrl}/OAB"
    ExternalUrl = "https://${ExternalUrl}/OAB"
  }

  $OWA = @{
    InternalUrl = "https://${InternalUrl}/owa"
    ExternalUrl = "https://${ExternalUrl}/owa"
  }

  $PS = @{
    InternalUrl = "http://${InternalUrl}/powershell"
    ExternalUrl = "http://${ExternalUrl}/powershell"
  }

  Get-EcpVirtualDirectory -Server "${Server}" | Set-EcpVirtualDirectory @ECP
  Get-WebServicesVirtualDirectory -Server "${Server}" | Set-WebServicesVirtualDirectory @EWS
  Get-MapiVirtualDirectory -Server "${Server}" | Set-MapiVirtualDirectory @MAPI
  Get-ActiveSyncVirtualDirectory -Server "${Server}" | Set-ActiveSyncVirtualDirectory @MSA
  Get-OabVirtualDirectory -Server "${Server}" | Set-OabVirtualDirectory @OAB
  Get-OwaVirtualDirectory -Server "${Server}" | Set-OwaVirtualDirectory @OWA
  Get-PowerShellVirtualDirectory -Server "${Server}" | Set-PowerShellVirtualDirectory @PS
}

function Set-ExOA() {
  <#
    .SYNOPSIS
    .DESCRIPTION
    .PARAMETER Server
    The Server parameter specifies the Exchange server that hosts the virtual directory.
    You can use any value that uniquely identifies the server. For example:
    - Name.
    - FQDN.
    - Distinguished name (DN).
    - ExchangeLegacyDN.
    .PARAMETER InternalHost
    The InternalHostname parameter specifies the internal hostname for the Outlook Anywhere virtual directory.
    For example, mail.contoso.com.
    .PARAMETER ExternalHost
    The ExternalHostname parameter specifies the external hostname for the Outlook Anywhere virtual directory.
    For example, mail.contoso.com.
    .EXAMPLE
    Set-ExOA -Server 'mx01' -InternalHost 'https://mail.internal.local' -ExternalHost 'https://mail.example.com'
    .LINK
  #>

  param(
    [Alias('S')][string]$Server = $(Get-HostName),
    [Alias('I')][string]$InternalHost = $(Get-FQDN),
    [Alias('E')][string]$ExternalHost = $(Get-FQDN)
  )

  $OutlookAnywhere = @{
    InternalHostname = "${InternalHost}"
    ExternalHostname = "${ExternalHost}"
    ExternalClientAuthenticationMethod = 'NTLM'
    ExternalClientsRequireSsl = $True
    InternalClientsRequireSsl = $True
  }

  Get-OutlookAnywhere -Server "${Server}" | Set-OutlookAnywhere @OutlookAnywhere
}
