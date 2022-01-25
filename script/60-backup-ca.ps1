<# backup ca #>
$script = "$PSScriptRoot\config.ps1"
. $script

$backupPath = "$($PenDrive.map):\$($PenDrive.backup)"
$caName = $Install.CACommonName
# todo : aia + serverdnsname

# maak backup folder
if (!(Test-Path -Path "$backupPath\initial")) {
  $folder = 'initial'
} else {
  $folder = Get-Date -Format "yyyyMMdd"
}
$backup = "$backupPath\$folder"
New-Item $backup -Type Directory -Force

# bewaar database, log, key-pair
try {
  Backup-CARoleService -Path $backup
  Write-Host "saved CA :" $caName -ForegroundColor Green
} catch {
  Write-Host "failed to save CA :" $caName $_ -ForegroundColor Red
}
