describe 'install-adcs-role' {
  $script = "$PSScriptRoot\config.ps1"
  . $script

  context 'install adcs' {
    it 'Adcs-Cert-Authority installed' {
      Get-WindowsFeature Adcs-Cert-Authority | Should Not BeNullOrEmpty
    }

    it 'AD-Certificate installed' {
      Get-WindowsFeature AD-Certificate | Should Not BeNullOrEmpty
    }
  }
}
