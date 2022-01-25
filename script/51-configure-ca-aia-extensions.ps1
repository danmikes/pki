# using adcsadministration commandlets https://docs.microsoft.com/en-us/powershell/module/adcsadministration
$script = "$PSScriptRoot\config.ps1"
. $script

# deleteCAAuthorityInformationAccess
try {
  # do not remove filepath C:\Windows\System32\CertSrv\CertEnroll from extensions
  Get-CAAuthorityInformationAccess | Where-Object{$_.uri -Notlike $CaDrive.CertEnroll} | Remove-CAAuthorityInformationAccess -Force
  Write-Host "deleted CAAuthorityInformationAccess" -ForegroundColor Green
} catch {
  Write-Host "failed to delete CAAuthorityInformationAccess :" $_ -ForegroundColor Red
}

# addCAAuthorityInformationAccess
try {
  forEach ($key in $AiaCustomExtensions.Keys) {
    if($AiaCustomExtensions.$key.AddToCertificateAia ){  # only one of flags: AddToCertificateAia , AddToCertificateOCSP can be set! otherwise cmdlet returns an error
      Add-CAAuthorityInformationAccess `
        -Uri $AiaCustomExtensions.$key.Uri `
        -AddToCertificateAia -Force
      Write-Host "added" $AiaCustomExtensions.$key.Uri -ForegroundColor Green
    }
    else{ 
      Add-CAAuthorityInformationAccess `
        -Uri $AiaCustomExtensions.$key.Uri `
        -AddToCertificateOCSP -Force 
      Write-Host "added" $AiaCustomExtensions.$key.Uri -ForegroundColor Green
    }
  }
  Write-Host "added CAAuthorityInformationAccess" -ForegroundColor Green
  Write-Host "restarting CA" -ForegroundColor Green
  Stop-Service certsvc
  Start-Service certsvc

} catch {
  Write-Host "failed to add CAAuthorityInformationAccess :" $_ -ForegroundColor Red
}
