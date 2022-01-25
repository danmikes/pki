<# FUNCTION #>
function help() {
  Get-Content README.md
}

function appToPen() {
  $path = "C:\code\pki\*"
  $exclude = ".git"
  $destination = "D:\pki"
  try {
    Copy-Item -Path $path -Exclude $exclude -Destination $destination -Recurse -Force
    Write-Host "application copied to pathPen : $path." -ForegroundColor Cyan
  } catch {
    Write-Host "application failed to copy to server" -ForegroundColor Red
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

function setBackup([Env] $env) {
  [string] $backup = $null
  try {
    if (!(Test-Path -Path "$($envdir.dirBackup)\initial")) {
      $folder = 'initial'
    } else {
      $folder = Get-Date -Format "yyyyMMdd"
    }
    $backup = "$($env.dir.dirBackup)\$folder"
    New-Item $backup -Type Directory -Force
    Write-Host "created backup folder : $backup"
  } catch {
    Write-Host "failed to create backup folder : $backup"
  }
  return $backup
}

function setPem([Env] $env) {
  $fileTypes = @{
    crt = 'x509'
    crl = 'crl'
  }

  foreach ($key in $fileTypes.keys) {
    $Argumentlist = "{3} -inform DER -outform PEM `
      -in {0}\{1}.{2} -out {0}\{1}.{2}.pem" `
      -f $env.dirCrt, $env.CACOmmonName, $key, $fileTypes[$key]
      Start-Process -FilePath "$($env.dirSsl)\openssl.exe" `
      -ArgumentList $ArgumentList `
      -RedirectStandardError "$($env.dirSsl)\output\stderror.txt" `
      -RedirectStandardOutput "$($env.dirSsl)\output\stdout.txt"
  }
}

<#
function addPolicy([Env] $env) {
  $ca = $env.CAmain.CACommonName
  $dirWin = $env.dir.dirWin
  $policy = $env.file.CAPolicy
  try {
    Copy-Item $policy $dirWin -Force
    Write-Host "added CAPolicy.inf : $ca"
  } catch {
    Write-Host "failed to add CAPolicy.inf : $ca"
  }
}
#>

<#
function deletePolicy([Env] $env) {
  $ca = $env.CAmain.CACommonName
  $dirWin = $env.dir.dirWin
  $policy = "$($dirWin)\$CAPolicy.inf
  try {
    Remove-Item $policy -Force
    Write-Host "deleted CAPolicy.inf : $ca"
  } catch {
    Write-Host "failed to delete CAPolicy.inf : $ca"
  }
}
#>

<#
function adcs($module) {
  Get-Command -Module AdcsAdministration
}
#>

<#
function cert($path, $subject) {
  if ($null -eq $path -and $null -eq $subject) {
    Get-ChildItem -Path Cert:\LocalMachine\root -ErrorAction Stop
  } elseif ($null -eq $subject) {
    Get-ChildItem -Path Cert:\LocalMachine\$path -ErrorAction Stop
  } else {
    Get-ChildItem -Path Cert:\LocalMachine\$path |
    Where-Object {"$_.Subject" -Match $subject} |
    Select-Object FriendlyName, Thumbprint, Subject, NotBefore, NotAfter
  }
}
#>

<#
define remote session
$user = Get-Content "$PSScriptRoot\admin.txt"
$name = $user.split(' ')[0]
$pass = [regex]::Escape($user.split(' ')[1]) | ConvertTo-SecureString -AsPlainText -Force
$credential = [pscredential]::new($name,$pass)
$session = New-PSSession -ComputerName rootca $credential

# enter remote session
Enter-PSSession -Session $session

# exit remote session
Exit-PSSession -Session $session

Read-Host "Script finished, press Enter to close"
#>
