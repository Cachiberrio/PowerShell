# Identifica la ruta del fichero App dado un nombre de extensión si hay una actualización

$RutaExtensiones = 'C:\Users\ng\Downloads\Descargas Temporales\EMCS'

$NombreExtension = 'EMCS Spain'
$VersionInstalada = '1.0.0.0'

foreach($fichero in Get-ChildItem $RutaExtensiones)
{

    $parts =$fichero.BaseName -split '_'
    Write-Host $parts[0]
    if ($parts[1] -eq $NombreExtension)
    {Write-Host $parts[1]}
    Write-Host $parts[2]
    Write-Host $parts[3]
}


$obj = @()
foreach($fichero in Get-ChildItem $RutaExtensiones)
    $parts =$fichero.BaseName -split '_'
    $obj = New-Object psobject -Property @{
        NombreExt = $parts[1]
        Build = $parts[1]

    }
    $ListaExtensiones += $obj
     }

$ListaExtensiones | Format-Table
