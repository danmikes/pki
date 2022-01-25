# TODO : restart ?
  function installCS() {
      try {
    Import-Module ServerManager
    Install-WindowsFeature Adcs-Cert-Authority -IncludeManagementTools
    Install-WindowsFeature AD-Certificate
    Install-WindowsFeature Adcs-Web-Enrollment
    Install-WindowsFeature Adcs-Online-Cert
    Install-WindowsFeature RSAT-ADCS
    Install-WindowsFeature RSAT-ADCS-Mgmt
   } catch { Write-Host "failed to install ADCS" -ForegroundColor Red }
  Write-Host "failed to install ADCS" -ForegroundColor Yellow
}

function makeCA() {
  #  copyPolicy
    installCS
    createCA
    configCA
    publishCA
    makePem
    copyFile
    testCA
    getCA
  }
  
# TODO : restart ?
function createCA() {
  try {
    Install-ADcsCertificationAuthority $rootCA -Force
  } catch { Write-Host "failed to create RootCA" -ForegroundColor Yellow }
}

function getCA() {
  # TODO : from ADCS
  $rootCA
}

function saveCA() {
  $folder = getFolder
  $path = "$pathBackup\$folder"
  try {
    Backup-CARoleService -Path $path
  } catch { Write-Host "failed to save RootCA" -ForegroundColor Red }
}

function restoreCA() {
  $folder = getLastFolder
  $path = "$pathBackup\$folder"
  try {
    Restore-CARoleService -Path $path
  } catch { Write-Host "failed to restore RootCA" -ForegroundColor Red }
}

function dropCA() {
  try {
    Uninstall-AdcsCertificationAuthority -Force
  } catch { Write-Host "failed to remove RootCA" -ForegroundColor Yellow }
}

# TODO : check options ?
function configCA() {
  try {
    deleteAia
    deleteCdp
    addAia
    addCdp
  } catch { Write-Host "failed to configure RootCA" -ForegroundColor Red }
}

function publishCA() {
  try {
    Rename-Item "$pathCrt\rootca_$CAname.crt" "$pathCrt\$CAname.crt"
    Publish-Crl -UpdateFile
  } catch { Write-Host "failed to publish crl" -ForegroundColor Red }
}

function testCA() {
  try {
    Get-CAAuthorityInformationAccess
    Get-CACrlDistributionPoint
    Invoke-WebRequest $urlAia
    Invoke-WebRequest $urlCdp
  } catch { Write-Host "failed to test website" -ForegroundColor Red }
}
