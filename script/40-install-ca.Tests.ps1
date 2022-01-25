describe 'install-ca' {
  $script = "$PSScriptRoot\config.ps1"
  . $script

  context 'ca folders' {
    it 'folder CertLog exists' {
      $CaDrive.certLog | Should Exist
    }

    it 'folder CertEnroll exists' {
      $CaDrive.certEnroll | Should Exist
    }
  }

  context 'ca install properties'{
    it 'should install correct Ca type'{
      $type = certutil -cainfo type
      if($Install.CAType -eq "StandaloneRootCA"){$type[0] | Should Match "CA type: 3 -- Stand-alone Root CA" } # $type is a string array with 3 strings
    }

    it 'CA should have correct common name'{
      $name = certutil -cainfo name
      $name[0] | Should Match $Install.CACommonName } # $name is string array with 2 strings

    }

  context 'capolicy settings'{
    it 'should have correct CRL validity period'{
      $CRLPeriodUnits = certutil -getreg CA\CRLPeriodUnits 
      $CRLPeriodUnits[2] | Should Match $CaPolicy.CRLPeriodUnits # $CRLPeriodUnits is string array with 4 strings
      $CRLPeriod = certutil -getreg CA\CRLPeriod 
      $CRLPeriod[2] | Should Match $CaPolicy.CRLPeriod # $CRLPeriod is string array with 3 strings
    }

    it 'should have correct Delta CRL validity period'{
      $CRLDeltaPeriodUnits = certutil -getreg CA\CRLDeltaPeriodUnits 
      $CRLDeltaPeriodUnits[2] | Should Match "REG_DWORD = "+$CaPolicy.CRLDeltaPeriodUnits  #should match "0" would not be good assertion, therefore should match "REG_DWORD = 0"
      $CRLDeltaPeriod  = certutil -getreg CA\CRLDeltaPeriod  
      $CRLDeltaPeriod[2] | Should Match $CaPolicy.CRLDeltaPeriod
    }
  }

  context 'ca registry settings'{
    it 'should have correct validity period for issued certificates'{
      $ValidityPeriodUnits = certutil -getreg CA\ValidityPeriodUnits 
      $ValidityPeriodUnits[2] | Should Match "REG_DWORD = "+$CaPolicy.ValidityPeriodUnits 
      $ValidityPeriod = certutil -getreg CA\ValidityPeriod 
      $ValidityPeriod[2] | Should Match $CaPolicy.ValidityPeriod 
    }

    it 'should have correct CRL overlap period'{
      $CRLOverlapUnits = certutil -getreg CA\CRLOverlapUnits 
      $CRLOverlapUnits[2] | Should Match "REG_DWORD = "+$CaPolicy.CRLOverlapUnits  # should match "0" would not be good assertion, therefore should match "REG_DWORD = 0"
      $CRLOverlapPeriod  = certutil -getreg CA\CRLOverlapPeriod  
      $CRLOverlapPeriod[2] | Should Match $CaPolicy.CRLOverlapPeriod
    }
  }
}
