# RootCA
$CaDrive = @{
  server = '\\rootca'
  drive = 'c'
  map = 'C'
  certLog = 'C:\Windows\System32\CertLog'
  certEnroll = 'C:\Windows\System32\CertSrv\CertEnroll'
}

# LapTop
$PawDrive = @{
  server = '\\rootca'
  drive = 'd'
  map = 'D'
  temp = 'D:\temp'
}

# PenDrive
$PenDrive = @{
  server = '\\tsclient'
  drive = 'e'
  map = 'N'
  backup = 'N:\backup'
}

# temporary user
$TempUser = 'tempUser'

# admin users
$Users = @(
  'admin'
  'resto'
)

#https://docs.microsoft.com/en-us/powershell/module/adcsdeployment/install-adcscertificationauthority?view=windowsserver2019-ps
$Install=@{
  AllowAdministratorInteraction = $true
  CACommonName = 'RootCA'
  CADistinguishedNameSuffix = 'C=IO,ST=City,L=X,O=Org'
  CAType = "StandaloneRootCA"  # possible values are: EnterpriseRootCA, EnterpriseSubordinateCA, StandaloneRootCA, or StandaloneSubordinateCA
  CryptoProviderName = 'RSA#Microsoft Software Key Storage Provider'
  # CryptoProviderName = 'Utimaco CryptoServer Key Storage Provider'
  # KeyContainerName = ''
  DatabaseDirectory = $CaDrive.certLog  # Specifies folder location of certification authority database
  LogDirectory = $CaDrive.certLog       # Specifies folder location of certification authority log
  HashAlgorithmName = 'sha256'
  KeyLength = 4096

  OverwriteExistingCAinDS = $true    # Overwrite computer object in Active Directory Domain Service domain with same computer name
  OverwriteExistingDatabase = $true  # Overwrite existing certification authority database
  OverwriteExistingKey = $true       # Overwrite existing key container with same name
  ValidityPeriod = 'Years'           # Validity period of certification authority (CA) certificate ; If subordinate CA, do not specify this parameter because validity period is determined by parent CA
  ValidityPeriodUnits = 20           # Validity period of certification authority (CA) certificate ; If subordinate CA, do not specify this parameter because validity period is determined by parent CA

  # unused for rootca
  # ParentCA = ''               # Specifies configuration string of parent certification authority that will certify this CA
  # OutputCertRequestFile = ''  # Specifies folder location for certificate request file

  # other unused params:
  # -IgnoreUnicode
  # -Force
  # -WhatIf
  # -Confirm
  # <CommonParameters>
}

#https://docs.microsoft.com/en-us/windows-server/networking/core-network-guide/cncg/server-certs/prepare-the-capolicy-inf-file
$CaPolicy=@{
  CRLPeriod = 'Years'       # always configure to desired value
  CRLPeriodUnits = 20       # always configure to desired value 
  CRLDeltaPeriod = 'Days'   # default = "Days" , omit in CAPolicy.inf if no DeltaCrl required
  CRLDeltaPeriodUnits = 0   # default = 0 , omit in CAPolicy.inf if no DeltaCrl required
  LoadDefaultTemplates = 0  # always configure to desired value: True or False (or 1 or 0)

  # RenewalKeyLength = 2048          # Only use when renewing CA certificate ; specify key length and validity of CA certificate
  # RenewalValidityPeriod = 'Years'  # Only use when renewing CA certificate ; specify key length and validity of CA certificate
  # RenewalValidityPeriodUnits = 5   # Only use when renewing CA certificate ; specify key length and validity of CA certificate
  # ClockSkewMinutes = 20            # default = 20
  # AlternateSignatureAlgorithm = 0  # default = 0
  # ForceUTF8 = 0                    # default = 0
  # EnableKeyCounting = 0            # default = 0
}

$RegSettings=@{
  ValidityPeriodUnits = 1     # !validity period of certificates issued by CA!
  ValidityPeriod = 'Years'    # !validity period of certificates issued by CA!
  CRLOverlapUnits = 0         # default = 0 (not set)
  CRLOverlapPeriod = 'Hours'  # default = Hours
  Auditfilter = 127           # CA related events are recorded
}

$PublicationBaseUrl = 'http://10.0.0.0/PKI'
$Domain = 'DC=pkilab'
$CaShortNameForUrls = 'rootca'


