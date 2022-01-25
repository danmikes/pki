<# User #>

function newPass([Int]$length, [Int]$special) {
  Add-Type -AssemblyName 'System.Web'
  [System.Web.Security.Membership]::GeneratePassword($length, $special)
}

function makeUser() {
  adduser
  copyProfile
  getUser
}

function newUser($name,$pass) {
  if ($name -in $names) {
    return @{
      name = $name
      pass = $pass
      AccountNeverExpires = $True
      PasswordNeverExpires = $True
      Group = 'Administrators'
      Verbose = $True
    }
  }
  return $null
}

function adduser() {
  forEach ($name in $names) {
    $user = newUser $name newPass 14 2
    try {
      New-LocalUser $user -Force
      if ($user.name -eq 'admin') {
        $user.name + " " + $user.pass | out-file -filepath "$pathUser\$name.txt"
      }
    } catch { Write-Host "failed to create user $name" -ForegroundColor Red }
  }
}

function getUser() {
  forEach ($name in $names) {
    try {
      Get-LocalUser -Name $name | Select-Object *
    } catch { Write-Host "failed to show user $name" -ForegroundColor Red }
  }
}

function dropUser() {
  forEach ($name in $names) {
    $path = "$pathUser\$name.txt"
    try {
      Remove-LocalUser -Name $name
      if ($name -eq 'admin') {
        Remove-Item $path
      }
    } catch { Write-Host "failed to delete user $name" -ForegroundColor Red }
  }
}
