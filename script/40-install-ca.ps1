<# install Certificate Authority #>
$script = "$PSScriptRoot\config.ps1"
. $script

# make folder Certlog
if (!(Test-Path $CaDrive.certLog)) {
  New-Item $CaDrive.certLog -Type Directory -Force
}
# make folder CertEnroll
if (!(Test-Path $CaDrive.certEnroll)) {
  New-Item $CaDrive.certEnroll -Type Directory -Force
}

# Install Certification Authority
try {
  # make key
  Install-AdcsCertificationAuthority `
    -AllowAdministratorInteraction:$Install.AllowAdministratorInteraction `
    -CACommonName:$Install.CACommonName `
    -CADistinguishedNameSuffix:$Install.CADistinguishedNameSuffix `
    -CAType:$Install.CAType `
    -CryptoProviderName:$Install.CryptoProviderName `
    -OverwriteExistingCAinDS:$Install.OverwriteExistingCAinDS `
    -DatabaseDirectory:$Install.DatabaseDirectory `
    -LogDirectory:$Install.LogDirectory `
    -OverwriteExistingDatabase:$Install.OverwriteExistingDatabase `
    -OverwriteExistingKey:$Install.OverwriteExistingKey `
    -ValidityPeriod:$Install.ValidityPeriod `
    -ValidityPeriodUnits:$Install.ValidityPeriodUnits

  # use key
  # Install-AdcsCertificationAuthority -AllowAdministratorInteraction:$Install.AllowAdministratorInteraction -CACommonName:$Install.CACommonName -CADistinguishedNameSuffix:$Install.CADistinguishedNameSuffix -CAType:$Install.CAType -CryptoProviderName:$Install.CryptoProviderName KeyContainerName:$Install.CACommonName -OverwriteExistingCAinDS:$Install.OverwriteExistingCAinDS -DatabaseDirectory:$Install.DatabaseDirectory -LogDirectory:$Install.LogDirectory -OverwriteExistingDatabase:$Install.OverwriteExistingDatabase -OverwriteExistingKey:$Install.OverwriteExistingKey -ValidityPeriod:$Install.ValidityPeriod -ValidityPeriodUnits:$Install.ValidityPeriodUnits

  Write-Host "installed CA : $($Install.CACommonName)" -ForegroundColor Green
} catch {
  Write-Host "failed to install CA : $($Install.CACommonName)" $_ -ForegroundColor Red
}

# publish Certificate Revocation List
# todo : !!!
# certutil -getreg CA | Publish-CRL -UpdateFile
