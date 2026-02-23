New-Item -Path "C:\temp" -ItemType Directory -Force
Add-Content -Path "C:\temp\wmi_test.txt" -Value "WMI persistence executed at $(Get-Date)"