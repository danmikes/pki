<# App runner #>

[system.gc]::Collect()

function loadApp() {
  Import-Module ./util -Force
  Import-Module ./CAdata -Force
  Import-Module ./CAcontrol -Force
  Import-Module ./CAservice -Force
  Import-Module ./UserService -Force
}

function dropApp() {
  Remove-Module util
  Remove-Module CAdata
  Remove-Module CAcontrol
  Remove-Module CAservice
  Remove-Module UserService
}

'load application'
loadApp

'set application'
setApp
setEnv('tst')
