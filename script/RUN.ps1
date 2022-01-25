<# RUNNER #>

[system.gc]::Collect()

<# set-up #>
. ./00-execution-policy.ps1
. ./10-map-drives.ps1

<# create users #>
. ./20-create-users.ps1
# . ./21-remove-user.ps1

<# install ca #>
. ./30-install-adcs-role.ps1
. ./40-copy-capolicy.ps1

<# configure ca #>
. ./51-configure-ca-aia-extensions.ps1
. ./52-configure-ca-cdp-extensions.ps1

<# backup ca #>
. ./60-backup-ca.ps1
. ./61-copy-files.ps1
