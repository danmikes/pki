<# RUNNER #>

[system.gc]::Collect()

<# Utilities #>
function help() {
  [Util]::help()
}
function appToPen() {
  [Util]::appToPen()
}
function getSelf() {
  [Util]::getSelf()
}

<# Application #>
function loadApp() {
  & .\Env.ps1
  & .\User.ps1
  & .\CA.ps1
  & .\CAExt.ps1
  & .\Util.ps1
}
function testApp() {
  Invoke-Pester -Show All
}

<# Environment #>
function setEnv([Envs] $env, [CAs] $ca) {
  return [Env]::new([Envs]::$env, [CAs]::$ca)
}

<# Users #>
function addUsers([Env] $env) {
  [User]::addUser($env, [Users]::admin)
  [User]::joinGroup($env, [Users]::admin)
  [User]::saveUser($env, [Users]::admin)

  [User]::addUser($env, [Users]::resto)
  [User]::joinGroup($env, [Users]::resto)
}
function deleteUsers([Env] $env) {
  [User]::deleteUser($env, [Users]::admin)
  [User]::deleteUser($env, [Users]::resto)
}
function getUsers([Env] $env) {
  [User]::getUser($env, [Users]::admin)
  [User]::getUser($env, [Users]::resto)
}
function getAdmin([Env] $env) {
  [User]::getAdminCredentials($env)
}

<# Certification Authority #>
function createCA([Env] $env) {
  # [CA]::addPolicy()
  [CA]::createCA($env)
  [CAExt]::deleteCAAuthorityInformationAccess($env)
  [CAExt]::deleteCACRLDistributionPoint($env)
  [CAExt]::addCAAuthorityInformationAccess($env)
  [CAExt]::addCACRLDistributionPoint($env)
  [CAExt]::setPem($env)
  [CA]::saveCA($env)
}
function publishCA([Env] $env) {
  [CA]::publishCA($env)
}
function checkCA([Env] $env) {
  [CA]::checkCA($env)
}
function backupCA([Env] $env) {
  [CA]::backupCA($env)
}
function restoreCA([Env] $env) {
  [CA]::restoreCA($env)
}
function deleteCA([Env] $env) {
  [CA]::deleteCA($env)
  # [CA]::deletePolicy()
}

function getCA() {
  [CA]::getCA($env)
  [CA]::getCAExt($env)
  [CA]::getAIA($env)
  [CA]::getCDP($env)
}

<# Execution #>
loadApp
# testApp

<# Make all environment instances #>
$list = [System.Collections.ArrayList] @{}

[Env] $RootAzure = [Env]::new([Envs]::azure, [CAs]::rootca)
$list.add($RootAzure)

[Env] $RootLocal = [Env]::new([Envs]::local, [CAs]::rootca)
$list.add($RootLocal)

[Env] $RootNpo = [Env]::new([Envs]::npo, [CAs]::rootca)
$list.add($RootNpo)

[Env] $RootPrd = [Env]::new([Envs]::prd, [CAs]::rootca)
$list.add($RootPrd)

[Env] $RootTst = [Env]::new([Envs]::tst, [CAs]::rootca)
$list.add($RootTst)

[Env] $WinAzure = [Env]::new([Envs]::azure, [CAs]::winca)
$list.add($WinAzure)

[Env] $WinLocal = [Env]::new([Envs]::local, [CAs]::winca)
$list.add($WinLocal)

[Env] $WinNpo = [Env]::new([Envs]::npo, [CAs]::winca)
$list.add($WinNpo)

[Env] $WinPrd = [Env]::new([Envs]::prd, [CAs]::winca)
$list.add($WinPrd)

[Env] $WinTst = [Env]::new([Envs]::tst, [CAs]::winca)
$list.add($WinTst)

$list
