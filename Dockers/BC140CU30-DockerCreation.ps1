Function ImportObjects {
    $ModulePath       = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client CU30\Microsoft.Dynamics.Nav.Model.Tools.psd1'
    $VersionList      = 'PTV'
    $RepositoryFolder = 'C:\Users\am\Documents\Repositorios\Gitea\' + $VersionList
    $ResultFile       = 'C:\Compartida\FOB\Resultado..txt'
    Import-Module $ModulePath -verbose
    Join-NAVApplicationObjectFile -Source ($RepositoryFolder + '\*.txt') `
                                  -Destination ($ResultFile) -Force
    Import-NAVApplicationObject -DatabaseName $DBName `
                                -DatabaseServer $DBServer `
                                -path $FicheroObjetos `
                                -username 'admin' `
                                -password 'P@ssw0rd' `
                                -Force
}

Install-Module BcContainerHelper -force
Get-InstalledModule

$containerName = 'bc140cu30'
$password = 'P@ssw0rd'
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object pscredential 'admin', $securePassword
$auth = 'UserPassword'
$artifactUrl = Get-BcArtifactUrl -type 'OnPrem' -version '14.30' -country 'es' -select 'Latest'
$licenseFile = 'c:\Licencia\Microsoft Dynamics NAV Perpetual.flf'
New-BcContainer `
    -accept_eula `
    -containerName $containerName `
    -credential $credential `
    -auth $auth `
    -artifactUrl $artifactUrl `
    -imageName 'img-bc140cu30' `
    -licenseFile $licenseFile `
    -includeCSIDE `
    -updateHosts

# ImportObjects