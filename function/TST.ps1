<# Test runner #>

function loadTest() {
  # Import-Module ./util -Force
  # Import-Module ./CAdata -Force
  # Import-Module ./CAcontrol -Force
  # Import-Module ./CAservice -Force
  Import-Module ./UserService -Force
}

function runTest() {
  invoke-pester './util.Tests.ps1'
  # invoke-pester './CAdata.Tests.ps1'
  # invoke-pester './CAcontrol.Tests.ps1'
  # invoke-pester './CAservice.Tests.ps1'
  invoke-pester './UserService.Tests.ps1'
}

# loadapp
loadTest
runTest
# invoke-pester
