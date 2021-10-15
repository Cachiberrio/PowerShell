Function CrearDirectorio{
    Param([string]$RutaReferencia)
    Write-Output ("Creando directorio " + $RutaReferencia)
    if (Test-Path $RutaReferencia)
        {
        Remove-Item ($RutaReferencia) -Recurse | out-null
        }
    New-Item -Path $RutaReferencia -ItemType "directory" | out-null
}
Function BorrarNoConflictivos{
    Param([string]$RutaReferencia,[string]$RutaMaestra)
    Write-Output ("Borrando objetos no conflictivos " + $RutaReferencia)
    $Ficheros = (Get-Item ($RutaReferencia + "\*.*"))
    foreach ($Ficheros in $Ficheros)
        {
        if (-not (Test-Path ($RutaMaestra + "\" + $Ficheros.Name)))
            {
            Remove-Item $Ficheros
            }
        }
}
Function CopiarFicherosDesdeNewSyntaxAOriginal{
    Param([string]$RutaNewSyntax,[string]$RutaOriginal,[string]$RutaModified)
    Write-Output ("Copiando " + $RutaReferencia)
    $Ficheros = (Get-Item ($RutaModified + "\*.*"))
    foreach ($Ficheros in $Ficheros)
        {
        if (Test-Path ($RutaNewSyntax + "\" + $Ficheros.Name))
            {
            Copy-Item ($RutaNewSyntax + "\" + $Ficheros.Name) $RutaOriginal
            }
        }
}
Function EjecutarTxt2al{
    Param([string]$RutaTxt2AL,[string]$RutaDelta,[string]$RutaResult)
    $ParametrosTxt2AL = ' --source ' + $RutaDelta + ' --target ' +  $RutaResult + ' --rename '
    Start-Process -FilePath $RutaTxt2AL -argumentlist  $ParametrosTxt2AL -wait
}
Function CrearDocker {
    param ([string] $ImageName,[string]$RutaLicencia,[String]$NombreContenedor)

new-navcontainer -accept_eula -containerName $NombreContenedor -imageName $ImageName  -includeCSide -useBestContainerOS -updateHosts -licenseFile $RutaLicencia -doNotCheckHealth -alwaysPull -accept_outdated -shortcuts Desktop -isolation hyperv
}

# Variables a rellenar ==============================================================================
$VersionBase = "14"
$CU = "1"
$CrearNuevoDocker = $true
# ===================================================================================================

$ErrorActionPreference = "Stop"
$HoraComienzo = Get-Date;

Clear-Host


$RutaModuloOriginal = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client CU08\NavModelTools.ps1'
$RutaTxt2AL         = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client CU08\txt2al.exe'
$RutaLicencia       = "C:\Tipsa\PowerShell\Scripts\EntornoConsultores\TIPSA160.flf"

if (-not (Test-Path $RutaLicencia))
{
    Write-Error "Fichero de licencia no localizado."
}
    
Write-Host "1.1.- Creando Docker Versión " $VersionBase " - " $CU
$NombreContenedor   = "BC" + $VersionBase + "CU" + $CU
$imageName = "mcr.microsoft.com/businesscentral/onprem"
$ImageBCName = (Get-NavContainerImageTags -imageName $imageName).Tags | Where-Object { ($_.contains($VersionBase + "." + $CU + ".")) -and ($_.contains("es-ltsc2019")) }

IF (($ImageBCName.count) -gt 1)
    {
    $ImageBCName = $ImageBCName[($ImageBCName.count-1)]
    }

$partes = $ImageBCName.split(".")
$len = $partes[3].Length
$CodVersion = $partes[2]+"."+$partes[3].Substring(0,$len-12)
$imageName = "mcr.microsoft.com/businesscentral/onprem" + ":" + $ImageBCName

if ($CrearNuevoDocker)
    {
    CrearDocker $ImageName $RutaLicencia $NombreContenedor
    }

$RutaCompartidaOrig = "C:\ProgramData\NavContainerHelper\Extensions" + "\Original-"+$VersionBase+"."+$CU+"."+$CodVersion+"-es"
$RutaCompartidaNewSyntax = "C:\ProgramData\NavContainerHelper\Extensions" + "\Original-"+$VersionBase+"."+$CU+"."+$CodVersion+"-es-newsyntax"
Write-Output "La ruta compartida es:"
$RutaCompartidaorig
$RutaCompartidaNewSyntax

Write-Output "2.1.- Creando directorios"
$Ruta = $PSScriptRoot

$RutaModified = '' + $Ruta + '\Modified'
CrearDirectorio $RutaModified

$RutaDelta = '' + $Ruta + '\Delta'
CrearDirectorio $RutaDelta

$RutaOriginal = '' + $Ruta + '\Original\'
CrearDirectorio $RutaOriginal

$RutaResult = '' + $Ruta + '\Result'
CrearDirectorio $RutaResult

Write-Output "2.2.- Importación del módulo "
Import-Module $RutaModuloOriginal

Write-Output "2.4.- Creando objetos versión Modified"
$FicheroModified = '' + $Ruta + '\Modified.txt'
Split-NAVApplicationObjectFile -Source $FicheroModified -Destination $RutaModified -Force

Write-Output "2.5.- Copiando objetos desde NewSyntax"
CopiarFicherosDesdeNewSyntaxAOriginal $RutaCompartidaNewSyntax $RutaOriginal $RutaModified

Write-Output "2.6.- Obtención de los Delta Files"
Compare-NAVApplicationObject -OriginalPath ($RutaOriginal + "\*.TXT") -ModifiedPath ($RutaModified + "\*.TXT") -DeltaPath $RutaDelta -Force -ExportToNewSyntax

Write-Output "2.7.- Creación de AL Files"
EjecutarTxt2AL $RutaTxt2AL $RutaDelta $RutaResult

$HoraFinal = Get-Date;
Write-Output "La conversión ha finalizado correctamente."
Write-Output ("Comienzo: " + $HoraComienzo)
Write-Output ("Final   : " + $HoraFinal)