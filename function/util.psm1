function help() {
  Get-Content README.md
}

function appToPen() {
  $path = "C:\code\rootca\*"
  $exclude = ".git"
  $destination = "D:\rootca"
  try {
    Copy-Item -Path $path -Exclude $exclude -Destination $destination -Recurse -Force
    Write-Host "application copied to pathPen : $pathPen" -ForegroundColor Cyan
  } catch {
    Write-Host "application failed to copy to server" -ForegroundColor Red
  }
}

function setApp() {
  $app = "rootca"
  $local = "\\$env:computername"
  $remote = "\\tsclient"
  if (Test-Path $local\d\$app) {
    Set-Location $local\d\$app
    Set-ExecutionPolicy -ExecutionPolicy Bypass
  } elseif (Test-Path $remote\d\$app) {
    Set-Location $remote\d\$app
  } elseif (Test-Path $remote\e\$app) {
    Set-Location $remote\e\$app
  }
  
  $env:UserName
  $env:ComputerName
  Get-Location
}

function setServer() {
  $server = getServer
  if ($null -ne $server) {
    Set-Variable -Name "server" -Value $server -Scope Global
    Write-Host "server : $server" -ForegroundColor Red
  }
  Write-Host "server : `$null" -ForegroundColor Red
}

function getServer() {
  if ($environment -eq 'local') {
    return getDrive("\\$env:computername")
  } else {
    return getDrive("\\tsclient")
  }
}

function getDrive($server) {
  $drives = ('d','e')
  foreach ($drive in $drives) {
    if (Test-Path "$server\$drive\$dirApp") {
      return "$server\$drive"
    }
  }
}

function getPath() {
  if ($null -eq $server) {
    Write-Host "server absent" -ForegroundColor Red
  } else {
    foreach ($key in $servers.keys) {
      Get-Variable $key
    }
  }
}

function getSelf($prop) {
  $props = (
    'HOMEPATH',
    'HOSTNAME',
    'LOGONSERVER',
    'PSMODULEPATH',
    'PSSCRIPTROOT',
    'SYSTEMROOT',
    'USERDOMAIN',
    'USERNAME',
    'USERDNSDOMAIN',
    'USERPROFILE'
    )
  if ($prop -in $props) {
    $prop + " : " +[Environment]::GetEnvironmentVariable($prop)
  } else {
    foreach ($key in $props) {
      $key + " : " + [Environment]::GetEnvironmentVariable($key)
    }
  }
}

function getData() {
  Get-Content app/CAdata.psm1
}

# display loaded variables
function getVar($var) {
  if ($null -ne $var) {
    Get-Variable *$var*
  } else {
    Get-Variable
  }
}

function true($_out, $out) {
  if ($_out -eq $out) {
    Write-Host "pass" -ForegroundColor DarkGreen
    Write-Host "expect : $_out"
    Write-Host "result : $out"
  } else {
    Write-Host "fail" -ForegroundColor DarkRed
    Write-Host "expect : $_out"
    Write-Host "result : $out"
  }
}

function false($_out, $out) {
  if ($_out -ne $out) {
    Write-Host "pass" -ForegroundColor DarkGreen
    Write-Host "expect : $_out"
    Write-Host "result : $out"
  } else {
    Write-Host "fail" -ForegroundColor DarkRed
    Write-Host "expect : $_out"
    Write-Host "result : $out"
  }
}

# display functions of imported modules
function getMod($module) {
  if (($null -ne $module) -and ($module -in $modules.keys)) {
    Get-Command -Module $module
  } else {
    foreach ($key in $modules.keys) {
      Get-Command -Module $key
    }
  }
}
