Param(
    [Hashtable]$parameters
)

if ($doNotPublishApps) {
    return
}

Write-Host "RemoveBcContainer Parameters:"
$parameters | ConvertTo-Json | Out-Host

$parts = "$ENV:GITHUB_REPOSITORY".Split('/')
$containerName = "$($parts[0])-$($parts[1])-$($ENV:_Project)-$($ENV:_buildMode)-$($ENV:GITHUB_RUN_ID)".ToLower() -replace "[^a-z0-9\-]"

fkh RemoveContainer --name $containerName --useOIDC
