enum Users {
  admin
  resto
}

enum Envs {
  azure
  local
  npo
  prd
  tst
}

enum CAs {
  rootca
  winca
}

enum CATypes {
  StandAlone
  DomainJoined
}

enum Files {
  crt
  pem
  crl
  ldap
}

<# CLASS #>
class Env {
  <# arguments #>
  [Envs] $env
  [CAs] $ca

  <# app #>
  [string] $dirBase
  [HashTable] $file
  [HashTable] $dir
  [HashTable] $uri

  <# user #>
  [HashTable]$user

  # [CAs] $ca
  [HashTable] $CAmain
  [HashTable] $CAext

  Env([Envs] $env, [CAs] $ca) {
    <# consume arguments #>
    $this.env = $env
    $this.ca = $ca

    <# set locations #>
    $this.dirBase = '.'
    $this.file = $this.setFile()
    $this.dir = $this.setDir()
    $this.uri = $this.setUri()

    <# set Users #>
    $this.user = $this.setUser()

    <# set Certification Authority #>
    $this.CAmain = $this.setCAmain()
    $this.CAMain.CADistinguishedNameSuffix = $this.setDns()
    $this.CAext = $this.setCAext()
  }

  [HashTable] setFile() {
    return @{
      CAPolicy = "$($this.dirBase)\CAPolicy.inf"
    }
  }

  [HashTable] setDir() {
    return @{
      dirWin = "C:\Windows"
      dirSrv = "C:\Windows\system32\CertSrv"
      dirCrt = "C:\Windows\system32\CertSrv\CertEnroll"
      dirApp = "$($this.dirBase)\dirApp"
      dirBackup = "$($this.dirBase)\dirBackup"
      dirKey = "$($this.dirBase)\dirKey"
      dirSsl = "$($this.dirBase)\dirSsl"
      dirUser = "$($this.dirBase)\dirUser"
      dirWeb = "$($this.dirBase)\dirWeb"
    }
  }

  [HashTable] setUri() {
    [string] $baseUri = ''
    [string] $baseUrl = ''
    switch($this.env) {
      ([Envs]::azure) {
        $baseUri = "10.0.0.0\pki"
        $baseUrl = "https://pki.azure.io/pki"
      }
      ([Envs]::local) {
        $baseUri = "\\X1\pki"
        $baseUrl = "http://127.0.0.1/pki"
      }
      ([Envs]::npo) {
        $baseUri = "\\npo01\D`$\CertEnroll"
        $baseUrl = "http://pki.npo.io/pki"
      }
      ([Envs]::prd) {
        $baseUri = "\\pub01\D`$\CertEnroll"
        $baseUrl = "http://pki.io/pki"
      }
      ([Envs]::tst) {
        $baseUri = "\\tst01\D`$\CertEnroll"
        $baseUrl = "http://pki.tst.io/pki"
      }
    }
    return @{
      uriAia = "$baseUri\AIA"
      uriCdp = "$baseUri\CDP"
      uriLdap = "$baseUrl\LDAP"
      urlAia = "$baseUrl/AIA"
      urlCdp = "$baseUrl/CDP"
      urlOcsp = "$baseUrl/OCSP"
    }
  }

  [HashTable] setUser() {
    return @{
      [string] [Users]::admin = @{
        AccountNeverExpires = $true
        File = "$($this.dir.dirUser)\admin.txt"
        Group = 'Administrators'
        Name = 'admin'
        Password = $this.newPass()
        PasswordNeverExpires = $true
        Verbose = $true
      }
      [string] [Users]::resto = @{
        AccountNeverExpires = $true
        Group = 'Administrators'
        Name = 'resto'
        Password = $this.newPass()
        PasswordNeverExpires = $true
        Verbose = $true
      }
    }
  }

  [string] newPass() {
    $length = 14
    $special = 2
    Add-Type -AssemblyName 'System.Web'
    return [System.Web.Security.Membership]::GeneratePassword($length, $special)
  }

