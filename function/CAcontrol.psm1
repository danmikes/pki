function setEnv($env) {
  if (($null -ne $env) -and ($env -in $envs)) {
    Set-Variable -Name "environment" -Value $env -Scope Global
    setServer
    setDir
    setDns
  } else {
    Write-Host "set environment : setEnv <?> [ $envs ]" -ForegroundColor Magenta
  }
  $environment
}

function getEnv() {
  if ($null -eq $environment) {
    Write-Host "environment : `$null" -ForegroundColor Cyan
  } else {
    Write-Host "environment : $environment" -ForegroundColor Cyan
  }
}

function addPolicy() {
  Copy-Item "$pathApp\CAPolicy.inf" $pathWin -Force
}

function deletePolicy() {
  Remove-Item "$pathWin\CAPolicy.inf" -Force
}

# TODO : fix !
function setDir() {
  if ($null -eq $environment) {
    Write-Host "environment : $null"
  } else {
    foreach ($key in $envUri.$environment.keys) {
      $key
      $envuri.$environment.$key
      $global:key = $envUri.$environment.$key
    }
  }
  $envUri.$environment
}

function deleteAia() {
  Get-CAAuthorityInformationAccess |
  Where-Object{($_.uri -like "http*") -or ($_.uri -like "ldap*")} |
  Remove-CAAuthorityInformationAccess -force
}

function deleteCdp() {
  Get-CACrlDistributionPoint | `
  Where-Object{($_.uri -like "http*") -or ($_.uri -like "ldap*")} |
  Remove-CACrlDistributionPoint -Force
}

function addAia() {
  forEach ($uri in $uriAia.Keys) {
    Add-CAAuthorityInformationAccess -Uri $uri.uri -Force
      -AddToCertificateAia:$uri.uri
  }
}

function addCdp() {
  forEach ($uri in $uriCdp.Keys) {
    Add-CACRLDistributionPoint -Uri $uri.uri -Force
      -AddToCertificateCdp:$uri.AddToCertificateCdp `
      -AddToCrlIdp:$uri.AddToCrlIdp `
      -AddToFreshestCrl:$uri.AddToFreshestCrl
  }
}

function makePem() {
  foreach ($key in $fileTypes.keys) {
    $Argumentlist = "{3} -inform DER -outform PEM `
      -in {0}\{1}.{2} -out {0}\{1}.{2}.pem" `
     -f $pathCrt, $CAname, $key, $fileTypes[$key]
     Start-Process -FilePath "$pathSsl\openssl.exe" `
      -ArgumentList $ArgumentList `
      -RedirectStandardError "$pathSsl\output\stderror.txt" `
      -RedirectStandardOutput "$pathSsl\output\stdout.txt"
  }
}

function getFolder() {
  if (!(Test-Path -Path "$pathBackup\initial")) {
    $path = "$pathBackup\initial"
  } else {
    $date = Get-Date -Format "yyyyMMdd"
    $path = "$pathBackup\$date"
  }
  New-Item $path -Type Directory -Force
}

function getLastFolder($folder) {
  $path = "$pathBackup\$folder"
  if (!(Test-Path -Path $pathBackup) -or !(Test-Path -Path $pathBackup\*)) {
    Write-Host "Backup folder absent" -ForegroundColor Red
    return $null
  } elseif (($null -ne $folder) -and !(Test-Path -Path $path)) {
    Write-Host "Backup folder absent" -ForegroundColor Red
    return $null
  } elseif ($null -eq $folder) {
    $last = Get-ChildItem -Path $path | Sort-Object LastAccessTime -Descending | Select-Object -First 1
    Write-Host "found backup folder : $path" -ForegroundColor Yellow
  }
  return $last.name
}

function prefixDns($key) {
  $result = ""
  foreach ($item in $dns.$key) {
    $result += ",$result,$key=$item"
    $result = $result.TrimStart(',')
  }
  return $result.TrimStart(',')
}

function setDns() {
  $result = ""
  foreach ($key in $dns.Keys) {
    $element = prefixDns($key)
    $result = ",$result,$element"
  }
  $rootca.CADistinguishedNameSuffix = $result.trimStart(',')
}
  
# TODO : remove ?
<#
function addFolder() {
  foreach ($folder in $folders) {
    New-Item $folder -Type Directory
  }
}

function deleteFolder() {
  foreach ($folder in $folders) {
    Remove-Item $folder -Recurse
  }
}

function copyFile() {
  foreach ($key in $[$key]) {
    foreach ($folder in $types[$key].keys) {
      Copy-Item $pathCrt\$CAname.$key $folder -Force
    }
  }
}

function deleteFile() {
  foreach ($key in $files[$key]) {
    foreach ($folder in $types[$key].keys) {
      Remove-Item "$folder\$CAname.*"
    }
  }
}
#>
