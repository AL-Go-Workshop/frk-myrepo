Param(
    [Hashtable]$parameters
)

if ($doNotPublishApps) {
    return
}

$parts = "$ENV:GITHUB_REPOSITORY".Split('/')
$containerName = "$($parts[0])-$($parts[1])-CICD-$($ENV:GITHUB_RUN_ID)".ToLower()

fkh RemoveContainer --name $containerName
