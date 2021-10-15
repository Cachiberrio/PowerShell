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
		if (-not (Test-Path ($RutaMaestra + "\" + $Ficheros.BaseName + ".DELTA")))
            {
            Remove-Item $Ficheros
            }        
        }
}

$RutaModuloTarget    = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client CU15\NavModelTools.ps1'

$FicheroTargetBase   = 'C:\Tipsa\PowerShell\Migracion\Objetos\BC140 CU00.txt'
$FicheroTarget       = 'C:\Tipsa\PowerShell\Migracion\Objetos\BC140 CU15.txt'

$RutaMigracion       = 'C:\Tipsa\PowerShell\Migracion'
$RutaDelta           = 'C:\Tipsa\PowerShell\Migracion\Delta'
$RutaTarget          = 'C:\Tipsa\PowerShell\Migracion\Target'
$RutaResultado       = 'C:\Tipsa\PowerShell\Migracion\Resultado'

$ErrorActionPreference = "Stop"
$HoraComienzo = Get-Date;

CrearDirectorio $RutaTarget
CrearDirectorio $RutaResultado

Import-Module $RutaModuloTarget
cls

echo "1.- Creando objetos versión Target"
Import-Module $RutaModuloTarget
echo "1.1.- Creando objetos versión Target Base"
Split-NAVApplicationObjectFile -Source $FicheroTargetBase -Destination $RutaTarget -Force
echo "1.2.- Creando objetos versión Target"
Split-NAVApplicationObjectFile -Source $FicheroTarget -Destination $RutaTarget -Force

# echo "2.- Borrando Objetos no conflictivos Versión Target"
BorrarNoConflictivos $RutaTarget $RutaDelta

echo "3.- Aplicación de los Delta Files"
Update-NAVApplicationObject -TargetPath $RutaTarget -DeltaPath $RutaDelta -ResultPath $RutaResultado -VersionListProperty FromTarget -ModifiedProperty Yes -DateTimeProperty FromModified -Force

Echo "4.- Creación del fichero de resultados"
Join-NAVApplicationObjectFile -Source ($RutaResultado + "\*.txt") -Destination ($RutaMigracion + "\" + "Resultado.txt") -Force

$HoraFinal = Get-Date;
echo "La migración ha finalizado correctamente."
echo ("Comienzo: " + $HoraComienzo)
echo ("Final   : " + $HoraFinal)
