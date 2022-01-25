class Util {
  static [void] help() {
    Get-Content README.md
  }

  static [void] appToPen() {
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

  static [void] getSelf($prop) {
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

  static [void] getVar($var) {
    if ($null -ne $var) {
      Get-Variable *$var*
    } else {
      Get-Variable
    }
  }

  static [void] getMod($module) {
    if (($null -ne $module) -and ($module -in $modules.keys)) {
      Get-Command -Module $module
    } else {
      foreach ($key in $modules.keys) {
        Get-Command -Module $key
      }
    }
  }
}

