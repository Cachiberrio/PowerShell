# Listar extensiones publicadas por TIPSA

$ServerInstance = 'vnt'
$Tenant = 'default' # o default
$RutaServicio = "c:\Archivos de programa\Microsoft Dynamics 365 Business Central\170\Service\"


import-module $RutaServicio'NavAdminTool.ps1'

$ListaExt = Get-NAVAppInfo -ServerInstance $ServerInstance -Tenant $Tenant -Publisher 'Técnicas Informática Pro.Serv. y Ases,SL' -TenantSpecificProperties | Select-Object Name, Version

$ListaExtensiones = @()
$obj = @()

foreach ($Extension in $ListaExt) {
    $obj = New-Object psobject -Property @{
        NombreExt = $Extension.Name
        VerExt = $Extension.Version

    }
    $ListaExtensiones += $obj
     }

$ListaExtensiones | Format-Table
