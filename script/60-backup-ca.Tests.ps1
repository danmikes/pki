describe 'backup-ca' {
  $script = "$PSScriptRoot\config.ps1"
  . $script

  $path = "$($PenDrive.map):\$($PenDrive.backup)"
  $folder = 'initial'
  $backup = "$path\$folder"
  $caName = $Install.CACommonName
  # todo : aia + serverdnsname

  context 'backup-ca' {
    it 'contains backup folder' {
      $backup | Should Exist
    }

    it 'contains ca database' {
      "$backup\DataBase\*.dat" | Should Exist
    }

    it 'contains ca log' {
      "$backup\DataBase\*.log" | Should Exist
    }

    it 'contains ca edb' {
      "$backup\DataBase\*.edb" | Should Exist
    }

    it 'contains ca private key' {
      "$backup\$caName.p12" | Should Exist
    }
  }
}
