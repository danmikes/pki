Describe '[Env]' {
  Context '[Env]::new' {
    It 'create env dev null' {
      { [Env]::new([Envs]::dev) } | Should -Throw
    }

    It 'create env null rootca' {
      { [Env]::new([Envs]::dev) } | Should -Throw
    }

    It 'create env azure rootca' {
      [Env]::new([Envs]::azure, [CAs]::rootca) | Should -BeOfType [Env]
    }

    It 'create env local rootca' {
      [Env]::new([Envs]::local, [CAs]::rootca) | Should -BeOfType [Env]
    }

    It 'create env npo rootca' {
      [Env]::new([Envs]::npo, [CAs]::rootca) | Should -BeOfType [Env]
    }

    It 'create env prd rootca' {
      [Env]::new([Envs]::prd, [CAs]::rootca) | Should -BeOfType [Env]
    }

    It 'create env tst rootca' {
      [Env]::new([Envs]::tst, [CAs]::rootca) | Should -BeOfType [Env]
    }

    It 'create env azure winca' {
      { [Env]::new([Envs]::azure, [CAs]::winca) } | Should -BeOfType [Env]
    }

    It 'create env local winca' {
      [Env]::new([Envs]::local, [CAs]::winca) | Should -BeOfType [Env]
    }

    It 'create env npo winca' {
      [Env]::new([Envs]::npo, [CAs]::winca) | Should -BeOfType [Env]
    }

    It 'create env prd winca' {
      [Env]::new([Envs]::prd, [CAs]::winca) | Should -BeOfType [Env]
    }

    It 'create env tst winca' {
      [Env]::new([Envs]::tst, [CAs]::winca) | Should -BeOfType [Env]
    }
  }

  Context 'setUri()' {
    It 'setUri to dev' {
      $env = [Env]::new([Envs]::dev).setUri
      $env.uri.uriAia | Should -BeNullOrEmpty
    }

    It 'setUri to azure' {
      $env = [Env]::new([Envs]::azure, [CAs]::rootca)
      $env.uri.uriAia | Should -Be "10.0.0.0\pki\AIA"
      $env.uri.uriCdp | Should -Be "10.0.0.0\pki\CDP"
      $env.uri.uriLdap | Should -Be "10.0.0.0\pki\ldap"
      $env.uri.urlAia | Should -Be "http://pki-azure.io/pki/AIA"
      $env.uri.uriCdp | Should -Be "http://pki-azure.io/pki/CDP"
      $env.uri.urlOcsp | Should -Be "http://pki-azure.io/pki/OCSP"
    }

    It 'setUri to local' {
      $env = [Env]::new([Envs]::local, [CAs]::rootca)
      $env.uri.uriAia | Should -Be ''
      $env.uri.uriCdp | Should -BeNullOrEmpty
      $env.uri.uriLdap | Should -BeNullOrEmpty
      $env.uri.urlAia | Should -BeNullOrEmpty
      $env.uri.uriCdp | Should -BeNullOrEmpty
      $env.uri.urlOcsp | Should -BeNullOrEmpty
    }

    It 'setUri to npo' {
      $env = [Env]::new([Envs]::npo, [CAs]::rootca)
      $env.uri.uriAia | Should -Be "\\npo01\D`$\CertEnroll\AIA"
      $env.uri.uriCdp | Should -Be "\\npo01\D`$\CertEnroll\CDP"
      $env.uri.uriLdap | Should -Be "\\npo01\D`$\CertEnroll\ldap"
      $env.uri.urlAia | Should -Be "http://pki-npo.io/pki/AIA"
      $env.uri.uriCdp | Should -Be "http://pki-npo.io/pki/CDP"
      $env.uri.urlOcsp | Should -Be "http://pki-npo.io/pki/OCSP"
    }

    It 'setUri to prd' {
      $env = [Env]::new([Envs]::prd, [CAs]::rootca)
      $env.uri.uriAia | Should -Be "\\prd01\D`$\CertEnroll\AIA"
      $env.uri.uriCdp | Should -Be "\\prd01\D`$\CertEnroll\CDP"
      $env.uri.uriLdap | Should -Be "\\prd01\D`$\CertEnroll\ldap"
      $env.uri.urlAia | Should -Be "http://pki-prd.io/pki/AIA"
      $env.uri.uriCdp | Should -Be "http://pki-prd.io/pki/CDP"
      $env.uri.urlOcsp | Should -Be "http://pki-prd.io/pki/OCSP"
    }

    It 'setUri to tst' {
      $env = [Env]::new([Envs]::tst, [CAs]::rootca)
      $env.uri.uriAia | Should -Be "\\tst01\D`$\CertEnroll\AIA"
      $env.uri.uriCdp | Should -Be "\\tst01\D`$\CertEnroll\CDP"
      $env.uri.uriLdap | Should -Be "\\tst01\D`$\CertEnroll\ldap"
      $env.uri.urlAia | Should -Be "http://pki-tst.io/pki/AIA"
      $env.uri.uriCdp | Should -Be "http://pki-tst.io/pki/CDP"
      $env.uri.urlOcsp | Should -Be "http://pki-tst.io/pki/OCSP"
    }
  }

  Context 'setCAmain()' {
    It 'install rootca on dev' {
      $ca = [Env]::new([Envs]::dev, [CAs]::rootca).CAMain
      $ca.CAs | Should -BeNullOrEmpty
      $ca.DatabaseDirectory | Should -BeNullOrEmpty
      $ca.LogDirectory | Should -BeNullOrEmpty
      $ca.OverwriteExistingCAinDS | Should -BeNullOrEmpty
      $ca.OverwriteExistingDatabase | Should -BeNullOrEmpty
      $ca.OverwriteExistingKey | Should -BeNullOrEmpty
      $ca.ValidityPeriod | Should -BeNullOrEmpty
      $ca.ValidityPeriodUnits | Should -BeNullOrEmpty
    }

    It 'install rootca on azure' {
      $ca = [Env]::new([Envs]::azure, [CAs]::rootca).CAMain
      $ca.CAs | Should -Be 'StandAlone'
      $ca.DatabaseDirectory | Should -Be ''
      $ca.LogDirectory | Should -Be ''
      $ca.OverwriteExistingCAinDS | Should -Be $true
      $ca.OverwriteExistingDatabase | Should -Be $true
      $ca.OverwriteExistingKey | Should -Be $true
      $ca.ValidityPeriod | Should -Be 20
      $ca.ValidityPeriodUnits | Should -Be 'Years'
    }

    It 'install rootca on local' {
      $ca = [Env]::new([Envs]::local, [CAs]::rootca).CAMain
      $ca.CAs | Should -Be 'StandAlone'
      $ca.DatabaseDirectory | Should -Be ''
      $ca.LogDirectory | Should -Be ''
      $ca.OverwriteExistingCAinDS | Should -Be $true
      $ca.OverwriteExistingDatabase | Should -Be $true
      $ca.OverwriteExistingKey | Should -Be $true
      $ca.ValidityPeriod | Should -Be 20
      $ca.ValidityPeriodUnits | Should -Be 'Years'
    }

    It 'install rootca on npo' {
      $ca = [Env]::new([Envs]::npo, [CAs]::rootca).CAmain
      $ca.CAs | Should -Be 'StandAlone'
      $ca.DatabaseDirectory | Should -Be ''
      $ca.LogDirectory | Should -Be ''
      $ca.OverwriteExistingCAinDS | Should -Be $true
      $ca.OverwriteExistingDatabase | Should -Be $true
      $ca.OverwriteExistingKey | Should -Be $true
      $ca.ValidityPeriod | Should -Be 20
      $ca.ValidityPeriodUnits | Should -Be 'Years'
    }

    It 'install rootca on prd' {
      $ca = [Env]::new([Envs]::prd, [CAs]::rootca).CAmain
      $ca.CAs | Should -Be 'StandAlone'
      $ca.DatabaseDirectory | Should -Be ''
      $ca.LogDirectory | Should -Be ''
      $ca.OverwriteExistingCAinDS | Should -Be $true
      $ca.OverwriteExistingDatabase | Should -Be $true
      $ca.OverwriteExistingKey | Should -Be $true
      $ca.ValidityPeriod | Should -Be 20
      $ca.ValidityPeriodUnits | Should -Be 'Years'
    }

    It 'install rootca on tst' {
      $ca = [Env]::new([Envs]::tst, [CAs]::rootca).CAmain
      $ca.CAs | Should -Be 'StandAlone'
      $ca.DatabaseDirectory | Should -Be ''
      $ca.LogDirectory | Should -Be ''
      $ca.OverwriteExistingCAinDS | Should -Be $true
      $ca.OverwriteExistingDatabase | Should -Be $true
      $ca.OverwriteExistingKey | Should -Be $true
      $ca.ValidityPeriod | Should -Be 20
      $ca.ValidityPeriodUnits | Should -Be 'Years'
    }
  }

  # Context 'setCAmain()' {
  #   It 'x' {
  #   }
  # }

  Context 'setCADistinguishedNameSuffix()' {
    It 'setCADistinguishedNameSuffix for rootca on azure' {
      $ca = [Env]::new([Envs]::azure, [CAs]::rootca).CAmain
      $ca.CADistinguishedNameSuffix | Should -Be 'O=Org,L=City,S=Area,C=IO,OU=Team,OU=www.pki-azure.io,Title=pki,CN=rootca-azure,CN=Configuration,DC=win,DC=org,DC=io'
    }
  }

  Context 'getDNS()' {
    It 'getDNS for rootca on azure' {
      $dns = [Env]::new([Envs]::azure, [CAs]::rootca).getDNS()
        $dns.O | Should -Be 'Org'
        $dns.L | Should -Be 'City'
        $dns.S | Should -Be 'Area'
        $dns.C | Should -Be 'IO'
        $dns.OU | Should -Be 'Team','www.pki-<CACommonName>-<environment>.io'
        $dns.Title | Should -Be 'pki'
        $dns.CN | Should -Be '<CACommonName>-<environment>'
        $dns.DC | Should -Be 'win','org','io'
    }
  }

  # Context 'setCAext()'{
  #   It 'x'{
  #   }
  # }

  Context 'setCAAuthorityInformationAccess()' {
    It 'set CAAuthorityInformationAccess for rootca on dev' {
      $aia = [Env]::new([Envs]::dev, [CAs]::rootca).CAext.CAAUthorityInformationAccess
      $aia | Should -BeNullOrEmpty
    }

    It 'set CAAuthorityInformationAccess for rootca on azure' {
      $aia = [Env]::new([Envs]::azure, [CAs]::rootca).CAext.CAAUthorityInformationAccess
      $aia | Should -Not -BeNullOrEmpty
    }

    It 'set CAAuthorityInformationAccess for rootca on azure' {
      $aia = [Env]::new([Envs]::azure, [CAs]::rootca).CAext.CAAUthorityInformationAccess
      $aia.uri | Should -Be '65:C:\Windows\system32\CertSrv\CertEnroll\rootca.crt'
    }

    It 'set CAAuthorityInformationAccess for rootca on azure' {
      $aia = [Env]::new([Envs]::azure, [CAs]::rootca).CAext.CAAUthorityInformationAccess
      $aia.AddToCertificateAia | Should -Be $true
    }
  }

  Context 'setCACRLDistributionPoint()' {
    It 'set CACRLDistributionPoint for rootca on dev' {
      $cdp = [Env]::new([Envs]::dev, [CAs]::rootca).CAext.CACRLDistributionPoint
      $cdp | Should -BeNullOrEmpty
    }

    It 'set CACRLDistributionPoint for rootca on azure' {
      $cdp = [Env]::new([Envs]::azure, [CAs]::rootca).CAext.CACRLDistributionPoint
      $cdp | Should -Not -BeNullOrEmpty
      $cdp.uri | Should -Be '65:C:\Windows\system32\CertSrv\CertEnroll\rootca.crt'
    }

    It 'set CACRLDistributionPoint for rootca on azure' {
      $cdp = [Env]::new([Envs]::azure, [CAs]::rootca).CAext.CACRLDistributionPoint
      $cdp | Should -Not -BeNullOrEmpty
      $cdp.PublishToServer | Should -Be $true
    }

    It 'set CACRLDistributionPoint for rootca on azure' {
      $cdp = [Env]::new([Envs]::azure, [CAs]::rootca).CAext.CACRLDistributionPoint
      $cdp | Should -Not -BeNullOrEmpty
      $cdp.PublishToDeltaServer | Should -Be $true
    }

    It 'set CACRLDistributionPoint for rootca on azure' {
      $cdp = [Env]::new([Envs]::azure, [CAs]::rootca).CAext.CACRLDistributionPoint
      $cdp | Should -Not -BeNullOrEmpty
      $cdp.AddToCertificateCdp | Should -Be $true
    }

    It 'set CACRLDistributionPoint for rootca on azure' {
      $cdp = [Env]::new([Envs]::azure, [CAs]::rootca).CAext.CACRLDistributionPoint
      $cdp | Should -Not -BeNullOrEmpty
      $cdp.AddToFreshestCrl | Should -Be $true
    }

    It 'set CACRLDistributionPoint for rootca on azure' {
      $cdp = [Env]::new([Envs]::azure, [CAs]::rootca).CAext.CACRLDistributionPoint
      $cdp | Should -Not -BeNullOrEmpty
      $cdp.AddToCrlCdp | Should -Be $true
    }

    It 'set CACRLDistributionPoint for rootca on azure' {
      $cdp = [Env]::new([Envs]::azure, [CAs]::rootca).CAext.CACRLDistributionPoint
      $cdp | Should -Not -BeNullOrEmpty
      $cdp.AddToCrlIdp | Should -Be $false
    }
  }
}
