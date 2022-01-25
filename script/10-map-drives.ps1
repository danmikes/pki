<# map Network drives #>
$script = "$PSScriptRoot\config.ps1"
. $script

$penPath = "$($PenDrive.server)\$($PenDrive.drive)"
$penMap = "$($PenDrive.map):"

$pawPath = "$($PawDrive.server)\$($PawDrive.drive)"
$pawMap = "$($PawDrive.map):"

# map PenDrive = USB-stick
try {
  net use $penMap $penPath /persistent:yes
  Write-Host "PenDrive mapped" -ForegroundColor Green
} catch {
  Write-Host "failed to map PenDrive :" $_ -ForegroundColor Red
}

# map PawDrive = LapTop
try {
  net use $pawMap $pawPath /persistent:yes
  Write-Host "PawDrive mapped" -ForegroundColor Green
} catch {
  Write-Host "failed to map PawDrive :" $_ -ForegroundColor Red
}
