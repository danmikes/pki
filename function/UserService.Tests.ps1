Describe '[UserService]' {
  Context 'newPass 14 2' {
    It 'password 16 characters; 14 ordinary, 2 special' {
      Should -Invoke -CommandName newPass -Times 1 -Exactly
      $pass1 = newPass 14 2
      $pass2 = newPass 14 2
      $pass1.length | should -be 16
      $pass1 | should -not -beNullOrEmpty
      $pass2 | should -not -beNullOrEmpty
      $pass1 | should -not -be $pass2
    }
  }

  Context 'newUser' {
    It 'create user admin' {
      Should -Invoke -CommandName newUser -Times 1 -Exactly
      $user0 = newUser 'user0' 'pass0'
      $user0 | should -BeNullOrEmpty

      $admin = newUser 'admin' 'ABCD1234EFG123*!'
      $admin | should -BeOfType [$Var = @{
        name = 'admin'
        pass = 'ABCD1234EFG123*!'
        AccountNeverExpires = $True
        PasswordNeverExpires = $True
        Group = 'Administrators'
        Verbose = $True
      }]
    }

    It 'create user resto' {
      $resto = newUser 'resto' '1234ABCD123EFG!*'
      $resto | should -BeOfType [$Var = @{
        name = 'resto'
        pass = '1234567ABCDEFG=-'
        AccountNeverExpires = $True
        PasswordNeverExpires = $True
        Group = 'Administrators'
        Verbose = $True
      }]
    }

    It 'create user admin2' {
      newUser 'admin' 'ABCDEFG1234567-='
      should -BeNullOrEmpty
    }

    It 'create user resto2' {
      newUser 'admin' '1234567ABCDEFG=-'
      should -BeNullOrEmpty
    }
  }

  Context 'addUser' {
    It '' {
      'Test-Path D:\rootca\dirUser\resto.txt' | should -BeNullOrEmpty
      'Test-Path D:\rootca\dirUser\resto.txt' | should -BeNullOrEmpty
      Get-LocalUser -Name 'admin' | should -BeNullOrEmpty
      Get-LocalUser -Name 'resto' | should -BeNullOrEmpty
    }

    It 'add user admin to LocalUsers' {
      newUser 'admin' '112233AABBCC12@#'
      $admin = Get-LocalUser 'admin'
      $admin.name | should -Be 'admin'
      $admin | should -BeOfType [LocalUsers]
      $admin | should -BeOfType [Administrators]
      $admin.AccountNeverExpires | should -BeTrue
      $admin.PasswordNeverExpires | should -BeTrue
    }

    It 'add user resto to LocalUsers' {
      newUser 'resto' '1234ABCD123EFG!*'
      $resto = Get-LocalUser 'admin' | should -BeOfType [LocalUsers]
      Get-LocalUser 'resto' | should -BeOfType [Adminstrators]
      $resto.name | should -Be 'resto'
      $admin.AccountNeverExpires | should -BeTrue
      $admin.PasswordNeverExpires | should -BeTrue
    }

    It 'save user admin to file admin.txt' {
      newUser 'admin' '112233AABBCC12@#'
      'C:\dirUser\admin.txt' | should -FileContentMatch 'admin 112233AABBCC12@#'
    }
  }
}

function _adduser() {

  newUser 'admin' 'ABCD1234EFG123*!'
  $admin = (Get-LocalUser -Name 'admin')
  true 'admin' $admin.name
  true $true 'Test-Path D:\rootca\dirUser\admin.txt'
  $file = ((Get-Content 'admin.txt').split( ))[0]
  true $file[0] $admin.name
  true $file[1] $admin.pass

  newUser 'resto' '1234ABCD123ABC!*'
  $resto = (Get-LocalUser -Name 'resto')
  true 'resto' $resto.name
  true $false 'Test-Path D:\rootca\dirUser\resto.txt'
}

function _dropUser() {

  userPresent -or makeUser
  true $true userPresent

  dropUser('admin')
  true $false usersAbsent
}

function _makeUser() {
  !userPresent -or dropUser
  true $false userPresent

  makeUser('admin')
  true $true userPresent
}

function userPresent() {
  true $true 'Test-Path D:\rootca\dirUser\resto.txt' -and
  false $null Get-LocalUser -Name 'admin' -and
  false $null Get-LocalUser -Name 'resto'
}
