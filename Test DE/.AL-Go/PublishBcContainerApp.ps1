Param(
    [Hashtable]$parameters
)

if ($doNotPublishApps) {
    return
}

Write-Host "PublishBcContainerApp Parameters:"
$parameters | ConvertTo-Json | Out-Host

$parts = "$ENV:GITHUB_REPOSITORY".Split('/')
$containerName = "$($parts[0])-$($parts[1])-CICD-$($ENV:GITHUB_RUN_ID)".ToLower()

fkh WaitForContainer --name $containerName --useOIDC
fkh PublishApp --name $containerName --appFile $parameters.appFile --syncMode $parameters.syncMode --sync --install --useOIDC

