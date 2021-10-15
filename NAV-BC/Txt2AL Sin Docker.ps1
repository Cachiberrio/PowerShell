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
    $RutaModuloTarget    = $RutaRTCCOrigen + 'Nav.Model.Tools.psd1'
    $RutaTxt2AL          = $RutaRTCCOrigen + 'txt2al.exe'

    $FicheroOriginalBase = 'C:\Tipsa\PowerShell\Migracion\Objetos\BC' + $VersionOrigen + ' CU00.txt'
    $FicheroOriginal     = 'C:\Tipsa\PowerShell\Migracion\Objetos\BC' + $VersionOrigen + ' CU' + $CUOrigen + '.txt'
    $FicheroOriginalBase = 'C:\Tipsa\PowerShell\Txt2AL\CRONUS140CU09.txt'

    $FicheroModified     = 'C:\Tipsa\PowerShell\Txt2AL\Modified.txt'

    $RutaMigracion       = 'C:\Tipsa\PowerShell\Txt2AL\'
    $RutaOriginal        = $RutaMigracion + 'Original'
    $RutaModified        = $RutaMigracion + 'Modified'
    $RutaDelta           = $RutaMigracion + 'Delta'
    $RutaResult          = $RutaMigracion + 'Result'
    $FiltroVersionList   = 'Version List=@*' + $VersionList + '*'

    CrearDirectorio $RutaOriginal
    CrearDirectorio $RutaModified
    CrearDirectorio $RutaDelta
    CrearDirectorio $RutaResult

    echo "1.- Creando objetos versión original"
    Import-Module "C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client CU08\Microsoft.Dynamics.Nav.Model.Tools.psd1" -verbose
    Split-NAVApplicationObjectFile -Source $FicheroOriginalBase -Destination $RutaOriginal -Force

    # echo "1.2.- Creando objetos versión CU original"
    # Split-NAVApplicationObjectFile -Source $FicheroOriginal -Destination $RutaOriginal -Force

    echo "2.- Creando objetos modificados"
    Export-NAVApplicationObject -DatabaseName $DBName -DatabaseServer $DBServer -path $FicheroModified -Filter $FiltroVersionList -ExportToNewSyntax 
    Split-NAVApplicationObjectFile -Source $FicheroModified -Destination $RutaModified -Force

    echo "3.- Borrando Objetos no conflictivos Versión Original"
    BorrarNoConflictivos $RutaOriginal $RutaModified

    echo "4.- Obtención de los Delta Files"
    Compare-NAVApplicationObject -Original $RutaOriginal -Modified $RutaModified -Delta $RutaDelta -Force -ExportToNewSyntax


    echo "5.- Generando ficheros .AL"
    $ParametrosTxt2AL = ' --source ' + $RutaDelta + ' --target ' +  $RutaResult + ' --rename --extensionStartId ' $ObjectStartId
    Start-Process -FilePath $RutaTxt2AL -argumentlist  $ParametrosTxt2AL -wait

    $HoraFinal = Get-Date;
    echo "La migración ha finalizado correctamente."
    echo ("Comienzo: " + $HoraComienzo)
    echo ("Final   : " + $HoraFinal)
}

# El fichero Modified.txt debe estar en C:\Tipsa\PowerShell\Txt2AL\Modified.txt

$VersionOrigen = '140'
$CUOrigen      = '08'
$DBServer = 'VORTEX\SQL2K17'
$DBName = 'AM_CRONUS140_CU08'
$VersionList = 'LAB'
$ObjectStartId = '7014450'

EjecutarConversion