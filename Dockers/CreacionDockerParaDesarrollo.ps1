Function CrearDocker{
    $ErrorActionPreference = "Stop"
    $HoraComienzo = Get-Date;

    Clear-Host
    Write-Host "Creando Docker Versión " $VersionBase " - " $CU
    $NombreContenedor   = "BC" + $VersionBase + "CU" + $CU
    $imageName          = "mcr.microsoft.com/businesscentral/onprem"
    $ImageBCName        = (Get-NavContainerImageTags -imageName $imageName).Tags | Where-Object { ($_.contains($VersionBase + "." + $CU + ".")) -and ($_.contains("es-ltsc2019")) }
    $RutaLicencia       = "C:\Tipsa\Licencia\Microsoft Dynamics NAV Perpetual.flf"

    if (-not (Test-Path $RutaLicencia))
        {
        Write-Error "Fichero de licencia no localizado."    
        }

    IF (($ImageBCName.count) -gt 1)
        {
        $ImageBCName = $ImageBCName[($ImageBCName.count-1)]
        }

    $partes = $ImageBCName.split(".")
    $len = $partes[3].Length
    $CodVersion = $partes[2]+"."+$partes[3].Substring(0,$len-12)
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
                         -includeCSide
        }

}

$VersionBase = "14"
$CU = "9"
$CrearNuevoDocker = $true

CrearDocker
