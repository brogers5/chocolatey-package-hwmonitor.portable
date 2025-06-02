## HWMonitor

HWMonitor is a hardware monitoring program that aggregates several data points from from your PC hardware's sensors, and enables easy tracking of current and some historical (minimum and maximum) values, which can optionally be saved for future reference. These can be useful for performance tests, benchmarks, and troubleshooting.

![HWMonitor Screenshot](https://cdn.jsdelivr.net/gh/brogers5/chocolatey-package-hwmonitor.portable@0c383bd73211057e25d93d2f7b2ef193280d3737/Screenshot.png)

### Supported Data Points/Sensors

- Voltages
- Temperatures (configurable as either Celsius or Fahrenheit)
- Fan speeds
- Hardware utilization (available capacity, load, storage space, activity, etc.)
- Power utilization
- Power current
- Clock speeds
- Counters (SMART data, PCIe errors, etc.)
- Battery capacities (design capacity, capacity at full charge, current capacity, etc.)
- Battery levels (load, wear, charge, etc.)
- Performance limits
- Speeds (read/write for storage devices, upload/download for network adapters)

### Supported Hardware Types

- Motherboards
- Central Processing Units (CPU)
- Random-access memory (RAM)
- Graphics Processing Units (GPU)
- Network adapters (physical or virtual)
- Laptop batteries
- Uninterruptible Power Supplies (UPS)

## Package Parameters

|Parameter|Environment Applicability|Script Applicability|Description|
|-|-|-|-|
|`/PreserveAllBinaries`|64-bit only|Install|Opt out of removing the 32-bit binary. Separate shortcuts will be created for both binaries. Not honored for 32-bit package behavior (whether an actual environment or forced with `--forcex86`), as the 64-bit binary should be incompatible.|
|`/NoDefaultShim`|All environments|Install|Opt out of creating the default GUI shim, and removes any existing default shim.|
|`/ShimWithPlatform`|All environments|Install|Creates a second GUI shim with an explicit platform name (i.e. `HWMonitor_x32` and/or `HWMonitor_x64`). Use if you require disambiguation for your commands/scripts.|
|`/NoDesktopShortcut`|All environments|Install|Opt out of creating Desktop shortcut(s).|
|`/NoProgramsShortcut`|All environments|Install|Opt out of creating Programs shortcut(s) in your Start Menu.|
|`/DontPersistSettings`|All environments|Uninstall|Uninstalling the package will normally exclude the generated settings file (`hwmonitorw.ini`) to facilitate easier reinstallation. This switch will include the file during cleanup.|
