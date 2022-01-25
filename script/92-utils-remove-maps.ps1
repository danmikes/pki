<# remove drive map #>
$script = "$PSScriptRoot\config.ps1"
. $script

# remove mapped network drives
net use * /del /yes
