Function CopiarContenido{
    Param([string]$RutaOrigen,
          [string]$RutaDestino,
          [bool]$Borrar,
          [string]$TipoContenido)
    if ($TipoContenido -eq 'Directorios') {
    $Contenido = Get-Item ($RutaOrigen + '\*')
    }
    else
    {
    $Contenido = Get-Item ($RutaOrigen + '\*.*')
    }

    foreach ($Contenido in $Contenido)
    {
        if ($Borrar) {
            if (Test-Path ($RutaDestino + "\" + $Contenido.Name)) {
                Remove-Item ($RutaDestino + "\" + ($Contenido.Name)) -Recurse -Force
            }
        }
        if (-not (Test-Path ($RutaDestino))) {
            New-Item -ItemType "directory" -Path $RutaDestino
        }

        if ($TipoContenido -eq 'Directorios') {
            if (-not (Test-Path ($RutaDestino + "\" + $Contenido.Name))) {
                echo ("Copiando " + $TipoContenido + " " + ($Contenido.Name))
                Copy-Item ($RutaOrigen + "\" + $Contenido.Name) -Recurse ($RutaDestino) -Force
            }
        }
        else {
            if (-not (Test-Path ($RutaDestino + "\" + $Contenido.Name) -PathType Leaf)) {
                echo ("Copiando " + $TipoContenido + " " + ($Contenido.Name))
                Copy-Item ($RutaOrigen + "\" + $Contenido.Name) -Recurse ($RutaDestino + "\" + $Contenido.Name) -Force
            }
        }

    }
}
Function ActualizarNAV{
    $RutaOrigen = '\\hoth\Software\Navision\Utilidades\RoleTailored Clients\NAV'
    $RutaDestino = 'C:\Program Files (x86)\Microsoft Dynamics NAV'
    $DirectorioVersion = Get-Item ($RutaOrigen + '\*')
    foreach ($DirectorioVersion in $DirectorioVersion) {
        CopiarContenido ($RutaOrigen + "\" + $DirectorioVersion.Name) ($RutaDestino + "\" + $DirectorioVersion.Name) $false 'Directorios'
    }
}
Function ActualizarBC365{
    $RutaOrigen = '\\hoth\Software\Navision\Utilidades\RoleTailored Clients\BC365'
    $RutaDestino = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central'
    $DirectorioVersion = Get-Item ($RutaOrigen + '\*')
    foreach ($DirectorioVersion in $DirectorioVersion) {
        CopiarContenido ($RutaOrigen + "\" + $DirectorioVersion.Name) ($RutaDestino + "\" + $DirectorioVersion.Name) $false 'Directorios'
    }
}
Function ActualizarLinks{
    $RutaOrigen = '\\hoth\Software\Navision\Utilidades\RoleTailored Clients\Links'
    $RutaDestino = 'C:\Tipsa\Links'
    CopiarContenido $RutaOrigen $RutaDestino $true 'Directorios'
}
Function ActualizarPowerShell{
    $RutaOrigen = '\\hoth\Software\Navision\Utilidades\RoleTailored Clients\PowerShell\Scripts'
    $RutaDestino = 'C:\Tipsa\PowerShell\Scripts'
    CopiarContenido $RutaOrigen $RutaDestino $true 'Ficheros'

    $RutaOrigen = '\\hoth\Software\Navision\Utilidades\RoleTailored Clients\PowerShell\Migracion\Objetos'
    $RutaDestino = 'C:\Tipsa\PowerShell\Migracion\Objetos'
    #CopiarContenido $RutaOrigen $RutaDestino $false 'Ficheros'

    $RutaOrigen = '\\hoth\Software\Navision\Utilidades\RoleTailored Clients\PowerShell\Scripts\EntornoConsultores'
    $RutaDestino = 'C:\Tipsa\PowerShell\Scripts\EntornoConsultores'
    if (-not (Test-Path ($RutaDestino))) {
        New-Item -ItemType "directory" -Path $RutaDestino}
    CopiarContenido $RutaOrigen $RutaDestino $true 'Ficheros'

    if (-not (Test-Path ('C:\Tipsa\PowerShell\Migracion\Modified'))) {
        New-Item -ItemType "directory" -Path 'C:\Tipsa\PowerShell\Migracion\Modified'}
    if (-not (Test-Path ('C:\Tipsa\PowerShell\Migracion\Original'))) {
        New-Item -ItemType "directory" -Path 'C:\Tipsa\PowerShell\Migracion\Original'}
    if (-not (Test-Path ('C:\Tipsa\PowerShell\Migracion\Result'))) {
        New-Item -ItemType "directory" -Path 'C:\Tipsa\PowerShell\Migracion\Result'}
    if (-not (Test-Path ('C:\Tipsa\PowerShell\Migracion\Target'))) {
        New-Item -ItemType "directory" -Path 'C:\Tipsa\PowerShell\Migracion\Target'}
}
Clear
ActualizarNAV
ActualizarBC365
ActualizarLinks
ActualizarPowerShell
echo "La actualización ha finalizado correctamente."