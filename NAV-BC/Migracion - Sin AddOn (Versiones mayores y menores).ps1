﻿# Sección a modificar en cada migración 
# =======================================================================================================================

$FicheroOriginal  = 'C:\Tipsa\PowerShell\Migracion\Objetos\BC365 CU00.txt'
$FicheroDestino   = 'C:\Tipsa\PowerShell\Migracion\Objetos\BC365 CU09.txt'

$FicheroCUOrigen  = 'C:\Tipsa\PowerShell\Migracion\Objetos\BC365 CU00.txt'
$FicheroCUDestino = 'C:\Tipsa\PowerShell\Migracion\Objetos\BC365 CU00.txt'

# =======================================================================================================================
$RutaModulo = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\130\RoleTailored Client\NavModelTools.ps1'
$RutaMigracion = 'C:\Tipsa\PowerShell\Migracion\'
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
    Write-Error "No se ha podido localizar el fichero con los objetos Original"
    }

if (-not (Test-Path $FicheroCUDestino))
    {
    Write-Error "No se ha podido localizar el fichero con los objetos CU Destino"
    }

$RutaModified = $RutaMigracion + "Modified"
$RutaOriginal = $RutaMigracion + "Original"
$RutaTarget = $RutaMigracion + "Target"
$RutaResult = $RutaMigracion + "Result"

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

# =======================================================================================================================
# Reseteo de directorios necesarios
# =======================================================================================================================
CrearDirectorio $RutaOriginal
CrearDirectorio $RutaTarget 
CrearDirectorio $RutaResult
CrearDirectorio $RutaModified

CrearVersion $FicheroOriginal $FicheroCUOrigen $RutaOriginal
CrearVersion $FicheroDestino $FicheroCUDestino $RutaTarget
CrearVersion ($RutaMigracion + "Modified.txt") ($RutaMigracion + "Modified.txt") $RutaModified

BorrarNoConflictivos $RutaOriginal $RutaModified
BorrarNoConflictivos $RutaTarget $RutaModified
# =======================================================================================================================
# Merge de los objetos 
# =======================================================================================================================
echo "4.- Merge de los objetos"
Merge-NAVApplicationObject -OriginalPath ($RutaOriginal + "\*.TXT") -TargetPath ($RutaTarget + "\*.TXT") -ModifiedPath ($RutaModified + "\*.TXT") -ResultPath $RutaResult -Force

# =======================================================================================================================
# Creación del fichero de resultados mediante la Join 
# =======================================================================================================================
Echo "5.- Creación del fichero de resultados mediante la Join"
Join-NAVApplicationObjectFile -Source ($RutaResult + "\*.txt") -Destination ($RutaMigracion + "Resultado.txt") -Force

# =======================================================================================================================
# Fin del script 
# =======================================================================================================================
$HoraFinal = Get-Date;
echo "La migración ha finalizado correctamente."
echo ("Comienzo: " + $HoraComienzo)
echo ("Final   : " + $HoraFinal)
