Function CrearDirectorio{
    Param([string]$RutaReferencia)
    echo ("Creando directorio " + $RutaReferencia)
    if (Test-Path $RutaReferencia) 
        {
        Remove-Item ($RutaReferencia) -Recurse | out-null
        }
    New-Item -Path $RutaReferencia -ItemType "directory" | out-null
}
Function CrearVersion{
    Param([string]$FicheroCU00,[string]$FicheroCU,[string]$RutaDestino)
    echo ("Creando versión " + $RutaDestino)
    Split-NAVApplicationObjectFile -Source $FicheroCU00 -Destination $RutaDestino -Force
    if ((test-path $FicheroCU) -and (-not($FicheroCU -eq $FicheroCU00)))
        {
        Split-NAVApplicationObjectFile -Source $FicheroCU -Destination $RutaDestino -Force
        }
}
Function BorrarNoConflictivos{
    Param([string]$RutaReferencia,[string]$RutaMaestra)
    Echo ("Borrando objetos no conflictivos " + $RutaReferencia)
    $Ficheros = (Get-Item ($RutaReferencia + "\*.*"))
    foreach ($Ficheros in $Ficheros)
        {
        if (-not (Test-Path ($RutaMaestra + "\" + $Ficheros.Name)))
            {
            Remove-Item $Ficheros
            }
        }
}

# Sección a modificar en cada migración 
# =======================================================================================================================

$FicheroOriginal  = 'C:\Tipsa\PowerShell\Migracion\Objetos\2016 CU00.txt'
$FicheroDestino   = 'C:\Tipsa\PowerShell\Migracion\Objetos\2016 CU00.txt'

$FicheroCUOrigen  = 'C:\Tipsa\PowerShell\Migracion\Objetos\2016 CU61.txt'
$FicheroCUDestino = 'C:\Tipsa\PowerShell\Migracion\Objetos\2016 CU62.txt'

$FicheroObjects   =  'C:\Compartida\PowerShell\Objects.txt'
# =======================================================================================================================
$FolderName = Get-Date -Format "yyyyMMdd-HHmmss"
# $RutaModulo = 'C:\Program Files (x86)\Microsoft Dynamics NAV\80\RoleTailored Client\NavModelTools.ps1'
$RutaModulo = 'C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client CU60\NavModelTools.ps1'
# $RutaModulo = 'C:\Program Files (x86)\Microsoft Dynamics NAV\100\RoleTailored Client\NavModelTools.ps1'
# $RutaModulo = 'C:\Program Files (x86)\Microsoft Dynamics NAV\110\RoleTailored Client\NavModelTools.ps1'
# $RutaModulo = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\130\RoleTailored Client\NavModelTools.ps1'
# $RutaModulo = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client\NavModelTools.ps1'

$RutaMigracion = 'C:\Compartida\PowerShell\' + $FolderName + '\'
# =======================================================================================================================
$ErrorActionPreference = "Stop"
$HoraComienzo = Get-Date;
Import-Module $RutaModulo
Clear

# =======================================================================================================================
# Comprobación de rutas necesarias 
# =======================================================================================================================
if (-not (Test-Path $FicheroOriginal))
    {
    Write-Error "No se ha podido localizar el fichero con los objetos Original"
    }

if (-not (Test-Path $FicheroCUOrigen))
    {
    Write-Error "No se ha podido localizar el fichero con los objetos CU Origen"
    }

if (-not (Test-Path $FicheroDestino))
    {
    Write-Error "No se ha podido localizar el fichero con los objetos Destino"
    }

if (-not (Test-Path $FicheroCUDestino))
    {
    Write-Error "No se ha podido localizar el fichero con los objetos CU Destino"
    }

if (-not (Test-Path $FicheroObjects))
    {
    Write-Error "No se ha podido localizar el fichero con los objetos a evaluar"
    }

$RutaOriginal = $RutaMigracion + "Original"
$RutaTarget = $RutaMigracion + "Target"
$RutaObjects = $RutaMigracion + "Objects"
# =======================================================================================================================
# Reseteo de directorios necesarios
# =======================================================================================================================
CrearDirectorio $RutaOriginal
CrearDirectorio $RutaTarget 
CrearDirectorio $RutaObjects

CrearVersion $FicheroOriginal $FicheroCUOrigen $RutaOriginal
CrearVersion $FicheroDestino $FicheroCUDestino $RutaTarget
Split-NAVApplicationObjectFile -Source $FicheroObjects -Destination $RutaObjects

BorrarNoConflictivos $RutaOriginal $RutaObjects
BorrarNoConflictivos $RutaTarget $RutaObjects

# =======================================================================================================================
# Fin del script 
# =======================================================================================================================
$HoraFinal = Get-Date;
echo "La migración ha finalizado correctamente."
echo ("Comienzo: " + $HoraComienzo)
echo ("Final   : " + $HoraFinal)
