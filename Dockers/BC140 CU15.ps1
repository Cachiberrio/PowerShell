$containerName = 'hpe140cu15'
$credential = Get-Credential -Message 'Using Windows authentication. Please enter your Windows credentials for the host computer.'
$auth = 'Windows'
$artifactUrl = Get-BcArtifactUrl -type 'OnPrem' -version '14.16.44342' -country 'es' -select 'Latest'
$licenseFile = 'c:\users\dr\documents\licencias\tipsa160.flf'
New-BcContainer `
    -accept_eula `
    -containerName $containerName `
    -credential $credential `
    -auth $auth `
    -artifactUrl $artifactUrl `
    -licenseFile $licenseFile `
    -memoryLimit 4G `
    -includeCSIDE `
    -updateHosts