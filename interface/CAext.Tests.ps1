Describe '[CAExt]' {
  Context 'deleteCAAuthorityInformationAccess()' {
    It 'delete AIA' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [CAExt]::getAIA($env) | Should -Not -BeNullOrEmpty
      [CAExt]::deleteCAAuthorityInformationAccess($env)
      [CAExt]::getAIA($env) | Should -BeNullOrEmpty
    }
  }

  Context 'deleteCACRLDistributionPoint()' {
    It 'delete CDP' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [CAExt]::getAIA($env) | Should -Not -BeNullOrEmpty
      [CAExt]::deleteCACRLDistributionPoint($env)
      [CAExt]::getAIA($env) | Should -BeNullOrEmpty
    }
  }

  Context 'addCAAuthorityInformationAccess()' {
    It 'object type [CAAuthorityInformationAccess]' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [CAExt]::addCAAuthorityInformationAccess($env)
      [CAExt]::getAIA($env) | Should -BeOfType [CAAuthorityInformationAccess]
    }

    It 'crt Uri' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CAAuthorityInformationAccess
      [CAExt]::addCAAuthorityInformationAccess($env)
      [CAExt]::getAIA($env)[0].Uri | Should -Be $ca.CAAuthorityInformationAccess.crt.Uri
    }

    It 'crt AddToCertificateAia' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CAAuthorityInformationAccess
      [CAExt]::addCAAuthorityInformationAccess($env)
      [CAExt]::getAIA($env)[0].AddToCertificateAia | Should -Be $ca.CAAuthorityInformationAccess.crt.AddToCertificateAia
    }

    It 'pem Uri' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CAAuthorityInformationAccess
      [CAExt]::addCAAuthorityInformationAccess($env)
      [CAExt]::getAIA($env)[1].Uri | Should -Be $ca.CAAuthorityInformationAccess.pem.Uri
    }

    It 'pem AddToCertificateAia' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CAAuthorityInformationAccess
      [CAExt]::addCAAuthorityInformationAccess($env)
      [CAExt]::getAIA($env)[1].AddToCertificateAia | Should -Be $ca.CAAuthorityInformationAccess.pem.AddToCertificateAia
    }

    It 'crl Uri' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CAAuthorityInformationAccess
      [CAExt]::addCAAuthorityInformationAccess($env)
      [CAExt]::getAIA($env)[2].Uri | Should -Be $ca.CAAuthorityInformationAccess.crl.Uri
    }

    It 'crl AddToCertificateAia' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CAAuthorityInformationAccess
      [CAExt]::addCAAuthorityInformationAccess($env)
      [CAExt]::getAIA($env)[2].AddToCertificateAia | Should -Be $ca.CAAuthorityInformationAccess.crt.AddToCertificateAia
    }

    It 'ldap Uri' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CAAuthorityInformationAccess
      [CAExt]::addCAAuthorityInformationAccess($env)
      [CAExt]::getAIA($env)[3].Uri | Should -Be $ca.CAAuthorityInformationAccess.ldap.Uri
    }

    It 'ldap AddToCertificateAia' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CAAuthorityInformationAccess
      [CAExt]::addCAAuthorityInformationAccess($env)
      [CAExt]::getAIA($env)[3].AddToCertificateAia | Should -Be $ca.CAAuthorityInformationAccess.crt.AddToCertificateAia
    }
  }

  Context 'addCACRLDistributionPoint()' {
    It 'add CDP' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env) | Should -BeOfType [CACRLDistributionPoint]
    }

    It 'crt Uri' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[0].Uri | Should -Be $ca.CACRLDistributionPoint.crt.Uri
    }

    It 'crt PublishToServer' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[0].PublishToServer | Should -Be $ca.CACRLDistributionPoint.crt.PublishToServer
    }

    It 'crt PublishToDeltaServer' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[0].PublishToDeltaServer | Should -Be $ca.CACRLDistributionPoint.crt.PublishToDeltaServer
    }

    It 'crt AddToCertificateCdp' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[0].AddTocertificateCdp | Should -Be $ca.CACRLDistributionPoint.crt.AddToCertificateCdp
    }

    It 'crt AddToFreshestCrl' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getcdp($env)[0].AddToFreshestCrl | Should -Be $ca.CACRLDistributionPoint.crt.AddToFreshestCrl
    }

    It 'crt AddToCrlCdp' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[0].AddToCrlCdp | Should -Be $ca.CACRLDistributionPoint.crt.AddToCrlCdp
    }

    It 'crt AddToCrlIdp' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[0].AddToCrlIdp | Should -Be $ca.CACRLDistributionPoint.crt.AddToCrlIdp
    }

    It 'pem Uri' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[1].Uri | Should -Be $ca.CACRLDistributionPoint.crt.Uri
    }

    It 'pem PublishToServer' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[1].PublishToServer | Should -Be $ca.CACRLDistributionPoint.crt.PublishToServer
    }

    It 'pem PublishToDeltaServer' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[1].PublishToDeltaServer | Should -Be $ca.CACRLDistributionPoint.crt.PublishToDeltaServer
    }

    It 'pem AddToCertificateCdp' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[1].AddTocertificateCdp | Should -Be $ca.CACRLDistributionPoint.crt.AddToCertificateCdp
    }

    It 'pem AddToFreshestCrl' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[1].AddToFreshestCrl | Should -Be $ca.CACRLDistributionPoint.crt.AddToFreshestCrl
    }

    It 'pem AddToCrlCdp' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[1].AddToCrlCdp | Should -Be $ca.CACRLDistributionPoint.crt.AddToCrlCdp
    }

    It 'pem AddToCrlIdp' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[1].AddToCrlIdp | Should -Be $ca.CACRLDistributionPoint.crt.AddToCrlIdp
    }

    It 'crl Uri' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[2].Uri | Should -Be $ca.CACRLDistributionPoint.crt.Uri
    }

    It 'crl PublishToServer' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[2].PublishToServer | Should -Be $ca.CACRLDistributionPoint.crt.PublishToServer
    }

    It 'crl PublishToDeltaServer' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[2].PublishToDeltaServer | Should -Be $ca.CACRLDistributionPoint.crt.PublishToDeltaServer
    }

    It 'crl AddToCertificateCdp' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[2].AddTocertificateCdp | Should -Be $ca.CACRLDistributionPoint.crt.AddToCertificateCdp
    }

    It 'crl AddToFreshestCrl' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[2].AddToFreshestCrl | Should -Be $ca.CACRLDistributionPoint.crt.AddToFreshestCrl
    }

    It 'crl AddToCrlCdp' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[2].AddToCrlCdp | Should -Be $ca.CACRLDistributionPoint.crt.AddToCrlCdp
    }

    It 'crl AddToCrlIdp' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[2].AddToCrlIdp | Should -Be $ca.CACRLDistributionPoint.crt.AddToCrlIdp
    }

    It 'ldap Uri' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[3].Uri | Should -Be $ca.CACRLDistributionPoint.crt.Uri
    }

    It 'ldap PublishToServer' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[3].PublishToServer | Should -Be $ca.CACRLDistributionPoint.crt.PublishToServer
    }

    It 'ldap PublishToDeltaServer' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[3].PublishToDeltaServer | Should -Be $ca.CACRLDistributionPoint.crt.PublishToDeltaServer
    }

    It 'ldap AddToCertificateCdp' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[3].AddTocertificateCdp | Should -Be $ca.CACRLDistributionPoint.crt.AddToCertificateCdp
    }

    It 'ldap AddToFreshestCrl' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[3].AddToFreshestCrl | Should -Be $ca.CACRLDistributionPoint.crt.AddToFreshestCrl
    }

    It 'ldap AddToCrlCdp' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[3].AddToCrlCdp | Should -Be $ca.CACRLDistributionPoint.crt.AddToCrlCdp
    }

    It 'ldap CDP' {
      [Env] $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      [HashTable] $ca = $env.CAext.CACRLDistributionPoint
      [CAExt]::addCACRLDistributionPoint($env)
      [CAExt]::getCDP($env)[3].AddToCrlIdp | Should -Be $ca.CACRLDistributionPoint.crt.AddToCrlIdp
    }
  }
}
