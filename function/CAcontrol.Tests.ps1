function _setEnv() {

  $environment0 = 'local'
  pass($environment0,$environment)

  $environment1 = 'azure'
  setEnv($environment1)
  pass($environment1,$environment)

  $environment2 = 'local'
  pass($environment2,$environment)

  $environment3 = 'npo'
  setEnv($environment3)
  pass($environment3,$environment)

  $environment4 = 'prd'
  setEnv($environment4)
  pass($environment4,$environment)

  $environment5 = 'tst'
  setEnv($environment5)
  pass($environment5,$environment)

  $environment6 = 'dev'
  setEnv($environment6)
  pass($environment6,$environment)
}

function _getEnv() {

}

function _addPolicy() {

  addPolicy
  pass($isPolicy,$true)
}

function _deletePolicy() {

  deletePolicy
  pass($isPolicy,$false)
}

function _setDns() {

  'names'
  pass($environment,$_environment)
  pass($CAname,$_CAname)

  'parameters in RootCA.conf'

  'check Dns object properties'
  pass($rootca.$Dns.O,$O)
  pass($rootca.$Dns.L,$L)
  pass($rootca.$Dns.S,$S)
  pass($rootca.$Dns.C,$C)
  pass($rootca.$Dns.OU,$OU)
  pass($rootca.$Dns.Title,$Title)
  pass($rootca.$Dns.CN,$CN)
  pass($rootca.$Dns.DC,$DC)

  'check rootca variables'
  pass($O,$x)
  pass($L,$x)
  pass($S,$x)
  pass($C,$x)
  pass($OU,$x)
  pass($Title,$x)
  pass($CN,$x)
  pass($DC,$x)

  'check CADistinguishedNameSuffix'
  $_Dns = "O=Org,L=City,S=Area,C=IO,OU=Team,OU=www.pki-local.io,Title=pki,CN=rootca-local,CN=Configuration,DC=win,DC=org,DC=io"
  pass($Dns,$_Dns)
}
