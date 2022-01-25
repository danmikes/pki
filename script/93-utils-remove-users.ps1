<# remove users admin & resto #>
$script = "$PSScriptRoot\config.ps1"
. $script

# remove users
foreach ($user in $Users) {
  try {
    Remove-LocalUser $user
    $file = "$PSScriptRoot\$user.txt"
    Remove-Item $file
    Write-Host "deleted users" -ForegroundColor Green
  } catch {
    Write-Host "failed to remove users :" $_ -ForegroundColor Red
  }
}
