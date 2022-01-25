<# install Certificate Authority #>
$script = "$PSScriptRoot\config.ps1"
. $script

Copy-Item ".\CAPolicy.inf" "C:\Windows" -Force
