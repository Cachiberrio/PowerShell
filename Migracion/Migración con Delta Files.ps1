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

$RutaModuloOriginal = 'C:\Program Files (x86)\Microsoft Dynamics NAV\71\RoleTailored Client CU51\NavModelTools.ps1'
$RutaModuloTarget   = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\130\RoleTailored Client CU05\NavModelTools.ps1'

$FicheroOriginal    = 'C:\Tipsa\PowerShell\Migracion\Objetos\2009 CU00.txt'
$FicheroTargetBase  = 'C:\Tipsa\PowerShell\Migracion\Objetos\BC365 CU00.txt'
$FicheroTarget      = 'C:\Tipsa\PowerShell\Migracion\Objetos\BC365 CU05.txt'
$FicheroModified    = 'C:\Tipsa\PowerShell\Migracion\Modified.txt'

$RutaMigracion      = 'C:\Tipsa\PowerShell\Migracion\'
$RutaOriginal       = 'C:\Tipsa\PowerShell\Migracion\Original'
$RutaTarget         = 'C:\Tipsa\PowerShell\Migracion\Target'
$RutaModified       = 'C:\Tipsa\PowerShell\Migracion\Modified'
$RutaDelta          = 'C:\Tipsa\PowerShell\Migracion\Delta'
$RutaResultado      = 'C:\Tipsa\PowerShell\Migracion\Resultado'

$ErrorActionPreference = "Stop"
$HoraComienzo = Get-Date;

CrearDirectorio $RutaOriginal
CrearDirectorio $RutaTarget
CrearDirectorio $RutaModified
CrearDirectorio $RutaDelta
CrearDirectorio $RutaResultado

Import-Module $RutaModuloOriginal
echo "1.- Creando objetos versión original"
Split-NAVApplicationObjectFile -Source $FicheroOriginal -Destination $RutaOriginal -Force

echo "2.- Creando objetos modificados"
Split-NAVApplicationObjectFile -Source $FicheroModified -Destination $RutaModified -Force

echo "3.- Borrando Objetos no conflictivos Versión Original"
BorrarNoConflictivos $RutaOriginal $RutaModified

echo "4.- Obtención de los Delta Files"
Compare-NAVApplicationObject -OriginalPath ($RutaOriginal + "\*.TXT") -ModifiedPath ($RutaModified + "\*.TXT") -DeltaPath $RutaDelta -Force

Import-Module $RutaModuloTarget

echo "5.1.- Creando objetos versión Target"
Split-NAVApplicationObjectFile -Source $FicheroTargetBase -Destination $RutaTarget -Force

echo "5.2.- Creando objetos versión Target"
Split-NAVApplicationObjectFile -Source $FicheroTarget -Destination $RutaTarget -Force

echo "6.- Borrando Objetos no conflictivos Versión Target"
BorrarNoConflictivos $RutaTarget $RutaModified

echo "7.- Creando objetos modificados versión target"
Update-NAVApplicationObject -TargetPath $RutaTarget -DeltaPath $RutaDelta -ResultPath $RutaResultado

Echo "8.- Creación del fichero de resultados"
Join-NAVApplicationObjectFile -Source ($RutaResultado + "\*.txt") -Destination ($RutaMigracion + "Resultado.txt") -Force

$HoraFinal = Get-Date;
echo "La migración ha finalizado correctamente."
echo ("Comienzo: " + $HoraComienzo)
echo ("Final   : " + $HoraFinal)