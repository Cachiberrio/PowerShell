# $RutaModulo = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\90\RoleTailored Client CU15\NavModelTools.ps1'
$RutaModulo = 'C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client CU56\NavModelTools.ps1'

Import-Module $RutaModulo

$RutaDesarrollo = 'C:\Compartida\FOB\CVNE'

$RutaCompare = $RutaDesarrollo + '\Compare'
$RutaProcesados = $RutaCompare + '\Procesados'
$Ficheros = (Get-Item ($RutaCompare + "\*.txt"))
foreach ($Ficheros in $Ficheros)
    {
    $RutaDirectorio = $RutaCompare + "\" + $Ficheros.BaseName
    if (Test-Path $RutaDirectorio) 
        {
        Remove-Item ($RutaDirectorio) -Recurse | out-null
        }
    New-Item -Path $RutaDirectorio -ItemType "directory" | out-null
    Split-NAVApplicationObjectFile -Source $Ficheros -Destination $RutaDirectorio -Force
    if (-not (Test-Path $RutaProcesados))
        {
        New-Item -Path $RutaProcesados -ItemType "directory" | out-null
        }
    Copy-Item $Ficheros.PSPath -Destination $RutaProcesados -Force
    Remove-Item $Ficheros
    }
