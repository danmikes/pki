describe 'map-network-drive' {
  $script = "$PSScriptRoot\config.ps1"
  . $script

  $penPath = "$($PenDrive.server)\$($PenDrive.drive)"
  $penMap = $PenDrive.map
  
  $pawPath = "$($PawDrive.server)\$($PawDrive.drive)"
  $pawMap = $PawDrive.map

    context 'map network drive' {
    it 'PenPath exists' {
      $penPath | Should Exist
    }

    it 'PenMap exists' {
      "$($penMap):" | Should Exist
    }

    it 'PawPath exists' {
      $pawPath | Should Exist
    }

    it 'PawMap exists' {
      "$($pawMap):" | Should Exist
    }
  }
}
