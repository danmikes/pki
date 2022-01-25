describe 'copy-files' {
  $script = "$PSScriptRoot\config.ps1"
  . $script
  
  $caName = $Install.CACommonName
  $certPath = $CaDrive.certEnroll
  $tempPath = $PawDrive.temp

  context 'copy files' {
    it 'CertEnroll folder exists' {
      $certPath | Should Exist
    }

    it 'contains root certificate' {
      "$certPath\$caName.crt" | Should Exist
    }

    it 'contains certificate revocation list' {
      "$certPath\$caName.crl" | Should Exist
    }

    it 'temp folder exists' {
      $tempPath | Should Exist
    }

    it 'contains root certificate' {
      "$tempPath\$caName.crt" | Should Exist
    }

    it 'contains certificate revocation list' {
      "$tempPath\$caName.crl" | Should Exist
    }
  }
}
