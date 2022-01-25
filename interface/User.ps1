<# INTERFACE #>
class User {
  static [void] addUser([Env] $env, [Users] $user) {
    $user = $env.user.$user
    try {
      New-LocalUser -Name $user.name -AccountNeverExpires $user.AccountNeverExpires -PasswordNeverExpires $user.PasswordNeverExpires -Password $user.pass -Force
      Write-Host "added user : $($user.name)"
    } catch {
      Write-Host "failed to add user : $($user.name)"
    }
  }

  static [void] joinGroup([Env] $env, [Users] $user) {
    $user = $env.user.$user
    try {
      Write-Host "added user to Group: $($user.name)"
    } catch {
      Write-Host "failed to add user to Group : $($user.name)"
    }
    Add-LocalGroupMember -Group $user.Group -Member $user.name
  }

  static [void] saveUser([Env] $env, [Users] $user) {
    $user = $env.user.$user
    $dir = $env.dir.dirUser
    try {
      "$($user.name) $($user.pass)" | out-file -FilePath "$dir\$($user.name).txt"
      Write-Host "saved user: $user.name"
    } catch {
      Write-Host "failed to save user: $($user.name)"
    }
  }

  static [void] getUser([Env] $env, [Users] $user) {
    $user = $env.user.$user
    try {
      Get-LocalUser -Name $user
      Write-Host "retrieved user: $($user.name)"
    } catch {
      Write-Host "failed to retrieve user: $($user.name)"
    }
  }

  # TODO : remove or modify ?
  static [void] getAdminCredentials() {
    $user = [Users]::admin
    try {
      Get-Content $user.File
      Write-Host "displayed user : $($user.name)"
    } catch {
      Write-Host "failed to display user : $($user.name)"
    }
  }

  static [void] deleteUser([Env] $env, [Users] $user) {
    $user = $env.user.$user
    try {
      if (($null -eq $user.File) -and (Test-Path $user.File)) {
        Remove-LocalUser -Name $user
        Remove-Item $user.file.path
        Write-Host "deleted user : $($user.name)"
      }
    } catch {
      Write-Host "failed to delete user : $($user.name)"
    }
  }
}
