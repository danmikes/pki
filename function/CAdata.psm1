<# variables #>
# TODO : make names, envs -> enum

$global:modules = [ordered] @{
  main = './app/main.pms1'
  util = './app/util.psm1'
  CAdata = './app/CAdata.psm1'
  CAcontrol = './app/CAcontrol.psm1'
  CAservice = './app/CAservice.psm1'
  UserService = './app/UserService.psm1'
  _main = './tst/main.pms1'
  _util = './tst/util.psm1'
  _CAdata = './tst/CAdata.psm1'
  _CAcontrol = './tst/CAcontrol.psm1'
  _CAservice = './tst/CAservice.psm1'
  _UserService = './tst/UserService.psm1'
}

# rootca-name
$global:CAname = "rootca"
$global:ext = ""

# [Util]::setEnv()
$global:environment = $null

# servers
$global:servers = @{
  local = "\\$env:computername"
  remote = "\\tsclient"
}

# [Util]::setServer()
$global:server = $null

$global:pathApp = $server
$global:pathBackup = "$($pathAp)\CaBackup"
$global:pathDb = "$($pathApp)\DbDir"
$global:pathKey = "$($pathApp)\KeyDir"
$global:pathLog = "$($pathApp)\LogDir"
$global:pathSsl = "$($pathApp)\SslDir"
$global:pathUser = "$($pathApp)\UserDir"

# System
$global:pathSrv = "C:\Windows\system32\CertSrv"
$global:pathCrt = "C:\Windows\system32\CertSrv\CertEnroll"

# folder
$global:folders = (
  $pathBackup,
  $pathDb,
  $pathKey,
  $pathLog,
  $pathSrv,
  $pathUser
)

# [Util]::setDir() -> setValue
$global:dirAia = $null
$global:dirCdp = $null
$global:urlAia = $null
$global:urlCdp = $null
$global:urlOcsp = $null

# user
$global:names = (
  'admin',
  'resto'
)

# environment
$global:envs = (
  'azure',
  'local',
  'npo',
  'prd',
  'tst'
)

# rootca
$global:rootCA = [System.Collections.SortedList] @{
  AllowAdministratorInteraction = $True
  CACommonName = "$CAname-$ext"
  CADistinguishedNameSuffix = $null
  CAType = "StandAlone"
  DatabaseDirectory = $pathDb
  LogDirectory = $pathLog
  OverwriteExistingCAinDS = $True
  OverwriteExistingDatabase = $True
  OverwriteExistingKey = $true
  ValidityPeriod = 20
  ValidityPeriodUnits = "Years"
}

# envUri
$global:envUri = [ordered] @{
  azure = [System.Collections.SortedList] @{
    uriAia = "\\10.0.0.4\pki\Aia"
    uriCdp = "\\10.0.0.4\pki\Cdp"
    urlAia = "http://pki.azure.io/pki/Aia"
    urlCdp = "http://pki.azure.io/pki/Cdp"
    urlOcsp = "http://pki.azure.io/ocsp"
  }
  local = [System.Collections.SortedList] @{
  }
  npo = [System.Collections.SortedList] @{
    uriAia = "\\se94apnpo01\D`$\CertEnroll\Aia"
    uriCdp = "\\se94apnpo01\D`$\CertEnroll\Cdp"
    urlAia = "http://pki.npo.io/pki/Aia"
    urlCdp = "http://pki.npo.io/pki/Cdp"
    urlOcsp = "http://www.npo.io/ocsp"
  }
  prd = [System.Collections.SortedList] @{
    uriAia = "\\pub01\D`$\CertEnroll\Aia"
    uriCdp = "\\pub01\D`$\CertEnroll\Cdp"
    urlAia = "http://pki.io/pki/Aia"
    urlCdp = "http://pki.io/pki/Cdp"
    urlOcsp = "http://www.io/ocsp"
  }
  tst = [System.Collections.SortedList] @{
    uriAia = "\\X1\pki\Aia"
    uriCdp = "\\X1\pki\Cdp"
    urlAia = "http://pki.tst.io/pki/Aia"
    urlCdp = "http://pki.tst.io/pki/Cdp"
    urlOcsp = "http://www.tst.io/ocsp"
  }
}

# Distinguished Name Suffix
$global:Dns = [ordered] @{
  O = "Org"
  L = "City"
  S = "Area"
  C = "IO"
  OU = "Team","www.pki-rootca-azure.io"
  Title = "pki"
  CN = "rootca-azure"
  DC = "win","org","io"
}

# Authority Information Acces - uri
$global:uriAia = [ordered]@{
  crt = [ordered] @{
    uri = "65:$($pathCrt)\$($CAname).crt"
    AddToCertificateAia = $True
  }
  pem = [ordered] @{
    uri = "5:$($dirAia)/$($CAname).pem"
    AddToCertificateAia = $True
  }
  crl = [ordered] @{
    uri = "6:$($dirAia)/$($CAname).crl"
    AddToCertificateAia = $True
  }
  ldap = [ordered] @{
    uri = "79:$($ldapAia)"
    AddToCertificateAia = $True
  }
}

# TODO : check options !
# Certificate Revocation List Distribution Point - uri
$global:uriCdp = [ordered] @{
  crt = [ordered] @{
    uri = "65:$($pathCrt)\$($CAname).crt"
    AddToCertificateCdp = $True
    AddToCrlIdp = $False
    AddToFreshestCrl = $True
  }
  pem = [ordered] @{
    uri = "5:$($dirCdp)/$($CAname).crl.pem"
    AddToCertificateCdp = $True
    AddToCrlIdp = $False
    AddToFreshestCrl = $True
  }
  crl = [ordered] @{
    uri = "6:$($dirCdp)/$($CAname).crl"
    AddToCertificateCdp = $True
    AddToCrlIdp = $False
    AddToFreshestCrl = $True
  }
  ldap = [ordered] @{
    uri = "79:$($ldapCdp)"
    AddToCertificateCdp = $True
    AddToCrlIdp = $False
    AddToFreshestCrl = $True
  }
}

# file
$global:files = [System.Collections.SortedList] @{
  'crt' = {$($dirAia),$($urlAia)}
  'crl' = {$($dirCdp),$($urlCdp)}
  'crt.pem' = {$($dirAia),$($urlAia)}
  'crl.pem' = {$($dirCdp),$($urlCdp)}
}

# fileType
$global:fileTypes = [System.Collections.SortedList] @{
  crt = 'x509'
  crl = 'crl'
}
