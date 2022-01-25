. .\User.ps1
# Import-Module '.\User.ps1' -Force -PassThru -Verbose

Describe '[User]' {
  Context 'newPass()' {
    It 'password should be 16 characters long' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [Users] $user = $env.user.admin
      [User]::addUser($env, $user).pass.Length | Should -Be 14
    }

    It 'each new password should be different' {
      $pass1 = [Env]::new([Envs]::azure, [CAs]::rootca).user.admin.password
      $pass2 = [Env]::new([Envs]::azure, [CAs]::rootca).user.admin.password
      $pass2 | Should -Not -Be $pass1
    }
  }

  Context 'addUser' {
    It 'user admin should be added to LocalUsers' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [Users] $user = $env.user.admin
      [User]::addUser($env, $user) | Should -Not -BeNullOrEmpty
    }

    It 'user resto should be added to LocalUsers' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [Users] $user = $env.user.resto
      [User]::addUser($env, $user) | Should -Not -BeNullOrEmpty
    }
  }

  Context 'joinGroup()' {
    It 'user admin should be added to group administrators' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [Users] $user = $env.user.admin
      [User]::addUser($env, $user).group
      [User]::getUser($env, $user).group | Should -BeOfType [Administrators]
    }

    It 'user resto should be added to group administrators' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [Users] $user = $env.user.resto
      [User]::addUser($env, $user).group
      [User]::getUser($env, $user).group | Should -BeOfType [Administrators]
    }
  }

  Context 'saveUser()' {
    It 'user admin should be saved in file admin.txt' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [Users] $user = $env.user.admin
      [User]::addUser($env, $user).group
      "$($dirUser)\$($user.name).txt" | Should -Exist
    }

    It 'user resto should not be saved in file resto.txt' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [Users] $user = $env.user.resto
      [User]::addUser($env, $user).group
      "$($dirUser)\$($user.name).txt" | Should -Not -Exist
    }
  }

  Context 'getUser()' {
    It 'LocalUser admin should exist' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [Users] $user = $env.user.admin
      [User]::addUser($env, $user)
      [User]::getUser($env, $user) | Should -Not -BeNullOrEmpty
    }

    It 'LocalUser resto should exist' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [Users] $user = $env.user.resto
      [User]::addUser($env, $user)
      [User]::getUser($env, $user) | Should -Not -BeNullOrEmpty
    }

    It 'LocalUser admin should be of type [LocalUser]' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [Users] $user = $env.user.admin
      [User]::addUser($env, $user)
      [User]::getUser($env, $user) | Should -BeOfType [LocalUser]
   }

    It 'LocalUser admin.name should be of type [string]' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [Users] $user = $env.user.admin
      [User]::addUser($env, $user)
      [User]::getUser($env, $user).name | Should -BeOfType [string]
    }

    It 'getUser admin.name should be admin' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [Users] $user = $env.user.admin
      [User]::addUser($env, $user)
      [User]::getUser($env, $user).name | Should -Be 'admin'
    }

    It 'LocalUser admin.name should be of type [string]' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [Users] $user = $env.user.admin
      [User]::addUser($env, $user)
      [User]::getUser($env, $user).pass | Should -BeOfType [string]
    }
  }

  Context 'showUser()' {
    It 'showUser should display admin credentials (username password)' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [Users] $user = $env.user.admin
      [User]::showUser($env, $user) | Should -BeOfType [string]
    }

    It 'first word in admin.txt should be admin username' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [Users] $user = $env.user.admin
      [User]::showUser($env, $user).split(' ')[0] | Should -Be 'admin'
    }

    It 'second word in admin.txt have 16 characters' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [Users] $user = $env.user.admin
      [User]::showUser($env, $user).split(' ')[1].length | Should -Be 16
    }
  }

  Context 'deleteUser()' {
    It 'deleteUser admin should remove LocalUser admin' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [Users] $user = $env.user.admin
      [User]::getUser($env, $user) | Should -Not -BeNullOrEmpty
      [User]::deleteUser($env, $user)
      [User]::getUser($env, $user) | Should -BeNullOrEmpty
    }

    It 'deleteUser resto should remove LocalUser resto' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [Users] $user = $env.user.resto
      [User]::getUser($env, $user) | Should -Not -BeNullOrEmpty
      [User]::deleteUser($env, $user)
      [User]::getUser($env, $user) | Should -BeNullOrEmpty
    }

    It 'deleteUser admin should remove file admin.txt' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [Users] $user = $env.user.admin
      "$($dirUser)\$($user.name).txt" | Should -Exist
      [User]::deleteUser($env, $user)
      "$($dirUser)\$($user.name).txt" | Should -Not -Exist
    }
  }
}
