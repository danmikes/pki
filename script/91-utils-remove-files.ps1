<# remove files #>
$script = "$PSScriptRoot\config.ps1"
. $script

# remove crt,crl
Remove-Item $CaDrive.certEnroll -Recurse -Force
Remove-Item $CaDrive.certLog -Recurse -Force
Remove-Item $PenDrive.backup -Recurse -Force
Remove-Item $PawDrive.temp -Recurse -Force
