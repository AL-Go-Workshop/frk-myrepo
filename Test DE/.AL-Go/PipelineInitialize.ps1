if ($doNotPublishApps) {
    Write-Host "Not publishing apps, skipping pipeline initialization"
    return
}

$ENV:FKH_BACKEND_URL = "https://fkh-freddydk-backend.azurewebsites.net/api"
$ENV:FKH_TIMEZONE = "Europe/Copenhagen"

dotnet tool install -g fkh

$parts = "$ENV:GITHUB_REPOSITORY".Split('/')
$containerName = "$($parts[0])-$($parts[1])-CICD-$($ENV:GITHUB_RUN_ID)".ToLower()

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
Set-Variable -Name 'environment' -value ($info | ConvertFrom-Json).webclient -scope 1

