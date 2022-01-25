<# INTERFACE #>
class CA {
  static [void] createCA([Env] $env) {
    $ca = $env.CAmain
    try {
      Install-ADcsCertifiCAtionAuthority
        -CAName:$ca.CAName
        -AllowAdministratorInteraction:$ca.AllowAdministratorInteraction
        -CACommonName:$ca.CACommonName
        -CADistinguishedNameSuffix:$ca.CADistinguishedNameSuffix
        -CAType:$ca.CAType
        -DatabaseDirectory:$ca.DatabaseDirectory
        -LogDirectory:$ca.LogDirectory
        -OverwriteExistingCAinDS:$ca.OverwriteExistingCAinDS
        -OverwriteExistingDatabase:$ca.OverwriteExistingDatabase
        -OverwriteExistingKey:$ca.OverwriteExistingKey
        -ValidityPeriod:$ca.ValidityPeriod
        -ValidityPeriodUnits:$ca.ValidityPeriodUnits
        -Force
      Write-Host "installed CA : $($ca.CACommonName)" -ForegroundColor Green
    } catch {
      Write-Host "failed to install CA : $($ca.CACommonName)" -ForegroundColor Red
    }
  }

  static [void] publishCA([Env] $env) {
    $ca = $env.CAmain
    try {
      Rename-Item "$($ca.dirCrt)\rootCA_$($ca.CACommonName).crt" "$($ca.dir.dirCrt)\$($ca.CACommonName).crt"
      Publish-Crl -UpdateFile
      Write-Host "published CRL : $($ca.CACommonName)" -ForegroundColor Green
    } catch {
      Write-Host "failed to publish crl : $($ca.CACommonName)" -ForegroundColor Red
    }
  }

  static [void] checkCA([Env] $env) {
    $ca = $env.CAmain
    $uri = $env.Uri
    try {
      Get-CAAuthorityInformationAccess
      Get-CACrlDistributionPoint
      Invoke-WebRequest $uri.uri.urlAia
      Invoke-WebRequest $Uri.uri.urlCdp
      Write-Host "checked CA : $($ca.CACommonName)" -ForegroundColor Green
    } catch {
      Write-Host "failed to test website: $($ca.CACommonName)" -ForegroundColor Red
    }
  }

  static [void] backupCA([Env] $env) {
    $ca = $env.CAmain
    try {
      $backup = $ca.getBackup($env)
      Backup-CARoleService -Path $backup
      Write-Host "backed-up CA : $($ca.CACommonName)" -ForegroundColor Green
    } catch {
      Write-Host "failed to save RootCA : $($ca.CACommonName)" -ForegroundColor Red
    }
  }

  static [void] restoreCA([Env] $env) {
    $ca = $env.CAmain
    try {
      Restore-CARoleService -Path $env.dir.backup
      Write-Host "restored CA : $($ca.CACommonName)" -ForegroundColor Green
    } catch {
      Write-Host "failed to restore RootCA : $($ca.CACommonName)" -ForegroundColor Red
    }
  }

  static [void] deleteCA([Env] $env) {
    $ca = $env.CAmain
    try {
      Uninstall-AdcsCertifiCAtionAuthority -Force
      Write-Host "deleted CA : $($ca.CACommonName)"
    } catch { Write-Host "failed to remove RootCA" -ForegroundColor Yellow }
  }

  static [void] getCA([Env] $env) {
    $ca = $env.CAmain
    try {
      Get-ADObject -Identity "CACommonName=$($ca.CACommonName)"
      Write-Host "retrieved CA : $($ca.CACommonName)"
    } catch {
      Write-Host "failed to retrieve CA : $($ca.CACommonName)"
    }
  }
}
