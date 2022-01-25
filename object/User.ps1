enum UserType {
  admin
  resto
}

class User {
  [UserType] $name
  [string] $pass
  [bool] $AccountNeverExpires = $true
  [bool] $PasswordNeverExpires = $true
  [string] $Group = 'Administrators'
  [bool] $Verbose = $true

  User([UserType] $name) {
    $this.name = $name
    $this.newPass()
    if ($name -eq [UserType]::admin) {
      $this.saveUser
    }
    $this.addUser
    $this.joinGroup
  }

  [void] newPass() {
    $length = 14
    $special = 2
    Add-Type -AssemblyName 'System.Web'
    $this.pass = [System.Web.Security.Membership]::GeneratePassword($length, $special)
  }

  [void] addUser() {
    New-LocalUser -Name $this.name -AccountNeverExpires -PasswordNeverExpires -Password $this.pass -Force
  }

  [void] joinGroup() {
    Add-LocalGroupMember -Group $this.Group -Member $this.name
  }

  [void] saveUser() {
    "$($this.name) $($this.pass)" | out-file -FilePath "D:\dirUser\$($this.name).txt"
  }

  static [User] getUser([UserType] $name) {
    return Get-LocalUser -Name $name
  }

  static [void] getFile() {
    Get-Content "D:\dirUser\admin.txt"
  }

  static [void] deleteUser([UserType] $name) {
    $user = getUser $name
    if (($null -eq $user.file.path) -and (Test-Path $user.file.path)) {
      Remove-LocalUser -Name $name 
      Remove-Item $user.file
    }
  }
}

$user1 = [User]::new([UserType]::admin)
$user1
$user1.name
[User]::getUser([UserType]::admin)

$user2 = [User]::new([UserType]::resto)
$user2
$user2.name
[User]::getUser([UserType]::resto)
