describe 'ca-aia-extensions' {
  $script = "$PSScriptRoot\config.ps1"
  . $script

  $CAAuthorityInformationAccess = Get-CAAuthorityInformationAccess

  context 'aia extensions'{
    it 'should have correct number of aia extensions'{
      $expected = $AiaCustomExtensions.Keys.Count + 1
      $CAAuthorityInformationAccess.Length | Should Be $expected
    }

    it 'Default aia extension for local file system should match'{
      $actual = [regex]::escape($CAAuthorityInformationAccess[0].Uri)  # escape backslashes
      $expected = [regex]::escape($AiaDefaultExtension.local.Uri)      # escape backslashes
      $actual | Should Be $expected 
    }

    $i = 0
    forEach ($key in $AiaCustomExtensions.Keys) {
      $i++  # skip first entry : default extension

      it "custom aia extension $($AiaCustomExtensions.$key.uri) should match"{
        $CAAuthorityInformationAccess[$i].Uri | Should Match $AiaCustomExtensions.$key.uri
        $CAAuthorityInformationAccess[$i].AddToCertificateAia | Should Match $AiaCustomExtensions.$key.AddToCertificateAia
        $CAAuthorityInformationAccess[$i].AddToCertificateOcsp | Should Match $AiaCustomExtensions.$key.AddToCertificateOcsp
      }
    }
  }
}
