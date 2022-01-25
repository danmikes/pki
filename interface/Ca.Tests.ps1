Describe '[CA]' {
  Context '[CA]::createCA()' {
    It 'createCA() on dev' {
      [Env] $env = [Env]::new([Envs]::dev, [CAs]::rootca)
      [CA]::createCA($env) | Should -Throw
      [CA]::getCA($env) | Should -BeNullOrEmpty
    }

    It 'createCA() on azure' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [CA]::createCA($env)
      [CA]::getCA($env) | Should -BeOfType [CertificationAuthority]
    }

    It 'createCA() on local' {
      [Env] $env = [Env]::new([Envs]::local, [CAs]::rootca)
      [CA]::createCA($env)
      [CA]::getCA($env) | Should -BeOfType [CertificationAuthority]
    }

    It 'createCA() on npo' {
      [Env] $env = [Env]::new([Envs]::npo, [CAs]::rootca)
      [CA]::createCA($env)
      [CA]::getCA($env) | Should -BeOfType [CertificationAuthority]
    }

    It 'createCA() on prd' {
      [Env] $env = [Env]::new([Envs]::prd, [CAs]::rootca)
      [CA]::createCA($env)
      [CA]::getCA($env) | Should -BeOfType [CertificationAuthority]
    }

    It 'createCA() on tst' {
      [Env] $env = [Env]::new([Envs]::tst, [CAs]::rootca)
      [CA]::createCA($env)
      [CA]::getCA($env) | Should -BeOfType [CertificationAuthority]
    }

    It 'createCA() on dev' {
      [Env] $env = [Env]::new([Envs]::dev, [CAs]::winca)
      [CA]::createCA($env) | Should -Throw
      [CA]::getCA($env) | Should -BeNullOrEmpty
    }

    It 'createCA() on azure' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::winca)
      [CA]::createCA($env)
      [CA]::getCA($env) | Should -BeOfType [CertificationAuthority]
    }

    It 'createCA() on local' {
      [Env] $env = [Env]::new([Envs]::local, [CAs]::winca)
      [CA]::createCA($env)
      [CA]::getCA($env) | Should -BeOfType [CertificationAuthority]
    }

    It 'createCA() on npo' {
      [Env] $env = [Env]::new([Envs]::npo, [CAs]::winca)
      [CA]::createCA($env)
      [CA]::getCA($env) | Should -BeOfType [CertificationAuthority]
    }

    It 'createCA() on prd' {
      [Env] $env = [Env]::new([Envs]::prd, [CAs]::winca)
      [CA]::createCA($env)
      [CA]::getCA($env) | Should -BeOfType [CertificationAuthority]
    }

    It 'createCA() on tst' {
      [Env] $env = [Env]::new([Envs]::tst, [CAs]::winca)
      [CA]::createCA($env)
      [CA]::getCA($env) | Should -BeOfType [CertificationAuthority]
    }
  }

  Context '[CA]::createCA() on azure' {
    It 'AllowAdministratorInteraction' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAmain
      [CA]::createCA($env)
      [CA]::getCA($env).AllowAdministratorInteraction | Should -Be $ca.AllowAdministratorInteraction
    }

    It 'CACommonName' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAmain
      [CA]::createCA($env) | Should -Throw
      [CA]::getCA($env).CACommonName | Should -Be $ca.CACommonName
    }

    It 'CADistinguishedNameSuffix' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAmain
      [CA]::createCA($env)
      [CA]::getCA($env).CADistinguishedNameSuffix | Should -Be $ca.CADistinguishedNameSuffix
    }

    It 'CAType' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAmain
      [CA]::createCA($env)
      [CA]::getCA($env).CAType | Should -Be $ca.CAType
    }

    It 'DatabaseDirectory' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAmain
      [CA]::createCA($env)
      [CA]::getCA($env).DatabaseDirectory | Should -Be $ca.DatabaseDirectory
    }

    It 'LogDirectory' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAmain
      [CA]::createCA($env)
      [CA]::getCA($env).LogDirectory | Should -Be $ca.LogDirectory
    }

    It 'OverwriteExistingDatabase' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAmain
      [CA]::createCA($env)
      [CA]::getCA($env).OverwriteExistingDatabase | Should -Be $ca.OverwriteExistingDatabase
    }

    It 'OverwriteExistingCAinDS' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAmain
      [CA]::createCA($env)
      [CA]::getCA($env).OverwriteExistingCAinDS | Should -Be $ca.OverwriteExistingCAinDS
    }

    It 'ValidityPeriod' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAmain
      [CA]::createCA($env)
      [CA]::getCA($env).ValidityPeriod | Should -Be $ca.ValidityPeriod
    }

    It 'ValidityPeriodUnits' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAmain
      [CA]::createCA($env)
      [CA]::getCA($env).ValidityPeriodUnits | Should -Be $ca.ValidityPeriodUnits
    }
  }

  Context '[CA]::publishCA()' {
    [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
    [string] $dir = $env.dir.dirCrt
    [string] $ca = $env.CAmain.CACommonName
    [CA]::publishCA($env)
    "$($dir)\$($ca).crt" | Should -Exist
  }

  Context '[CA]::checkCA()' {
    It 'check AIA' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAmain.uri
      [CA]::checkCA($env)
      Invoke-WebRequest $ca.urlAia | Should -Not -BeNullOrEmpty
    }

    It 'check CDP' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAmain.uri
      [CA]::checkCA($env)
      Invoke-WebRequest $ca.urlCdp | Should -Not -BeNullOrEmpty
    }
  }

  Context '[CA]::backupCA()' {
    It 'backup folder should exist' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [string] $dir = $env.dir.dirBackup
      [CA]::backupCA($env)
      "$($dir)\*" | Should -Exist
    }

    It 'backup folder should not be empty' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [string] $dir = $env.dir.dirBackup
      [CA]::backupCA($env)
      "$($dir)\*" | Should -Not -BeNullOrEmpty
    }
  }

  Context '[CA]::restoreCA()' {
    It 'CA should reappear' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [CA]::restoreCA($env)
      [CA]::getCA($env) | Should -BeOfType [CertificationAuthority]
    }
  }

  Context '[CA]::deleteCA()' {
    It 'CA should disappear' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [CA]::getCA($env) | Should -Not -BeNullOrEmpty
      [CA]::deleteCA($env)
      [CA]::getCA($env) | Should -BeNullOrEmpty
    }
  }

  Context '[CA]::[CA]::getCA()' {
    It 'createCA() on dev' {
      [Env] $env = [Env]::new([Envs]::dev, [CAs]::rootca)
      [CA]::getCA($env) | Should -BeNullOrEmpty
      [CA]::createCA($env) | Should -Throw
      [CA]::getCA | Should -BeOfType [CertificationAuthority]
    }
  }
}
