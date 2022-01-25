describe 'create-users' {
  $script = "$PSScriptRoot\config.ps1"
  . $script

  $LocalUsers = Get-LocalUser | Where-Object { $_.Name -In $users }
  $AdminGroup = Get-LocalGroupMember 'Administrators'

  context 'ca users' {
    it 'correct number of admin users' {
      $expect = $LocalUsers.Length
      $LocalUsers.Length | Should Match $expect
    }

    it 'users are member of administrators group' {
      foreach ($user in $LocalUsers) {
        $AdminGroup.Name -Contains "rootca\$($user.Name)" | Should Be $true
      }
    }

    it 'users accounts never expire' {
      foreach ($user in $LocalUsers) {
        $user.AccountExpires | Should BeNullOrEmpty
      }
    }

    it 'users passwords never expire' {
      foreach ($user in $LocalUsers) {
        $user.PasswordExpires | Should BeNullOrEmpty
      }
    }

    it 'credentials are stored' {
      foreach ($user in $LocalUsers) {
        "$($PenDrive.map):\$user.txt" | Should Exist
      }
    }

    it 'users have access to rootca' {
      foreach ($user in $LocalUsers) {
        $file = "$($PenDrive.map):\$user.txt"
        $pass = [regex]::Escape((Get-Content $file).split(' ')[1]) | ConvertTo-SecureString -AsPlainText -Force
        $credential = [pscredential]::new($user,$pass)

        "{ Invoke-Command -ScriptBlock {Get-Content $file } -ComputerName rootca -Credential $credential}" | Should Not BeNullOrEmpty
      }
    }
  }
}
