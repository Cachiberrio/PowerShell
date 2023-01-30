$containerName = 'bc18preview'
$credential = Get-Credential -Message 'Using UserPassword authentication. Please enter credentials for the container.'
$auth = 'UserPassword'
$artifactUrl = Get-BcArtifactUrl -storageAccount BcPublicPreview -country 'es' -type 'Sandbox'
$licenseFile = 'C:\Licencia\Tipsa.flf'
New-BcContainer `
    -accept_eula `
    -containerName $containerName `
    -credential $credential `
    -auth $auth `
    -artifactUrl $artifactUrl `
    -multitenant:$false `
    -assignPremiumPlan `
    -licenseFile $licenseFile `
    -dns '8.8.8.8' `
    -memoryLimit 4G `
    -updateHosts