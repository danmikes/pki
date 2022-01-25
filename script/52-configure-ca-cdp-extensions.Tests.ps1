describe 'ca-cdp-extensions' {
  $script = "$PSScriptRoot\config.ps1"
  . $script

  $CACRLDistributionPoint = Get-CACRLDistributionPoint

  context 'cdp extensions'{
    it 'should have correct number of cdp extensions'{
      $expect = $CdpCustomExtensions.Keys.Count + 1
      $CACRLDistributionPoint.Length | Should Be $expect
    }

    it 'Default cdp extension for local file system should match'{
      $actual = [regex]::escape($CACRLDistributionPoint[0].Uri)  # escape backslashes
      $expect = [regex]::escape($CdpDefaultExtension.local.Uri)  # escape backslashes
      $actual | Should Be $expect
    }

    $i = 0
    forEach ($key in $CdpCustomExtensions.Keys) {
      $i++  # skip first entry : default extension

      it "custom cdp extension $($CdpCustomExtensions.$key.uri) should match"{
        $CACRLDistributionPoint[$i].Uri | Should Match $CdpCustomExtensions.$key.uri
        $CACRLDistributionPoint[$i].AddToCertificateAia | Should Match $CdpCustomExtensions.$key.AddToCertificateAia
        $CACRLDistributionPoint[$i].AddToCertificateOcsp | Should Match $CdpCustomExtensions.$key.AddToCertificateOcsp
      }
    }
  }
}
