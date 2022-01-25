$app = "rootca"
$local = "\\$env:computername"
$remote = "\\tsclient"
if (Test-Path $local\d\$app) {
  Set-Location $local\d\$app
  Set-ExecutionPolicy -ExecutionPolicy Bypass
} elseif (Test-Path $remote\d\$app) {
  Set-Location $remote\d\$app
} elseif (Test-Path $remote\e\$app) {
  Set-Location $remote\e\$app
}

Set-Alias run .\Run
Set-Alias test .\Test

$env:UserName
$env:ComputerName
Get-Location
