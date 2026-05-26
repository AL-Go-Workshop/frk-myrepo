if ($doNotPublishApps) {
    return
}

$parts = "$ENV:GITHUB_REPOSITORY".Split('/')
$containerName = "$($parts[0])-$($parts[1])-$($ENV:_project)-$($ENV:_buildMode)-$($ENV:GITHUB_RUN_ID)".ToLower() -replace "[^a-z0-9\-]"

fkh RemoveContainer --name $containerName --useOIDC
