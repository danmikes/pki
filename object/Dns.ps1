. .\CA.ps1
. .\Env.ps1

class DNS {
  $dnsItems = @{
    O = "Org"
    L = "City"
    S = "Area"
    C = "IO"
    OU = "Team,www.pki-rootca.io"
    Title = "pki"
    CN = "rootca"
    # CN = "<CACommonName>-<environment>"
    DC = "win","org","io"
  }

  [string] $CADistinguishedNameSuffix

  DNS() {
    [DNS]::new($null, $null)
  }

  DNS() {
    [DNS]::new([EnvType] $env, $null)
  }

  DNS([Envtype] $env, [CAType] $rootca) {
    $this.CADistinguishedNameSuffix = getDNS
  }

  [string] prefixDNS($key) {
    $result = ""
    foreach ($item in $this.dns.$key) {
      $result += ",$result,$key=$item"
      $result = $result.TrimStart(',')
    }
    return $result.TrimStart(',')
  }

  [string] getDNS() {
    $result = ""
    foreach ($key in $this.dnsItems.Keys) {
      $element = prefixDNS($key)
      $result = ",$result,$element"
    }
    return $result.trimStart(',')
  }
}

[DNS] $dns = [DNS]::new([EnvType]::azure, [CAType]::rootca)
$dns
