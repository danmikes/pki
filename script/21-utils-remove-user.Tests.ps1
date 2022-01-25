describe 'utils-remove-user' {
  $script = "$PSScriptRoot\config.ps1"
  . $script

  $LocalUsers = Get-LocalUser

  context 'remove temp user' {
    it 'correct number of admin users' {
      (Get-LocalUser).Length | Should Match $LocalUsers.Length
    }

    it 'tempuser is removed' {
      Get-LocalUser $TempUser | Should BeNullOrEmpty
    }
  }
}
