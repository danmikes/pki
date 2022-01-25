<# cdp extensions #>
$script = "$PSScriptRoot\config.ps1"
. $script

# deleteCACRLDistributionPoints
try {
  Get-CACrlDistributionPoint | Where-Object{$_.uri -Notlike $CaDrive.CertEnroll} | Remove-CACrlDistributionPoint -Force
  Write-Host "deleted CACRLDistributionPoints" -ForegroundColor Green
} catch {
  Write-Host "failed to delete CACRLDistributionPoints " $_ -ForegroundColor Red
}

# addCACRLDistributionPoint
try {
  forEach ($key in $CdpCustomExtensions.Keys) {
    if($key -eq 'ldap'){
      Add-CACRLDistributionPoint `
        -Uri:$CdpCustomExtensions.$key.Uri `
        -PublishToServer:$CdpCustomExtensions.$key.PublishToServer `
        -PublishDeltaToServer:$CdpCustomExtensions.$key.PublishDeltaToServer `
        -AddToCertificateCdp:$CdpCustomExtensions.$key.AddToCertificateCdp `
        -AddToFreshestCRl:$CdpCustomExtensions.$key.AddToFreshestCrl `
        -AddToCrlCdp:$CdpCustomExtensions.$key.AddToCrlCdp `
        -AddToCrlIdp:$CdpCustomExtensions.$key.AddToCrlIdp `
        -Force
    }
    else{
      Add-CACRLDistributionPoint `
        -Uri:$CdpCustomExtensions.$key.Uri `
        -AddToCertificateCdp:$CdpCustomExtensions.httppem.AddToCertificateCdp `
        -AddToCrlIdp:$CdpCustomExtensions.httppem.AddToCrlIdp `
        -AddToFreshestCRl:$CdpCustomExtensions.httppem.AddToFreshestCrl `
        -Force
    }
  Write-Host "added CACRLDistributionPoints" -ForegroundColor Green
  }
} 
catch {
  Write-Host "failed to add CACRLDistributionPoints $_" -ForegroundColor Red
}

Stop-Service certsvc
Start-Service certsvc
