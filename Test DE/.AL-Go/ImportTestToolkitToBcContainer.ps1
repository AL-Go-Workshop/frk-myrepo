Param(
    [Hashtable]$parameters
)

$parameters | ConvertTo-Json | Out-Host

if ($doNotPublishApps) {
    return
}

$parts = "$ENV:GITHUB_REPOSITORY".Split('/')
$containerName = "$($parts[0])-$($parts[1])-CICD-$($ENV:GITHUB_RUN_ID)".ToLower()

Write-Host "-includeTestFrameworkOnly:$($parameters.includeTestFrameworkOnly) -includeTestLibrariesOnly:$($parameters.includeTestLibrariesOnly) -includeTestRunnerOnly:$($parameters.includeTestRunnerOnly) -includePerformanceToolkit:$($parameters.includePerformanceToolkit)"
fkh invokescript --name $containerName --useOIDC --scriptFile (Join-Path $PSScriptRoot "ImportTestToolkit.ps1") --scriptParams "-includeTestFrameworkOnly:$($parameters.includeTestFrameworkOnly) -includeTestLibrariesOnly:$($parameters.includeTestLibrariesOnly) -includeTestRunnerOnly:$($parameters.includeTestRunnerOnly) -includePerformanceToolkit:$($parameters.includePerformanceToolkit)"