#### no changes to this block ###########################################################################################################################################################
$AdcsWindir = $CaDrive.CertEnroll
# $UncPathWinDir = '\\localhost\' + $CaDrive.certEnroll

$LdapConfigurationContainer = 'CN=Configuration,' + $Domain
$LdapPkiContainer = ',CN=Public Key Services,CN=Services,'
$LdapAiaUri = 'ldap:///CN=<CATruncatedName>,CN=AIA' + $LdapPkiContainer + $LdapConfigurationContainer + '<CAObjectClass>'
$LdapCdpUri = 'ldap:///CN=<CATruncatedName><CRLNameSuffix>,CN=<ServerShortName>,CN=CDP' + $LdapPkiContainer + $LdapConfigurationContainer + '<CAObjectClass>'

# ldap:///CN=<CATruncatedName>,CN=AIA,CN=Public Key Services,CN=Services,<ConfigurationContainer><CAObjectClass>
# ldap:///CN=PkiLab-CA,CN=AIA,CN=Public Key Services,CN=Services,CN=Configuration,DC=pkilab?cACertificate?base?objectClass=certificationAuthority

# ldap:///CN=<CATruncatedName><CRLNameSuffix>,CN=<ServerShortName>,CN=CDP,CN=Public Key Services,CN=Services,<ConfigurationContainer><CDPObjectClass>
# ldap:///CN=PkiLab-CA,CN=DC-IA,CN=CDP,CN=Public Key Services,CN=Services,CN=Configuration,DC=pkilab?certificateRevocationList?base?objectClass=cRLDistributionPoint
########### end block ###################################################################################################################################################################


$AiaDefaultExtension = @{
  local = @{
    Uri = "$($AdcsWindir)\<ServerDNSName>_<CAName><CertificateName>.crt"
    AddToCertificateAia = $false
    AddToCertificateOcsp = $false
  }
}

#ordered Hashtable, extensions will be added to the CA in the supplied order 
$AiaCustomExtensions = [ordered]@{
  httppem = @{
    Uri = "$($PublicationBaseUrl)/AIA/$($CaShortNameForUrls).pem"
    AddToCertificateAia = $true
    AddToCertificateOcsp = $false
  }
  httpcrt = @{
    Uri = "$($PublicationBaseUrl)/AIA/$($CaShortNameForUrls).crt"
    AddToCertificateAia = $true
    AddToCertificateOcsp = $false
  }
  ldap = @{
    Uri = $LdapAiaUri
    AddToCertificateAia = $true
    AddToCertificateOcsp = $false
  }
}

$CdpDefaultExtension = @{
  local = @{
    Uri = "$($AdcsWindir)\<CAName><CRLNameSuffix><DeltaCRLAllowed>.crl"
    PublishToServer = $true
    PublishDeltaToServer = $true
    AddToCertificateCdp = $false
    AddToFreshestCrl = $false
    AddToCrlCdp = $false
    AddToCrlIdp = $false
  }
}

#ordered Hashtable, adds extensions to CA in same order 
$CdpCustomExtensions = [ordered]@{
  httppem = @{
    Uri = "$($PublicationBaseUrl)/CDP/$($CaShortNameForUrls).pem"
    # PublishToServer = $false
    # PublishDeltaToServer = $false
    AddToCertificateCdp = $true
    AddToFreshestCrl = $true
    # AddToCrlCdp = $true
    AddToCrlIdp = $false
  }
  httpcrt = @{
    Uri = "$($PublicationBaseUrl)/CDP/$($CaShortNameForUrls).crl"
    # PublishToServer = $false
    # PublishDeltaToServer = $false
    AddToCertificateCdp = $true
    AddToFreshestCrl = $true
    # AddToCrlCdp = $true
    AddToCrlIdp = $false
  }
  ldap = @{
    Uri = "$($LdapCdpUri)"
    PublishToServer = $false       # for standalone rootca should be false; crl published manually to ldap - not automatically by ca
    PublishDeltaToServer = $false  # for standalone rootca should be false; crl published manually to ldap - not automatically by ca
    AddToCertificateCdp = $true
    AddToFreshestCrl = $true
    AddToCrlCdp = $false
    AddToCrlIdp = $false
  }
}
