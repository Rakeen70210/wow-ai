$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
Add-Type @'
using System;
using System.Runtime.InteropServices;
public class ProbeWin {
 [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
 [DllImport("user32.dll")] public static extern bool ClientToScreen(IntPtr h, ref POINT p);
 [StructLayout(LayoutKind.Sequential)] public struct POINT { public int X; public int Y; }
}
'@
[void][ProbeWin]::SetProcessDPIAware()
$p = Get-Process Wow | Where-Object { $_.MainWindowHandle -ne 0 } | Select-Object -First 1
$pt = New-Object ProbeWin+POINT
[void][ProbeWin]::ClientToScreen($p.MainWindowHandle, [ref]$pt)
$b = New-Object System.Drawing.Bitmap 1000, 240
$g = [System.Drawing.Graphics]::FromImage($b)
$g.CopyFromScreen($pt.X, $pt.Y, 0, 0, $b.Size)
$g.Dispose()
$b.Save((Join-Path $PSScriptRoot 'probe-windows.png'))
$b.Dispose()
Write-Output "Captured top-left of WoW client at $($pt.X),$($pt.Y)"
