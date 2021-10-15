Function CrearDirectorio{
    Param([string]$RutaReferencia)
    echo ("Creando directorio " + $RutaReferencia)
    if (Test-Path $RutaReferencia) 
        {
        Remove-Item ($RutaReferencia) -Recurse | out-null
        }
    New-Item -Path $RutaReferencia -ItemType "directory" | out-null
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

$FicheroTargetBase  = 'C:\Tipsa\PowerShell\Migracion\Objetos\BC365 CU00.txt'
$FicheroTarget      = 'C:\Tipsa\PowerShell\Migracion\Objetos\BC365 CU00.txt'
$RutaModuloTarget   = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\130\RoleTailored Client CU05\NavModelTools.ps1'

$RutaMigracion      = 'C:\Tipsa\PowerShell\Migracion\'
$RutaOriginal       = 'C:\Tipsa\PowerShell\Migracion\Original'
$RutaTarget         = 'C:\Tipsa\PowerShell\Migracion\Target'
$RutaModified       = 'C:\Tipsa\PowerShell\Migracion\Modified'
$RutaDelta          = 'C:\Tipsa\PowerShell\Migracion\Delta'
$RutaResultado      = 'C:\Tipsa\PowerShell\Migracion\Resultado'

$ErrorActionPreference = "Stop"
$HoraComienzo = Get-Date;

CrearDirectorio $RutaTarget
CrearDirectorio $RutaDelta
CrearDirectorio $RutaResultado

cls
echo "1.- Borrando Objetos no conflictivos Versión Original"
BorrarNoConflictivos $RutaOriginal $RutaModified

Import-Module $RutaModuloTarget

echo "2.- Obtención de los Delta Files"
Compare-NAVApplicationObject -Original $RutaOriginal -Modified $RutaModified -Delta $RutaDelta -Force
# Compare-NAVApplicationObject -DeltaPath $RutaDelta -OriginalPath $RutaOriginal -ModifiedPath $RutaModified

echo "3.1.- Creando objetos versión Target Base"
Split-NAVApplicationObjectFile -Source $FicheroTargetBase -Destination $RutaTarget -Force

echo "3.2.- Creando objetos versión Target"
Split-NAVApplicationObjectFile -Source $FicheroTarget -Destination $RutaTarget -Force

echo "4.- Borrando Objetos no conflictivos Versión Target"
BorrarNoConflictivos $RutaTarget $RutaModified

echo "5.- Creando objetos modificados versión target"
Update-NAVApplicationObject -Target $RutaTarget -Delta $RutaDelta -Result $RutaResultado

Echo "6.- Creación del fichero de resultados"
Join-NAVApplicationObjectFile -Source ($RutaResultado + "\*.txt") -Destination ($RutaMigracion + "Resultado.txt") -Force

$HoraFinal = Get-Date;
echo "La migración ha finalizado correctamente."
echo ("Comienzo: " + $HoraComienzo)
echo ("Final   : " + $HoraFinal)