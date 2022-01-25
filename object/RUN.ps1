<# App runner #>
[system.gc]::Collect()

# TODO : remove ?
function deleteModules() {
  Remove-Module ./DNS -Force
  Remove-Module ./Env -Force
  Remove-Module ./File -Force
  Remove-Module ./CA -Force
  Remove-Module ./User -Force
  Remove-Module ./Util -Force
}

# TODO : remove ?
function importModules() {
  Import-Module ./DNS -Force
  Import-Module ./Env -Force
  Import-Module ./File -Force
  Import-Module ./CA -Force
  Import-Module ./User -Force
  Import-Module ./Util -Force
}

function loadScripts() {
  & ./DNS -Force
  & ./Env -Force
  & ./File -Force
  & ./CA -Force
  & ./User -Force
  & ./Util -Force
}

function setApp() {
  loadScripts
}

function testApp() {
  Invoke-Pester
}

function addUsers() {
  # [CA]::addPolicy()
  $admin = [User]::new([UserType]::admin)
  $admin
  [User]::getUser([UserType]::admin)

  $resto = [User]::new([UserType]::resto)
  $resto
  [User]::getUser([UserType]::resto)
}

function deleteUsers() {
  [User]::dropUser([UserType]::admin)
  [User]::dropUser([UserType]::resto)
}

function showAdmin() {
  [User]::getUser()
}

function addCA([EnvType] $env) {
  [Env] $env = [Env]::new($env)
  $env

  [DNS] $dns = [DNS]::new([CAType]::rootca, $env)
  $dns

  [CA] $ca = [CA]::rootca([EnvType] $env, [DNS] $dns)
  $ca

  $ca.saveCA
}

function saveCA() {
  $ca = [CA]::getCA()
  $ca
  $ca.saveCA()
}

function restoreCA() {
  [CA]::restoreCA()
}

function deleteCA() {
  [CA]::deleteCA()
}

setApp
testApp
