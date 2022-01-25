. .\User.ps1

Describe '[User]' {
  Context '[User]::new' {
      It 'create user guest' {
      { [User]::new([UserType]::guest) } | Should -Throw
    }

    It 'create user admin' {
      [User]::new([UserType]::admin).name | Should -BeOfType [UserType]
    }

    It 'create user resto' {
      [User]::new([UserType]::resto).name | Should -BeOfType [UserType]
    }

    It 'name of user admin should be "admin"' {
      [User]::new([UserType]::admin).name | Should -Be 'admin'
    }

    It 'name of user resto should be "resto"' {
      [User]::new([UserType]::resto).name | Should -Be 'resto'
    }
  }

  Context 'newPass()' {
    It 'password should be 16 characters long' {
      [User]::new([UserType]::admin).pass.Length | Should -Be 14
    }

    It 'each new password should be different' {
      [User]::new([UserType]::admin).pass | Should -Not -Be $user.newPass()
    }
  }

  Context 'addUser' {
    It 'user admin should be added to LocalUsers' {
      [User]::new([UserType]::admin)
      [User]::getUser([UserType]::admin) | Should -Not -BeNullOrEmpty
    }

    It 'user resto should be added to LocalUsers' {
      [User]::new([UserType]::resto)
      [User]::getUser([UserType]::resto) | Should -Not -BeNullOrEmpty
    }
  }

  Context 'joinGroup()' {
    It 'user admin should be added to group administrators' {
      [User]::new([UserType]::admin)
      [User]::getUser([UserType]::admin).group | Should -BeOfType [Administrators]
    }

    It 'user resto should be added to group administrators' {
      [User]::new([UserType]::resto)
      [User]::getUser([UserType]::resto).group | Should -BeOfType [Administrators]
    }
  }

  Context 'saveUser()' {
    It 'user admin should be saved in file admin.txt' {
      [User]::new([UserType]::admin)
      Test-Path "D:\dirUser\$($user.name).txt" | Should -Be $true
    }

    It 'user resto should not be saved in file resto.txt' {
      [User]::new([UserType]::resto)
      Test-Path "D:\dirUser\$($user.name).txt" | Should -Be $false
    }

    It 'admin.txt should contain {<user.name> <user.pass>}' {
      $user = [User]::new([UserType]::admin)
      $user.pass = 'abcdefg12345678!*'
      $user.saveUser
      Get-Content 'C:\rootca\admin.txt' | Should -Be 'admin abcdefg12345678!*'
    }
  }

  Context 'getUser()' {
    It 'LocalUser admin should exist' {
      [User]::getUser('admin') | Should -Not -BeNullOrEmpty
    }

    It 'LocalUser resto should exist' {
      [User]::getUser('resto') | Should -Not -BeNullOrEmpty
    }

    It 'LocalUser admin should be [UserType]' {
      [User]::getUser([UserType]::admin).name | Should -BeOfType [string]
    }

    It 'LocalUser admin name should be admin' {
      [User]::getUser([UserType]::admin).name | Should -BeOfType [string]
    }

    It 'getUser admin should be admin' {
      [User]::getUser([UserType]::admin).name | Should -Be 'admin'
    }

    It 'getUser admin should be admin' {[User]::getUser([UserType]::admin).pass | Should -BeOfType [string]
    }
  }

  Context 'dropUser()' {
    It 'dropUser admin should remove LocalUser admin' {
      [User]::new([UserType]::admin)
      [User]::getUser([UserType]::admin) | Should -Not -BeNullOrEmpty
      [User]::new([UserType]::admin)
      [User]::dropUser([UserType]::admin)
      [User]::getUser([UserType]::admin) | Should -BeNullOrEmpty
    }

    It 'dropUser resto should remove LocalUser resto' {
      [User]::getUser([UserType]::resto) | Should -Not -BeNullOrEmpty
      [User]::new([UserType]::resto)
      [User]::dropUser([UsertType]::resto)
      [User]::getUser([UserType]::resto) | Should -BeNullOrEmpty
    }

    It 'delete user admin should remove file admin.txt' {
      [User]::new([UserType]::admin)
      Test-Path "D:\dirUser\$($user.name).txt" | Should -Be $true
      [User]::dropUser('admin')
      Test-Path "D:\dirUser\$($user.name).txt" | Should -Be $false
    }
  }
}