  [HashTable] setCAmain() {
    switch($this.env) {
      ([Envs]::azure) {
        return [ordered] @{
          AllowAdministratorInteraction = $true
          CACommonName = "$($this.ca)"
          CADistinguishedNameSuffix = $this.setDNS()
          CAName = $this.ca
          CAType = $this.setCAType()
          DatabaseDirectory = "$($this.dirBase)\dirDb"
          LogDirectory = "$($this.dirBase)\dirLog"
          OverwriteExistingCAinDS = $true
          OverwriteExistingDatabase = $true
          OverwriteExistingKey = $true
          ValidityPeriod = 20
          ValidityPeriodUnits = 'Years'
        }
      }
      ([Envs]::local) {
        return [ordered] @{
          AllowAdministratorInteraction = $true
          CACommonName = "$($this.ca)"
          CADistinguishedNameSuffix = $this.setDNS()
          CAName = $this.ca
          CAType = $this.setCAType()
          DatabaseDirectory = "$($this.dirBase)\dirDb"
          LogDirectory = "$($this.dirBase)\dirLog"
          OverwriteExistingCAinDS = $true
          OverwriteExistingDatabase = $true
          OverwriteExistingKey = $true
          ValidityPeriod = 20
          ValidityPeriodUnits = 'Years'
        }
      }
      ([Envs]::npo) {
        return [ordered] @{
          AllowAdministratorInteraction = $true
          CACommonName = "$($this.ca)"
          CADistinguishedNameSuffix = $this.setDNS()
          CAName = $this.ca
          CAType = $this.setCAType()
          DatabaseDirectory = "$($this.dirBase)\dirDb"
          LogDirectory = "$($this.dirBase)\dirLog"
          OverwriteExistingCAinDS = $true
          OverwriteExistingDatabase = $true
          OverwriteExistingKey = $true
          ValidityPeriod = 20
          ValidityPeriodUnits = 'Years'
        }
      }
      ([Envs]::prd) {
        return [ordered] @{
          AllowAdministratorInteraction = $true
          CACommonName = "$($this.ca)"
          CADistinguishedNameSuffix = $this.setDNS()
          CAName = $this.ca
          CAType = $this.setCAType()
          DatabaseDirectory = "$($this.dirBase)\dirDb"
          LogDirectory = "$($this.dirBase)\dirLog"
          OverwriteExistingCAinDS = $true
          OverwriteExistingDatabase = $true
          OverwriteExistingKey = $true
          ValidityPeriod = 20
          ValidityPeriodUnits = 'Years'
        }
      }
      ([Envs]::tst) {
        return [ordered] @{
          AllowAdministratorInteraction = $true
          CACommonName = "$($this.ca)"
          CADistinguishedNameSuffix = $this.setDNS()
          CAName = $this.ca
          CAType = $this.setCAType()
          DatabaseDirectory = "$($this.dirBase)\dirDb"
          LogDirectory = "$($this.dirBase)\dirLog"
          OverwriteExistingCAinDS = $true
          OverwriteExistingDatabase = $true
          OverwriteExistingKey = $true
          ValidityPeriod = 20
          ValidityPeriodUnits = 'Years'
        }
      }
    }
    return $null
  }

  [CATypes] setCAtype() {
    switch($this.ca) {
      ([CAs]::rootca) {
        return [CATypes]::StandAlone
      }
      ([CAs]::winca) {
        return [CATypes]::DomainJoined
      }
    }
    return $null
  }

  [string] setDNS() {
    $dns = $this.getDNS()
    $result = ""
    foreach ($key in $dns.Keys) {
      foreach ($value in $dns.$key) {
        $result += ",$key=$value"
        $result = $result.TrimStart(',')
      }
      $result = $result.TrimStart(',')
    }
    return $result.trimStart(',')
  }

