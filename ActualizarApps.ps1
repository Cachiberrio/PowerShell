Function BuscarNombreServicio {
    $NombreServicio = Split-Path (Split-Path $script:MyInvocation.MyCommand.Path -Parent) -Leaf
    return $NombreServicio
}
Function EsExtensionYaInstalada {
    Param([string]$NombreServicio,[string]$ExtensionName,[string]$ExtensionVersion)
    $ExtensionInfo = Get-NAVAppInfo -ServerInstance $NombreServicio -Name $ExtensionName -Version $ExtensionVersion
    if ($ExtensionInfo.Name) {            
        Return $true
    } else {            
        Return $false
    }
}
Function EsVersionPosterior {
    Param([string]$NombreServicio,[string]$ExtensionName,[string]$ExtensionVersionNueva)
    $ExtensionInfo = Get-NAVAppInfo -ServerInstance $NombreServicio -Name $ExtensionName
    $ExtensionVersionInstalada = $ExtensionInfo.Version

    if ($ExtensionVersionNueva -gt $ExtensionVersionInstalada) {            
        Return $true
    } else {            
        Return $false
    }
}
Function CrearDirectorio{
    Param([string]$RutaDirectorio)
    echo ("Creando directorio " + $RutaDirectorio)
    if (-not (Test-Path $RutaDirectorio))
        {
        New-Item -Path $RutaDirectorio -ItemType "directory" | out-null
        }
    
}
Function PasarAInstaladas {
    Param([string]$RutaDirectorioPadre)
    $RutaDirectorioInstaladas = $RutaDirectorioPadre +'\Instaladas'
    CrearDirectorio $RutaDirectorioInstaladas
    $CadenaFecha = Get-Date -format yyMMddhhmmss
    $CadenaFecha = $CadenaFecha + " " + $Ficheros.Name
    Copy-Item $Ficheros -Destination "$RutaDirectorioInstaladas\$CadenaFecha" -Force
}
Cls
Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\160\Service\NavAdminTool.ps1'
$NombreServicio = BuscarNombreServicio

Write-Host "Nombre Servicio: $NombreServicio"
$RutaFichero = Split-Path $script:MyInvocation.MyCommand.Path -Parent
$Ficheros = (Get-Item "$RutaFichero\*.app")
foreach ($Ficheros in $Ficheros)
    {
        $ExtensionInfo = Get-NAVAppInfo -Path $Ficheros
        $ExtensionNameFichero = $ExtensionInfo.Name
        $ExtensionVersionFichero = $ExtensionInfo.Version
        if (EsExtensionYaInstalada $NombreServicio $ExtensionNameFichero $ExtensionVersionFichero) 
            {
                if (EsVersionPosterior $NombreServicio $ExtensionNameFichero $ExtensionVersionFichero) 
                    {
                        Write-Host "Actualizando extensión: $ExtensionNameFichero"
                        Publish-NAVApp -ServerInstance $NombreServicio -Path $Ficheros –SkipVerification
                        Sync-NavApp -ServerInstance $NombreServicio -Name $ExtensionNameFichero -Version $ExtensionVersionFichero
                        Install-NAVApp -ServerInstance $NombreServicio -Name $ExtensionNameFichero
                        Start-NAVAppDataUpgrade -ServerInstance $NombreServicio -Name $ExtensionNameFichero -Version $ExtensionVersionFichero
                    }
                else 
                    {
                    Write-Host "La extensión no necesita actualización"
                    }
            }
        else
            {
                Write-Host "Instalando extensión $ExtensionNameFichero"
                Publish-NAVApp -ServerInstance $NombreServicio -Path $Ficheros –SkipVerification
                Sync-NavApp -ServerInstance $NombreServicio -Name $ExtensionNameFichero -Version $ExtensionVersionFichero
                Install-NAVApp -ServerInstance $NombreServicio -Name $ExtensionNameFichero 
            }
        PasarAInstaladas $RutaFichero
        Remove-Item $Ficheros
    }
Get-NAVAppInfo -ServerInstance URZ160 -Publisher TIPSA -Tenant Defautl -TenantSpecificProperties