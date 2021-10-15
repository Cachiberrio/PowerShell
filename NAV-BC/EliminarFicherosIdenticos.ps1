param(
[string]$RutaFicherosEliminarIguales,
[string]$RutaFicherosBase
)

Function EliminarFicherosIguales{
    Param([string]$EFIRutaFicherosEliminarIguales,[string]$EFIRutaFicherosBase)
    $EFIContadorFicherosEliminados = 0
    $Ficheros = (Get-Item ($EFIRutaFicherosEliminarIguales + '\*.*'))
    foreach ($Ficheros in $Ficheros)
        {
        if (Test-Path ($EFIRutaFicherosBase + '\' + $Ficheros.Name))
            {
            $EFISonIguales = ComparaFicheros ($EFIRutaFicherosEliminarIguales + '\' + $Ficheros.Name) ($EFIRutaFicherosBase + '\' + $Ficheros.Name) 
            if ($EFISonIguales -eq $true)
                {
                    Remove-Item $Ficheros
                    $EFIContadorFicherosEliminados = $EFIContadorFicherosEliminados + 1
                }
            }
        }
    return $EFIContadorFicherosEliminados
}

Function ComparaFicheros{
    Param([string]$CFFichero1,[string]$CFFichero2)
    $CFSonIguales = $false
    $CFComparo = Compare-Object -ReferenceObject (Get-Content $CFFichero1) -DifferenceObject (Get-Content $CFFichero2)
    if ($CFComparo -eq $null)
    {
      $CFSonIguales = $true
    }
    return $CFSonIguales
}


cls

Import-Module 'C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client CU06\Microsoft.Dynamics.Nav.Model.Tools.psd1'

<#
$RutaFicherosEliminarIguales = 'C:\RUTAFICHEROSELIMINARIGUALES'
$RutaFicherosBase = 'C:\RUTAFICHEROSBASE'
#>

Write-Output ('...Eliminado ficheros de ' + $RutaFicherosEliminarIguales + ' si existe fichero identico en ' + $RutaFicherosBase + '...')
Write-Output (' ')

$ContadorFicherosEliminados = EliminarFicherosIguales $RutaFicherosEliminarIguales $RutaFicherosBase 

Write-Output ('Se han eliminado ' + $ContadorFicherosEliminados + ' ficheros de ' + $RutaFicherosEliminarIguales + ' por existir fichero identico en ' + $RutaFicherosBase)