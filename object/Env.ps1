enum EnvType {
  azure
  local
  npo
  prd
  tst
}

enum ServerType {
  local
  remote
  web
}

enum DriveType {
  d
  e
}

class Env {
  $pathSrv = "C:\Windows\system32\CertSrv"
  $pathCrt = "C:\Windows\system32\CertSrv\CertEnroll"

  <# app #>
  [ServerType] $server
  [DriveType] $drive
  [string] $dirApp
  [string] $dirBackup
  [string] $dirBase
  [string] $dirKey
  [string] $dirSsl
  [string] $dirUser
  [string] $dirWeb
  [string[]] $uri
  <# rootca #>
  [string] $DatabaseDirectory
  [string] $LogDirectory

  Env([EnvType] $env) {
    # env
    $this.setServer
    $this.setDrive
    <# app #>
    $this.dirBase = ""
    $this.dirApp = "$($this.dirBase)\dirApp"
    $this.dirBackup = "$($this.dirBase)\dirBackup"
    $this.dirKey = "$($this.dirBase)\dirKey"
    $this.dirSsl = "$($this.dirBase)\dirSsl"
    $this.dirUser = "$($this.dirBase)\dirUser"
    $this.dirWeb = "$($this.dirBase)\dirWeb"
    <# rootca #>
    $this.DatabaseDirectory = "$($this.dirBase)\dirBase"
    $this.LogDirectory = "$($this.dirBase)\dirBase"
    $this.uri = $this.setUri()
  }

  [void] setServer() {
    switch($this) {
      [EnvType]::azure {
        $this.server = [ServerType]::web
        break
      }
      [EnvType]::local {
        $this.server = [ServerType]::local
        break
      }
      [EnvType]::npo {
        $this.server = [ServerType]::remote
        break
      }
      [EnvType]::prd {
        $this.server = [ServerType]::remote
        break
      }
      [EnvType]::tst {
        $this.server = [ServerType]::remote
        break
      }
    }
  }

  [void] setDrive() {
    if (Test-Path $($this.server)\[DriveType]::d) {
      $this.drive = [DriveType]::d
      break
    }
    if (Test-Path $($this.server)\[DriveType]::e) {
      $this.drive = [DriveType]::e
      break
    }
  }

  [void] setUri() {
    switch($this) {
      [EnvType]::azure {
        $this.uri = @{
          uriAia = "\\10.0.0.0\pki\Aia"
          uriCdp = "\\10.0.0.0\pki\Cdp"
          urlAia = "http://pki.io/pki/Aia"
          urlCdp = "http://pki.io/pki/Cdp"
          urlOcsp = "http://pki.io/ocsp"
        }
        break
      }
      [EnvType]::local {
        $this.uri = @{
        }
        break
      }
      [EnvType]::npo {
        $this.uri = @{
          uriAia = "\\npo01\D`$\CertEnroll\Aia"
          uriCdp = "\\npo01\D`$\CertEnroll\Cdp"
          urlAia = "http://pki.npo.io/pki/Aia"
          urlCdp = "http://pki.npo.io/pki/Cdp"
          urlOcsp = "http://www.npo.io/ocsp"
        }
        break
      }
      [EnvType]::prd {
        $this.uri = @{
          uriAia = "\\pub01\D`$\CertEnroll\Aia"
          uriCdp = "\\pub01\D`$\CertEnroll\Cdp"
          urlAia = "http://pki.io/pki/Aia"
          urlCdp = "http://pki.io/pki/Cdp"
          urlOcsp = "http://www.io/ocsp"
        }
        break
      }
      [EnvType]::tst {
        $this.uri = @{
          uriAia = "\\X1\pki\Aia"
          uriCdp = "\\X1\pki\Cdp"
          urlAia = "http://pki.tst.io/pki/Aia"
          urlCdp = "http://pki.tst.io/pki/Cdp"
          urlOcsp = "http://www.tst.io/ocsp"
        }
        break
      }
    }
  }
}
