Param(
    [string] $project,
    [string] $buildMode,
    [bool] $buildIt
)

# AL-Go Hook

if (-not $buildIt) {
    Write-Host "BuildIt is false, no need to copy fkh scripts"
    return
}

$ENV:FKH_BACKEND_URL = "https://fkh-freddydk-backend.azurewebsites.net/api"
$ENV:FKH_TIMEZONE = "Europe/Copenhagen"

Write-Host "Install Freddy's Kubernetes Helper & Business Central Development Tools"
dotnet tool install -g fkh
dotnet tool install -g Microsoft.Dynamics.BusinessCentral.Development.Tools

fkh downloadALGoScripts
