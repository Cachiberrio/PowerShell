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

$RutaModuloTarget    = 'C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client CU28\NavModelTools.ps1'

$FicheroOriginalBase = 'C:\Tipsa\PowerShell\Migracion\Objetos\2016 CU00.txt'
$FicheroOriginal     = 'C:\Tipsa\PowerShell\Migracion\Objetos\2016 CU28.txt'
$FicheroTargetBase   = 'C:\Tipsa\PowerShell\Migracion\Objetos\BC140 CU00.txt'
$FicheroTarget       = 'C:\Tipsa\PowerShell\Migracion\Objetos\BC140 CU30.txt'
$FicheroModified     = 'C:\Tipsa\PowerShell\Migracion\Modified.txt'

$RutaMigracion       = 'C:\Tipsa\PowerShell\Migracion\'
$RutaOriginal        = 'C:\Tipsa\PowerShell\Migracion\Original'
$RutaTarget          = 'C:\Tipsa\PowerShell\Migracion\Target'
$RutaModified        = 'C:\Tipsa\PowerShell\Migracion\Modified'
$RutaDelta           = 'C:\Tipsa\PowerShell\Migracion\Delta'
$RutaResultado       = 'C:\Tipsa\PowerShell\Migracion\Resultado'

$ErrorActionPreference = "Stop"
$HoraComienzo = Get-Date;

CrearDirectorio $RutaOriginal
CrearDirectorio $RutaTarget
CrearDirectorio $RutaModified
CrearDirectorio $RutaDelta
CrearDirectorio $RutaResultado

echo "1.- Creando objetos versión original"
Import-Module $RutaModuloTarget
echo "1.1.- Creando objetos versión Base original"
Split-NAVApplicationObjectFile -Source $FicheroOriginalBase -Destination $RutaOriginal -Force
echo "1.2.- Creando objetos versión CU original"
Split-NAVApplicationObjectFile -Source $FicheroOriginal -Destination $RutaOriginal -Force
echo "2.- Creando objetos modificados"
Split-NAVApplicationObjectFile -Source $FicheroModified -Destination $RutaModified -Force

echo "3.- Creando objetos versión Target"
Import-Module $RutaModuloTarget
echo "3.1.- Creando objetos versión Target Base"
Split-NAVApplicationObjectFile -Source $FicheroTargetBase -Destination $RutaTarget -Force
echo "3.2.- Creando objetos versión Target"
Split-NAVApplicationObjectFile -Source $FicheroTarget -Destination $RutaTarget -Force

echo "4.- Borrando Objetos no conflictivos Versión Original"
BorrarNoConflictivos $RutaOriginal $RutaModified

echo "5.- Borrando Objetos no conflictivos Versión Target"
BorrarNoConflictivos $RutaTarget $RutaModified

echo "6.- Obtención de los Delta Files"
Compare-NAVApplicationObject -Original $RutaOriginal -Modified $RutaModified -Delta $RutaDelta -Force

echo "7.- Creando objetos modificados versión target"
Update-NAVApplicationObject -Target $RutaTarget -Delta $RutaDelta -Result $RutaResultado

Echo "8.- Creación del fichero de resultados"
Join-NAVApplicationObjectFile -Source ($RutaResultado + "\*.txt") -Destination ($RutaMigracion + "Resultado.txt") -Force

$HoraFinal = Get-Date;
echo "La migración ha finalizado correctamente."
echo ("Comienzo: " + $HoraComienzo)
echo ("Final   : " + $HoraFinal)