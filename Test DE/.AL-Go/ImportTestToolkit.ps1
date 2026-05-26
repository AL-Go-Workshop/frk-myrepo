Param(
    [switch] $includeTestFrameworkOnly,
    [switch] $includeTestLibrariesOnly,
    [switch] $includeTestRunnerOnly,
    [switch] $includePerformanceToolkit
)

. C:\Run\HelperFunctions.ps1
$installApps = GetTestToolkitApps -includeTestFrameworkOnly:$includeTestFrameworkOnly -includeTestLibrariesOnly:$includeTestLibrariesOnly -includeTestRunnerOnly:$includeTestRunnerOnly -includePerformanceToolkit:$includePerformanceToolkit
$installApps | ForEach-Object {
    $appFile = $_
    $navAppInfo = Get-NAVAppInfo -Path $appFile
    $appPublisher = $navAppInfo.Publisher
    $appName = $navAppInfo.Name
    $appVersion = $navAppInfo.Version
    $syncAndInstall = $true
    $tenantAppInfo = Get-NAVAppInfo -ServerInstance $serverInstance -Name $appName -Publisher $appPublisher -Version $appVersion -tenant default -tenantSpecificProperties
    if ($tenantAppInfo) {
        if ($tenantAppInfo.IsInstalled) {
            Write-Host "Skipping $appName as it is already installed"
            $syncAndInstall = $false
        }
        else {
            Write-Host "$appName is already published"
        }
    }
    else {
        Write-Host "Publishing $appFile"
        Publish-NavApp -ServerInstance $ServerInstance -Path $appFile -SkipVerification
    }
    if ($syncAndInstall) {    
        Write-Host "Synchronizing $appName"
        Sync-NavTenant -ServerInstance $ServerInstance -Tenant default -Force
        Sync-NavApp -ServerInstance $ServerInstance -Publisher $appPublisher -Name $appName -Version $appVersion -Tenant default -Mode ForceSync -force -WarningAction Ignore
        Write-Host "Installing $appName"
        Install-NavApp -ServerInstance $ServerInstance -Publisher $appPublisher -Name $appName -Version $appVersion -Tenant default
    }
}
