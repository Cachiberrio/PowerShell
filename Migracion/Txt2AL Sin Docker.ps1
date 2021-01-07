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
Function EjecutarConversion {
    $ErrorActionPreference = "Stop"
    $HoraComienzo = Get-Date;

    $RutaRTCCOrigen      = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\'+ $VersionOrigen + '\RoleTailored Client CU' + $CUOrigen + '\'
    $RutaModuloTarget    = $RutaRTCCOrigen + 'NavModelTools.ps1'
    $RutaTxt2AL          = $RutaRTCCOrigen + 'txt2al.exe'

    $FicheroOriginalBase = 'C:\Tipsa\PowerShell\Migracion\Objetos\BC' + $VersionOrigen + ' CU00.txt'
    $FicheroOriginal     = 'C:\Tipsa\PowerShell\Migracion\Objetos\BC' + $VersionOrigen + ' CU' + $CUOrigen + '.txt'

    $FicheroModified     = 'C:\Tipsa\PowerShell\Txt2AL\Modified.txt'

    $RutaMigracion       = 'C:\Tipsa\PowerShell\Txt2AL\'
    $RutaOriginal        = $RutaMigracion + 'Original'
    $RutaModified        = $RutaMigracion + 'Modified'
    $RutaDelta           = $RutaMigracion + 'Delta'
    $RutaResult          = $RutaMigracion + 'Result'

    CrearDirectorio $RutaOriginal
    CrearDirectorio $RutaModified
    CrearDirectorio $RutaDelta
    CrearDirectorio $RutaResult

    echo "1.- Creando objetos versión original"
    Import-Module $RutaModuloTarget
    echo "1.1.- Creando objetos versión Base original"
    Split-NAVApplicationObjectFile -Source $FicheroOriginalBase -Destination $RutaOriginal -Force
    echo "1.2.- Creando objetos versión CU original"
    Split-NAVApplicationObjectFile -Source $FicheroOriginal -Destination $RutaOriginal -Force

    echo "2.- Creando objetos modificados"
    Split-NAVApplicationObjectFile -Source $FicheroModified -Destination $RutaModified -Force

    echo "3.- Borrando Objetos no conflictivos Versión Original"
    BorrarNoConflictivos $RutaOriginal $RutaModified

    echo "4.- Obtención de los Delta Files"
    Compare-NAVApplicationObject -Original $RutaOriginal -Modified $RutaModified -Delta $RutaDelta -Force

    echo "5.- Generando ficheros .AL"
    $ParametrosTxt2AL = ' --source ' + $RutaDelta + ' --target ' +  $RutaResult + ' --rename '
    Start-Process -FilePath $RutaTxt2AL -argumentlist  $ParametrosTxt2AL -wait

    $HoraFinal = Get-Date;
    echo "La migración ha finalizado correctamente."
    echo ("Comienzo: " + $HoraComienzo)
    echo ("Final   : " + $HoraFinal)
}

# El fichero Modified.txt debe estar en C:\Tipsa\PowerShell\Txt2AL\Modified.txt

$VersionOrigen = '140'
$CUOrigen      = '08'

EjecutarConversion