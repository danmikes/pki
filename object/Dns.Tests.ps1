Describe '[DNS]' {
  Context '[DNS]::new' {
    It 'create DNS $null azure' {
      { [DNS]::new([EnvType]::dev)} | Should -Throw
    }

    It 'create DNS rootca $null' {
      { [DNS]::new([CAType]::winca)} | Should -Throw
    }

    It 'create DNS azure' {
      [DNS]::new([EnvType]::dev, [CAType]::rootca) | Should -Throw
    }

    It 'create DNS azure' {
      [DNS]::new([EnvType]::azure, [CAType]::winca) | Should -Throw
    }

    It 'create DNS azure' {
      [DNS]::new() | Should -BeOfType [DNSType]
    }

    It 'create DNS azure' {
      [DNS]::new([EnvType]::azure) | Should -BeOfType [DNSType]
    }

    It 'create DNS azure' {
      [DNS]::new([EnvType]::azure, [CAType]::rootca) | Should -BeOfType [DNSType]
    }
  }

  Context 'prefixDNS()' {
    It 'create entries for elements in OU' {
      $OU = 'eam,www.pki-rootca.io'
      [DNS]::new([EnvType]::local).prefixDNS($this.OU) | Should -Be $OU
    }
  }

  Context 'prefixDNS()' {
    It 'create entries for elements in OU' {
      CN = "rootca"
      # CN = "<CACommonName>-<environment>"
      [DNS]::new([EnvType]::local).prefixDNS($this.CN) | Should -Be $CN
    }
  }

  Context 'getDNS()' {
    It 'create generic DNS' {
      $dns = <# "O=Org,L=City,S=Area,C=IO,OU=Team,eam,www.pki-rootca.io,Title=pki,CN=rootca,CN=Configuration,DC=win,DC=org,DC=io" #>
      [DNS]::new().getDNS() | Should -Be $dns
    }

    It 'create DNS for rootca on azure' {
      $dns = <# "O=Org,L=City,S=Area,C=IO,OU=Team,eam,www.pki-rootca.io,Title=pki,CN=rootca,CN=Configuration,DC=win,DC=org,DC=io" #>
      [DNS]::new([EnvType]::azure).getDNS() | Should -Be $dns
    }
  }
}