  [HashTable] getDNS() {
    $CACommonName = $this.CAmain.CACommonName
    $environment = "$($this.env)"
    switch($this.env) {
      ([Envs]::azure) {
        return [ordered] @{
          O = 'Org'
          L = 'City'
          S = 'Area'
          C = 'IO'
          OU = 'Team',"www.pki-$($environment).io"
          Title = 'pki'
          CN = "$($CACommonName)-$($this.env)"
          DC = 'win','org','io'
        }
      }
      ([Envs]::local) {
        return [ordered] @{
          O = 'Org'
          L = 'City'
          S = 'Area'
          C = 'IO'
          OU = 'Team',"www.pki-$($environment).io"
          Title = 'pki'
          CN = "$($CACommonName)-$($this.env)"
          DC = 'win','org','io'
        }
      }
      ([Envs]::npo) {
        return [ordered] @{
          O = 'Org'
          L = 'City'
          S = 'Area'
          C = 'IO'
          OU = 'Team',"www.pki-$($environment).io"
          Title = 'pki'
          CN = "$($CACommonName)-$($this.env)"
          DC = 'win','org','io'
        }
      }
      ([Envs]::prd) {
        return [ordered] @{
          O = 'Org'
          L = 'City'
          S = 'Area'
          C = 'IO'
          OU = 'Team',"www.pki-$($environment).io"
          Title = 'pki'
          CN = "$($CACommonName)-$($this.env)"
          DC = 'win','org','io'
        }
      }
      ([Envs]::tst) {
        return [ordered] @{
          O = 'Org'
          L = 'City'
          S = 'Area'
          C = 'IO'
          OU = 'Team',"www.pki-$($environment).io"
          Title = 'pki'
          CN = "$($CACommonName)-$($this.env)"
          DC = 'win','org','io'
        }
      }
    }
    return $null
  }

  [HashTable] setCAext() {
    return @{
      CAAuthorityInformationAccess = $this.setCAAUthorityInformationAccess()
      CACRLDistributionPoint = $this.setCACRLDistributionPoint()
    }
  }

  [HashTable] setCAAUthorityInformationAccess() {
    return @{
      crt = @{
        Uri = "65:$($this.dir.dirCrt)\$($this.CAmain.CACommonName).crt"
        AddToCertificateAia = $True
      }
      pem = @{
        Uri = "5:$($this.uri.uriAia)/$($this.CAmain.CACommonName).pem"
        AddToCertificateAia = $True
      }
      crl = @{
        Uri = "6:$($this.uri.uriAia)/$($this.CAmain.CACommonName).crl"
        AddToCertificateAia = $True
      }
      ldap = @{
        Uri = "79:$($this.uri.uriLdap)"
        AddToCertificateAia = $True
      }
    }
  }

  [HashTable] setCACRLDistributionPoint() {
    return @{
      crt = @{
        Uri = "65:$($this.dir.dirCrt)\$($this.CAmain.CACommonName).crt"
        PublishToServer = $True
        PublishToDeltaServer = $True
        AddToCertificateCdp = $True
        AddToFreshestCrl = $True
        AddToCrlCdp = $True
        AddToCrlIdp = $False
      }
      pem = @{
        Uri = "5:$($this.uri.uriCdp)/$($this.CAmain.CACommonName).crl.pem"
        PublishToServer = $True
        PublishToDeltaServer = $True
        AddToCertificateCdp = $True
        AddToFreshestCrl = $True
        AddToCrlCdp = $True
        AddToCrlIdp = $False
      }
      crl = @{
        Uri = "6:$($this.uri.uriCdp)/$($this.CAmain.CACommonName).crl"
        PublishToServer = $True
        PublishToDeltaServer = $True
        AddToCertificateCdp = $True
        AddToFreshestCrl = $True
        AddToCrlCdp = $True
        AddToCrlIdp = $False
      }
      ldap = @{
        Uri = "79:$($this.uri.uriLdap)/$($this.CAmain.CACommonName).ldap"
        PublishToServer = $True
        PublishToDeltaServer = $True
        AddToCertificateCdp = $True
        AddToFreshestCrl = $True
        AddToCrlCdp = $True
        AddToCrlIdp = $False
      }
    }
  }
}

# $list = [System.Collections.ArrayList]::new()

# $env1 = [Env]::new([Envs]::local, [CAs]::rootca)
# $list.add($env1)
# '$env1'
# $env1
# '$env1.file'
# $env1.file
# '$env1.dir.dirUser'
# $env1.dir.dirUser
# '$env1.uri.uriAia'
# $env1.uri.uriAia
# '$env1.user.admin'
# $env1.user.admin
# '$env1.camain.CACommonName'
# $env1.camain.CACommonName
# '$env1.caext.CACRLDistributionPoint.crt'
# $env1.caext.CACRLDistributionPoint.crt

# $env2 = [Env]::new([Envs]::tst, [CAs]::rootca)
# $list.add($env2)

# $env3 = [Env]::new([Envs]::local, [CAs]::winca)
# $list.add($env3)

# $env4 = [Env]::new([Envs]::tst, [CAs]::winca)
# $list.add($env4)

# $list
