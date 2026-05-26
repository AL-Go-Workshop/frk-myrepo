Param(
    [Hashtable]$parameters
)

$parameters | ConvertTo-Json | Out-Host

if ($doNotPublishApps) {
    return
}

# Publish Test Toolkit apps to the container

return
