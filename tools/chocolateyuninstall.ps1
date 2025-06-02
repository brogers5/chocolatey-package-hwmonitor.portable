$ErrorActionPreference = 'Stop'

$unzipLocation = Join-Path -Path (Get-ToolsLocation) -ChildPath $env:ChocolateyPackageName
$pp = Get-PackageParameters

$excludeItems = [System.Collections.ArrayList]::new()
if (!$pp.DontPersistSettings) {
    $excludeItems.Add('hwmonitorw.ini')
}
Remove-Item -Path $unzipLocation -Exclude $excludeItems -Recurse -Force -ErrorAction SilentlyContinue

$programsDirectory = [Environment]::GetFolderPath([Environment+SpecialFolder]::Programs)
$desktopDirectory = [Environment]::GetFolderPath([Environment+SpecialFolder]::DesktopDirectory)
$directories = @($programsDirectory, $desktopDirectory)

$linkName = 'HWMonitor.lnk'
$32BitLinkName = 'HWMonitor (32-bit).lnk'
$64BitLinkName = 'HWMonitor (64-bit).lnk'
$shortcutNames = @($linkName, $32BitLinkName, $64BitLinkName)

$shortcutPaths = [System.Collections.ArrayList]::new()
foreach ($directory in $directories) {
    foreach ($shortcutName in $shortcutNames) {
        $possibleShortcutPath = Join-Path -Path $directory -ChildPath $shortcutName
        if (Test-Path -Path $possibleShortcutPath) {
            $shortcutPaths.Add($possibleShortcutPath) | Write-Debug
        }
    }
}

foreach ($shortcutPath in $shortcutPaths) {
    if (Test-Path -Path $shortcutPath) {
        Remove-Item -Path $shortcutPath -Force -ErrorAction SilentlyContinue
    }
}

Uninstall-BinFile -Name 'HWMonitor'
Uninstall-BinFile -Name 'HWMonitor_x32'
Uninstall-BinFile -Name 'HWMonitor_x64'
