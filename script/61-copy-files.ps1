<# copy files #>
$script = "$PSScriptRoot\config.ps1"
. $script

$caName = $Install.CACommonName
# todo : aia + serverdnsname
$certPath = $CaDrive.certEnroll
$tempPath = $PawDrive.temp

# make folder temp
if (!(Test-Path $tempPath)) {
  New-Item $tempPath -Type Directory -Force
}

# copy crt,crl
Copy-Item "$certPath)\$caName.crt" $tempPath
Copy-Item "$certPath\$caName.crl" $tempPath
