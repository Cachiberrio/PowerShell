Function CrearDocker {
    $VersionCompleta = $VersionBase + '.' + $CU
    If ($VersionBase -gt "14") {
            CrearDockerBC
        }
        else {
            CrearDockerNAV
        }
}
Function CrearDockerNAV{
    # Crea un contenedor a partir de la impagen de mcr.microsoft.com/businesscentral/onprem y la guarda una para poder reutilizar
    # Instalación onPrem
    $ErrorActionPreference = "Stop"
    
    Clear-Host
    Write-Host "Creando Docker Versión " $VersionBase " - " $CU
    $NombreContenedor   = "BC" + $VersionBase + "CU" + $CU
    $imageName          = "mcr.microsoft.com/businesscentral/onprem"
    $ImageBCName        = (Get-NavContainerImageTags -imageName $imageName).Tags | Where-Object { ($_.contains($VersionBase + "." + $CU + ".")) -and ($_.contains("es-ltsc2019")) }
    $RutaLicencia       = "C:\Tipsa\PowerShell\Scripts\EntornoConsultores\TIPSA160.flf"

    if (-not (Test-Path $RutaLicencia))
        {
        Write-Error "Fichero de licencia no localizado."    
        }

    IF (($ImageBCName.count) -gt 1)
        {
        $ImageBCName = $ImageBCName[($ImageBCName.count-1)]
        }

    $imageName = "mcr.microsoft.com/businesscentral/onprem" + ":" + $ImageBCName

    $User = "admin"
    $passwordtxt = "P@ssw0rd"
    $password = ConvertTo-SecureString -String $passwordtxt -AsPlainText -Force
    $credential = New-Object PSCredential $User, $password


    if ($CrearNuevoDocker)
        {
        new-navcontainer -accept_eula `
                         -containerName $NombreContenedor `
                         -imageName $ImageName  `
                         -useBestContainerOS `
                         -updateHosts `
                         -licenseFile $RutaLicencia `
                         -doNotCheckHealth `
                         -alwaysPull `
                         -accept_outdated `
                         -shortcuts Desktop `
                         -includeTestToolkit `
                         -includeTestLibrariesOnly `
                         -auth UserPassword `
                         -credential $credential `
                         -isolation hyperv `
                         -includeCSIDE  `
                         
        }

}
Function CrearDockerBC {
# Crea un contenedor con artifacts y guarda una imagen para poder reutilizar
# Instalación onPrem
import-module BcContainerHelper
$containerName = "BC" + $VersionBase + "CU" + $CU
$NombreImagen = 'imagen'
$password = 'P@ssw0rd'
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object pscredential 'admin', $securePassword
$auth = 'UserPassword'
$artifactUrl = Get-BcArtifactUrl -type 'OnPrem' -version $VersionCompleta -country 'es' -select 'Latest'
$RutaLicencia = "C:\Tipsa\PowerShell\Scripts\EntornoConsultores\TIPSA160.flf"
$includeTestToolkit = $true
$includeTestLibrariesOnly = $true
New-BcContainer `
    -accept_eula `
    -containerName $containerName `
    -credential $credential `
    -auth $auth `
    -artifactUrl $artifactUrl `
    -imageName $NombreImagen `
    -isolation 'hyperv' `
    -includeTestToolkit:$includeTestToolkit `
    -includeTestLibrariesOnly:$includeTestLibrariesOnly `
    -licenseFile $RutaLicencia `
    -updateHosts
}

$VersionBase = "14"
$CU = "15"
$CrearNuevoDocker = $true
CrearDocker