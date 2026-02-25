# ===== MUTEX (prevent duplicate instances) =====
$mutexName = "Global\{TEST-PERSISTENCE-MUTEX-2026}"
$createdNew = $false

try {
    $mutex = New-Object System.Threading.Mutex($true, $mutexName, [ref]$createdNew)

    if (-not $createdNew) {
        exit
    }
}
catch {
    exit
}

# ===== TEST LOGIC =====

$logPath = "C:\ProgramData\PersistenceTest.log"

# Get identity info
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

$isAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent() `
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

$isSystem = $currentUser -eq "NT AUTHORITY\SYSTEM"

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Build log entry
$logEntry = @"
==============================
Timestamp : $timestamp
User      : $currentUser
Admin     : $isAdmin
SYSTEM    : $isSystem
PID       : $PID
Machine   : $env:COMPUTERNAME
==============================

"@

# Write log
Add-Content -Path $logPath -Value $logEntry

# Optional: create visible marker file
$markerFile = "C:\ProgramData\PersistenceTest-LastRun.txt"
Set-Content -Path $markerFile -Value $timestamp

# Optional: show visible proof (only if interactive session)
try {
    if ($env:SESSIONNAME -notlike "Services") {
        msg * "Persistence Test Script Ran at $timestamp"
    }
}
catch {}

# Keep process alive briefly for observation
Start-Sleep -Seconds 10
