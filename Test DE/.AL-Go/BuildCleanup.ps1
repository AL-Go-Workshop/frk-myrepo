Param(
    [Hashtable] $parameters
)

# AL-Go Hook

$project = $parameters.project
$buildMode = $parameters.buildMode
$buildIt = $parameters.buildIt

if (-not $buildIt) {
    Write-Host "BuildIt is false, no need to remove container"
    return
}

$ENV:FKH_BACKEND_URL = "https://fkh-freddydk-backend.azurewebsites.net/api"
$ENV:FKH_TIMEZONE = "Europe/Copenhagen"

$parts = "$ENV:GITHUB_REPOSITORY". Split('/')
$containerName = "$($parts[0])-$($parts[1])-$($project)-$($buildMode)-$($ENV:GITHUB_RUN_ID)".ToLower() -replace "[^a-z0-9\-]"

fkh RemoveContainer --name $containerName --useOIDC
