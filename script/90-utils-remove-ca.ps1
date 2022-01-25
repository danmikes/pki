<# uninstall CA role service #>
$script = "$PSScriptRoot\config.ps1"
. $script

# stop CA service
Stop-Service certsvc

# remove CA
try {
  Uninstall-AdcsCertifiCAtionAuthority -Force
  Write-Host "removed CA" -ForegroundColor Green
} catch {
  Write-Host "failed to remove RootCA :" $_ -ForegroundColor Red
}
