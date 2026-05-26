if ($doNotPublishApps) {
    Write-Host "Not publishing apps, skipping pipeline initialization"
    return
}

$ENV:FKH_BACKEND_URL = "https://fkh-freddydk-backend.azurewebsites.net/api"
$ENV:FKH_TIMEZONE = "Europe/Copenhagen"

dotnet tool install -g fkh

$parts = "$ENV:GITHUB_REPOSITORY".Split('/')
$containerName = "$($parts[0])-$($parts[1])-$($ENV:_Project)-$($ENV:_buildMode)-$($ENV:GITHUB_RUN_ID)".ToLower() -replace "[^a-z0-9\-]"

$adminPassword = GetRandomPassword
$adminUsername = "admin"
$result = fkh createcontainer --name $containerName --artifactUrl $artifact --adminUsername $adminUsername --adminPassword $adminPassword --autostop 6h --useOIDC --asJson
Write-Host "Result: $result"
$info = $result | ConvertFrom-Json
$bcAuthContext = @{
    "username" = $adminUsername
    "password" = ConvertTo-SecureString -String $adminPassword -AsPlainText -Force
}
Set-Variable -Name 'bcAuthContext' -value $bcAuthContext -scope 1
Set-Variable -Name 'environment' -value $info.webClient -scope 1

