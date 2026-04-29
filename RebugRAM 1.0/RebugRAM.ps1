if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

$targetApps = @("msedge", "chrome", "SearchHost", "ShellExperienceHost", "GameBarPresenceWriter", "CompPkgSrv", "YourPhone", "Cortana", "TextInputHost")

while ($true) {
    Clear-Host
    Write-Host "==============================" -ForegroundColor Cyan
    Write-Host "      REBUG RAM BOOSTER       " -ForegroundColor White -BackgroundColor Blue
    Write-Host "==============================" -ForegroundColor Cyan
    Write-Host "1. Clean Your Ram"
    Write-Host "2. Force Stop Cleaning"
    Write-Host "3. View Useless Processes"
    Write-Host "4. Exit"
    
    $choice = Read-Host "`nSelect an option"

    switch ($choice) {
        "1" {
            foreach ($a in $targetApps) { 
                Stop-Process -Name $a -Force -ErrorAction SilentlyContinue 
            }
            [System.GC]::Collect()
            Write-Host "RAM Cleaned!" -ForegroundColor Green
            Start-Sleep -Seconds 2
        }
        "2" {
            Start-Process "explorer.exe" -ErrorAction SilentlyContinue
            Write-Host "System refreshed." -ForegroundColor Green
            Start-Sleep -Seconds 2
        }
        "3" {
            Write-Host "`n--- Active Useless Processes ---" -ForegroundColor Cyan
            $found = Get-Process | Where-Object { $targetApps -contains $_.Name }
            if ($found) {
                $found | Select-Object Name, @{Name="RAM(MB)";Expression={[math]::round($_.WorkingSet64 / 1MB, 2)}}
            } else {
                Write-Host "No useless processes running!" -ForegroundColor Green
            }
            Read-Host "`nPress Enter to return to menu"
        }
        "4" { exit }
    }
}
