$ErrorActionPreference = 'Stop'

$unzipLocation = Join-Path -Path (Get-ToolsLocation) -ChildPath $env:ChocolateyPackageName

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $unzipLocation
  url           = 'https://download.cpuid.com/hwmonitor/hwmonitor_1.61.zip'
  checksum      = '7f7916aa48bb82ca7ea8cff10908b8282ac3afca11a44304e326232a1e7c16e1'
  checksumType  = 'sha256'
}
Install-ChocolateyZipPackage @packageArgs

$pp = Get-PackageParameters
if ($pp.PreserveAllBinaries) {
  if ((Get-OSArchitectureWidth -Compare 32)) {
    Write-Warning 'x64 binary is incompatible with 32-bit environments, ignoring PreserveAllBinaries switch'
    $pp.PreserveAllBinaries = $false
  }
  elseif ($env:chocolateyForceX86 -eq $true) {
    Write-Warning 'x64 binary is not supported with forced x86 package behavior, ignoring PreserveAllBinaries switch'
    $pp.PreserveAllBinaries = $false
  }
}

$32BitBinaryFileName = 'HWMonitor_x32.exe'
$64BitBinaryFileName = 'HWMonitor_x64.exe'
$32BitBinaryFilePath = Join-Path -Path $unzipLocation -ChildPath $32BitBinaryFileName
$64BitBinaryFilePath = Join-Path -Path $unzipLocation -ChildPath $64BitBinaryFileName

if ((Get-OSArchitectureWidth -Compare 64) -and ($env:chocolateyForceX86 -ne $true)) {
  $defaultTargetPath = $64BitBinaryFilePath
}
else {
  $defaultTargetPath = $32BitBinaryFilePath
}

$defaultShimName = 'HWMonitor'
if ($pp.NoDefaultShim) {
  Uninstall-BinFile -Name $defaultShimName
}
else {
  Install-BinFile -Name $defaultShimName -Path $defaultTargetPath -UseStart
}

$32BitBinaryShimName = [System.IO.Path]::GetFileNameWithoutExtension($32BitBinaryFileName)
$64BitBinaryShimName = [System.IO.Path]::GetFileNameWithoutExtension($64BitBinaryFileName)
if ($pp.ShimWithPlatform) {
  if ((Get-OSArchitectureWidth -Compare 64) -and ($env:chocolateyForceX86 -ne $true)) {
    Install-BinFile -Name $64BitBinaryShimName -Path $64BitBinaryFilePath -UseStart

    if ($pp.PreserveAllBinaries) {
      Install-BinFile -Name $32BitBinaryShimName -Path $32BitBinaryFilePath -UseStart
    }
  }
  else {
    Install-BinFile -Name $32BitBinaryShimName -Path $32BitBinaryFilePath -UseStart
  }
}

$defaultLinkName = 'HWMonitor.lnk'
$32BitShortcutLinkName = 'HWMonitor (32-bit).lnk'
$64BitShortcutLinkName = 'HWMonitor (64-bit).lnk'

if (!$pp.NoDesktopShortcut) {
  $desktopDirectory = [Environment]::GetFolderPath([Environment+SpecialFolder]::DesktopDirectory)

  if ($pp.PreserveAllBinaries) {
    $32BitShortcutFilePath = Join-Path -Path $desktopDirectory -ChildPath $32BitShortcutLinkName
    $64BitShortcutFilePath = Join-Path -Path $desktopDirectory -ChildPath $64BitShortcutLinkName

    Install-ChocolateyShortcut -ShortcutFilePath $32BitShortcutFilePath -TargetPath $32BitBinaryFilePath -ErrorAction SilentlyContinue
    Install-ChocolateyShortcut -ShortcutFilePath $64BitShortcutFilePath -TargetPath $64BitBinaryFilePath -ErrorAction SilentlyContinue
  }
  else {
    $shortcutFilePath = Join-Path -Path $desktopDirectory -ChildPath $defaultLinkName
    if ((Get-OSArchitectureWidth -Compare 64) -and ($env:chocolateyForceX86 -ne $true)) {
      $shortcutTargetPath = $64BitBinaryFilePath
    }
    else {
      $shortcutTargetPath = $32BitBinaryFilePath
    }
    
    Install-ChocolateyShortcut -ShortcutFilePath $shortcutFilePath -TargetPath $shortcutTargetPath -ErrorAction SilentlyContinue
  }
}

if (!$pp.NoProgramsShortcut) {
  $programsDirectory = [Environment]::GetFolderPath([Environment+SpecialFolder]::Programs)

  if ($pp.PreserveAllBinaries) {
    $32BitShortcutFilePath = Join-Path -Path $programsDirectory -ChildPath $32BitShortcutLinkName
    $64BitShortcutFilePath = Join-Path -Path $programsDirectory -ChildPath $64BitShortcutLinkName

    Install-ChocolateyShortcut -ShortcutFilePath $32BitShortcutFilePath -TargetPath $32BitBinaryFilePath -ErrorAction SilentlyContinue
    Install-ChocolateyShortcut -ShortcutFilePath $64BitShortcutFilePath -TargetPath $64BitBinaryFilePath -ErrorAction SilentlyContinue
  }
  else {
    $shortcutFilePath = Join-Path -Path $programsDirectory -ChildPath $defaultLinkName
    if ((Get-OSArchitectureWidth -Compare 64) -and ($env:chocolateyForceX86 -ne $true)) {
      $shortcutTargetPath = $64BitBinaryFilePath
    }
    else {
      $shortcutTargetPath = $32BitBinaryFilePath
    }
    
    Install-ChocolateyShortcut -ShortcutFilePath $shortcutFilePath -TargetPath $shortcutTargetPath -ErrorAction SilentlyContinue
  }
}

if (!$pp.PreserveAllBinaries) { 
  #Remove unnecessary binary to prevent disk bloat
  if ((Get-OSArchitectureWidth -Compare 64) -and ($env:chocolateyForceX86 -ne $true)) {
    $deletionTargetPath = $32BitBinaryFilePath
  }
  else {
    $deletionTargetPath = $64BitBinaryFilePath
  }

  Remove-Item -Path $deletionTargetPath -Force -ErrorAction SilentlyContinue
}
