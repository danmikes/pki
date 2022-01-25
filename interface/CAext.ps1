<# INTERFACE #>
class CAExt {
  static [void] deleteCAAuthorityInformationAccess([Env] $env) {
    $ca = $env.CAext
    try {
      Get-CAAuthorityInformationAccess |
      Where-Object{($_.uri -like "http*") -or ($_.uri -like "ldap*")} |
      Remove-CAAuthorityInformationAccess -force
      Write-Host "deleted CAAuthorityInformationAccess : $($ca.CAAuthorityInformationAccess)"
    } catch {
      Write-Host "failed to delete CAAuthorityInformationAccess : $($ca.CAAuthorityInformationAccess)"
    }
  }

  static [void] deleteCACRLDistributionPoint([Env] $env) {
    $ca = $env.CAext
    try {
      Get-CACrlDistributionPoint | `
      Where-Object{($_.uri -like "http*") -or ($_.uri -like "ldap*")} |
      Remove-CACrlDistributionPoint -Force
      Write-Host "deleted CACRLDistributionPoint : $($ca.CACRLDistributionPoint)"
    } catch {
      Write-Host "failed to delete CACRLDistributionPoint : $($ca.CACRLDistributionPoint)"
    }
  }

  static [void] addCAAuthorityInformationAccess([Env] $env) {
    $ca = $env.CAext
    try {
      forEach ($key in $ca.CAAuthorityInformationAccess.Keys) {
        Add-CAAuthorityInformationAccess`
          -Uri $key.Uri`
          -AddToCertificateAia:$key.AddToCertificateAia`
          -AddToCertificateOCSP:$key.AddToCertificateOCSP`
          -Force
      }
      Write-Host "added CAAuthorityInformationAccess : $($ca.CAAuthorityInformationAccess)"
    } catch {
      Write-Host "failed to add CAAuthorityInformationAccess : $($ca.CAAuthorityInformationAccess)"
    }
  }

  static [void] addCACRLDistributionPoint([Env] $env) {
    $ca = $env.CAext
    try {
      forEach ($key in $ca.CACRLDistributionPoint.Keys) {
        Add-CACRLDistributionPoint`
          -Uri $key.Uri`
          -PublishToServer:$key.PublishToServer`
          -PublishDeltaToServer:$key.PublishDeltaToServer`
          -AddToCertificateCdp:$key.AddToCertificateCdp `
          -AddToFreshestCRl:$key.AddToFreshestCrl`
          -AddToCrlCdp:$key.AddToCrlCdp `
          -AddToCrlldp:$key.AddToCrlldp `
          -Force`
      }
      Write-Host "added CACRLDistributionPoint : $($ca.CACRLDistributionPoint)"
    } catch {
      Write-Host "failed to add CACRLDistributionPoint : $($ca.CACRLDistributionPoint)"
    }
  }

  static [void] getAIA([Env] $env) {
    $ca = $env.CAext
    try {
      Get-CAAuthorityInformationAccess
      Write-Host "retrieved CA : $($ca.CAAuthorityInformationAccess)"
    } catch {
      Write-Host "failed to retrieve CA : $($ca.CAAuthorityInformationAccess)"
    }
  }

  static [void] getCDP([Env] $env) {
    $ca = $env.CAext
    try {
      Get-CACRLDistributionPoint
      Write-Host "retrieved CA : $($ca.CACRLDistributionPoint)"
    } catch {
      Write-Host "failed to retrieve CA : $($ca.CACRLDistributionPoint)"
    }
  }
}
