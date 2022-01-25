<# create users admin & resto #>
$script = "$PSScriptRoot\config.ps1"
. $script

# createUsers
foreach ($user in $Users) {
  try {
    # generate password
    Add-Type -AssemblyName 'System.Web'
    $pass = [System.Web.Security.Membership]::GeneratePassword(14,2) | ConvertTo-SecureString -AsPlainText -Force

    # add user
    New-LocalUser -Name $user -Password $pass -AccountNeverExpires -PasswordNeverExpires

    # join administrators group
    Add-LocalGroupMember -Group 'Administrators' -Member $user

    # save credentials
    $string = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))
    $file = "$($PenDrive.map):\$user.txt"
    "$user $string" | out-file -FilePath $file
    Write-Host "added users" -ForegroundColor Green
  }
  catch {
    Write-Host "failed to add" $_ -ForegroundColor Red
  }
}

# display user credentials
Add-Type -AssemblyName PresentationCore,PresentationFramework
$ButtonType = [System.Windows.MessageBoxButton]::OK
$BoxTitle = "new users"
$admin = Get-Content "$($PenDrive.map):\admin.txt"
$resto = Get-Content "$($PenDrive.map):\resto.txt"
$BoxText = "$admin`r`n$resto"
$BoxIcon = [System.Windows.MessageBoxImage]::Information
[System.Windows.MessageBox]::Show($BoxText,$BoxTitle,$ButtonType,$BoxIcon)
