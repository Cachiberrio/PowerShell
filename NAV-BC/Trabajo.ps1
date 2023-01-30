Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\160\Service\NavAdminTool.ps1'

# https://msdynamics.net/featured-slider/dynamics-365-business-central-extension-upgrade/

= Instalación =======================

Get-NAVAppInfo -ServerInstance URZ160 -Publisher TIPSA -Tenant Defautl -TenantSpecificProperties

Publish-NAVApp -ServerInstance URZ160 -Path 'C:\App\URZ160\TIPSA_URZANTE_BASE_1.0.0.0.app' –SkipVerification 
Publish-NAVApp -ServerInstance URZ160 -Path 'C:\App\URZ160\TIPSA_URZANTE_ANTICIPOS_1.0.0.0.app' –SkipVerification 

Sync-NavApp -ServerInstance URZ160 -Name URZANTE_BASE -Version "1.0.0.0"
Sync-NavApp -ServerInstance URZ160 -Name URZANTE_ANTICIPOS -Version "1.0.0.0"

install-NAVApp -ServerInstance URZ160 -Path 'C:\App\URZ160\TIPSA_URZANTE_BASE_1.0.0.0.app'
install-NAVApp -ServerInstance URZ160 -Path 'C:\App\URZ160\TIPSA_URZANTE_ANTICIPOS_1.0.0.0.app'

Get-NAVAppInfo -ServerInstance URZ160 -Publisher TIPSA -Tenant Defautl -TenantSpecificProperties
Get-NAVAppInfo -ServerInstance URZ160 -Tenant Defautl -TenantSpecificProperties

= Desinstalación ====================

Get-NAVAppInfo -ServerInstance URZ160 -Publisher TIPSA -Tenant Defautl -TenantSpecificProperties

Uninstall-NAVApp -ServerInstance URZ160 -Name URZANTE_BASE -Version '1.0.0.0'
Uninstall-NAVApp -ServerInstance URZ160 -Name URZANTE_ANTICIPOS -Version '1.0.0.0'

Unpublish-NAVApp -ServerInstance URZ160 -Name URZANTE_BASE -Version '1.0.0.0'
Unpublish-NAVApp -ServerInstance URZ160 -Name URZANTE_ANTICIPOS -Version '1.0.0.0'

Get-NAVAppInfo -ServerInstance URZ160 -Publisher TIPSA -Tenant Defautl -TenantSpecificProperties
Get-NAVAppInfo -ServerInstance URZ160 -Tenant Defautl -TenantSpecificProperties

$FechaHoy = Get-Date
$Mes = $FechaHoy.Month
$Anio = $FechaHoy.Year
$Dia = $FechaHoy.Day
$Hora = $FechaHoy.Hour
$Minutos = $FechaHoy.Minute
$Segundos = $FechaHoy.Second
$CadenaFecha = Get-Date -format yyMMddhhmmss
$CadenaFecha