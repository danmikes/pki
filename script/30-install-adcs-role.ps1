<# install Active Directory Certificate Services #>
$script = "$PSScriptRoot\config.ps1"
. $script

try {
  Install-WindowsFeature Adcs-Cert-Authority -IncludeManagementTools
  Install-WindowsFeature AD-Certificate
  Write-Host "installed ADCS" -ForegroundColor Green
} catch {
  Write-Host "failed to install ADCS" $_ -ForegroundColor Red
}
