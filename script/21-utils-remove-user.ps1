<# remove tempuser #>
$script = "$PSScriptRoot\config.ps1"
. $script

# remove tempUser
try {
  Remove-LocalUser $TempUser
  Remove-Item 
  Write-Host "deleted temporary" -ForegroundColor Green
} catch {
  Write-Host "failed to remove temporary user :" $_ -ForegroundColor Red
}
