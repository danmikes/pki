. .\Env.ps1
. .\DNS.ps1

enum CAType {
  rootca
}

class CA {
  [CAType] $CAName
  [string] $AllowAdministratorInteraction = $true
  [string] $CACommonName
  [string] $CADistinguishedNameSuffix
  [string] $CAType ='StandAlone'
  [string] $DatabaseDirectory
  [string] $LogDirectory
  [string] $OverwriteExistingCAinDS = $true
  [string] $OverwriteExistingDatabase = $true
  [string] $OverwriteExistingKey = $true
  [string] $ValidityPeriod = 20
  [string] $ValidityPeriodUnits = 'Years'
  [string[]] $CAAuthorityInformationAccess
  [string[]] $CACRLDistributionPoint

  CA([CAType] $caName, [EnvType] $env, [DNS] $dns) {
    $this.CACommonName = $CAName
    $this.CADistinguishedNameSuffix = $dns.CADistinguishedNameSuffix
    $this.deleteAia()
    $this.deleteCdp()
    $this.CAAuthorityInformationAccess = $this.addAia()
    $this.CACRLDistributionPoint = $this.addCdp()
    $this.DatabaseDirectory = $env.CADatabaseDirectory
    $this.LogDirectory = $env.LogDirectory
    $this.createCA()
    $this.publishCA()
    $this.checkCA()
  }

  [void] createCA() {
    try {
      Install-ADcsCertificationAuthority $rootCA -Force
    } catch { Write-Host "failed to create RootCA" -ForegroundColor Yellow }
  }

  [void] publishCA() {
    try {
      Rename-Item "$pathCrt\rootca_$caName.crt" "$pathCrt\$caName.crt"
      Publish-Crl -UpdateFile
    } catch { Write-Host "failed to publish crl" -ForegroundColor Red }
  }
  
  [void] checkCA() {
    try {
      Get-CAAuthorityInformationAccess
      Get-CACrlDistributionPoint
      Invoke-WebRequest $urlAia
      Invoke-WebRequest $urlCdp
    } catch { Write-Host "failed to test website" -ForegroundColor Red }
  }

  [void] backupCA() {
    $folder = getFolder
    $path = "$pathBackup\$folder"
    try {
      Backup-CARoleService -Path $path
    } catch { Write-Host "failed to save RootCA" -ForegroundColor Red }
  }

  static [CA] getCA() {
    # TODO : retrieve CA
    return $null
  }

  static [void] restoreCA() {
    $folder = getLastFolder
    $path = "$pathBackup\$folder"
    try {
      Restore-CARoleService -Path $path
    } catch { Write-Host "failed to restore RootCA" -ForegroundColor Red }
  }

  static [void] deleteCA() {
    try {
      Uninstall-AdcsCertificationAuthority -Force
    } catch { Write-Host "failed to remove RootCA" -ForegroundColor Yellow }
  }

  [void] addPolicy() {
    Copy-Item "$pathApp\CAPolicy.inf" $pathWin -Force
  }

  [void] deletePolicy() {
    Remove-Item "$pathWin\CAPolicy.inf" -Force
  }

  [void] deleteAia() {
    Get-CAAuthorityInformationAccess |
    Where-Object{($_.uri -like "http*") -or ($_.uri -like "ldap*")} |
    Remove-CAAuthorityInformationAccess -force
  }

  [void] deleteCdp() {
    Get-CACrlDistributionPoint | `
    Where-Object{($_.uri -like "http*") -or ($_.uri -like "ldap*")} |
    Remove-CACrlDistributionPoint -Force
  }

  [void] addAia() {
    $uriAia = [ordered]@{
      crt = [ordered] @{
        uri = "65:$($pathCrt)\$($caName).crt"
        AddToCertificateAia = $True
      }
      pem = [ordered] @{
        uri = "5:$($dirAia)/$($caName).pem"
        AddToCertificateAia = $True
      }
      crl = [ordered] @{
        uri = "6:$($dirAia)/$($caName).crl"
        AddToCertificateAia = $True
      }
      ldap = [ordered] @{
        uri = "79:$($ldapAia)"
        AddToCertificateAia = $True
      }
    }

    forEach ($uri in $uriAia.Keys) {
      Add-CAAuthorityInformationAccess -Uri $uri.uri -Force
        -AddToCertificateAia:$uri.uri
    }
  }

  [void] addCdp() {
    $uriCdp = [ordered] @{
      crt = [ordered] @{
        uri = "65:$($pathCrt)\$($caName).crt"
        AddToCertificateCdp = $True
        AddToCrlIdp = $False
        AddToFreshestCrl = $True
      }
      pem = [ordered] @{
        uri = "5:$($dirCdp)/$($caName).crl.pem"
        AddToCertificateCdp = $True
        AddToCrlIdp = $False
        AddToFreshestCrl = $True
      }
      crl = [ordered] @{
        uri = "6:$($dirCdp)/$($caName).crl"
        AddToCertificateCdp = $True
        AddToCrlIdp = $False
        AddToFreshestCrl = $True
      }
      ldap = [ordered] @{
        uri = "79:$($ldapCdp)"
        AddToCertificateCdp = $True
        AddToCrlIdp = $False
        AddToFreshestCrl = $True
      }
    }

    forEach ($uri in $uriCdp.Keys) {
      Add-CACRLDistributionPoint -Uri $uri.uri -Force
        -AddToCertificateCdp:$uri.AddToCertificateCdp `
        -AddToCrlIdp:$uri.AddToCrlIdp `
        -AddToFreshestCrl:$uri.AddToFreshestCrl
    }
  }

  [void] makePem() {
    $fileTypes = @{
      crt = 'x509'
      crl = 'crl'
    }

    foreach ($key in $fileTypes.keys) {
      $Argumentlist = "{3} -inform DER -outform PEM `
        -in {0}\{1}.{2} -out {0}\{1}.{2}.pem" `
       -f $pathCrt, $caName, $key, $fileTypes[$key]
       Start-Process -FilePath "$pathSsl\openssl.exe" `
        -ArgumentList $ArgumentList `
        -RedirectStandardError "$pathSsl\output\stderror.txt" `
        -RedirectStandardOutput "$pathSsl\output\stdout.txt"
    }
  }
  
  [void] getFolder() {
    if (!(Test-Path -Path "$pathBackup\initial")) {
      $path = "$pathBackup\initial"
    } else {
      $date = Get-Date -Format "yyyyMMdd"
      $path = "$pathBackup\$date"
    }
    New-Item $path -Type Directory -Force
  }
  
  [string] getLastFolder($folder) {
    $path = "$pathBackup\$folder"
    if (!(Test-Path -Path $pathBackup) -or !(Test-Path -Path $pathBackup\*)) {
      Write-Host "Backup folder absent" -ForegroundColor Red
      return $null
    } elseif (($null -ne $folder) -and !(Test-Path -Path $path)) {
      Write-Host "Backup folder absent" -ForegroundColor Red
      return $null
    } elseif ($null -eq $folder) {
      $last = Get-ChildItem -Path $path | Sort-Object LastAccessTime -Descending | Select-Object -First 1
      Write-Host "found backup folder : $path" -ForegroundColor Yellow
      return $last.name
    }
    return $null
  }
}

[Env] $env = [Env]::new([EnvType]::local)
[DNS] $dns = [DNS]::new([CAType]::rootca, [EnvType]::local)
[CA] $rootca = [CA]::rootca([EnvType] $env, [DNS] $dns)
$rootca
