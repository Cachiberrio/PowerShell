# Variables a rellenar
$NombreServicio140 = 'BC140'
$PathLicenseFile = 'C:\Users\tipsa.URZANTE\Desktop\Tipsa\Tipsa160.flf'

# ============================================================================
Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\140\Service\NavAdminTool.ps1'

Import-NAVServerLicense -ServerInstance $NombreServicio140 -LicenseFile $PathLicenseFile
Restart-NAVServerInstance -ServerInstance $NombreServicio140

Write-Host "Task 2.1: Prepare version 14 databases"
Get-NAVAppInfo -ServerInstance $NombreServicio140 -tenant Default

Write-Host "Task 2.2: Desinstalando las Extensiones"
Uninstall-NAVApp -ServerInstance $NombreServicio140 -Name 'Essential Business Headlines' -Tenant Default -Version '14.14.43294.0' -Force
Uninstall-NAVApp -ServerInstance $NombreServicio140 -Name 'Intelligent Cloud Base' -Tenant Default -Version '14.14.43294.0' -Force
Uninstall-NAVApp -ServerInstance $NombreServicio140 -Name 'Business Central Intelligent Cloud' -Tenant Default -Version '14.14.43294.0' -Force
Uninstall-NAVApp -ServerInstance $NombreServicio140 -Name '_Exclude_APIV1_' -Tenant Default -Version '14.14.43294.0' -Force
Uninstall-NAVApp -ServerInstance $NombreServicio140 -Name '_Exclude_ClientAddIns_' -Tenant Default -Version '14.14.43294.0' -Force
Uninstall-NAVApp -ServerInstance $NombreServicio140 -Name 'WorldPay Payments Standard' -Tenant Default -Version '14.14.43294.0' -Force
Uninstall-NAVApp -ServerInstance $NombreServicio140 -Name 'Sales and Inventory Forecast' -Tenant Default -Version '14.14.43294.0' -Force
Uninstall-NAVApp -ServerInstance $NombreServicio140 -Name 'PayPal Payments Standard' -Tenant Default -Version '14.14.43294.0' -Force

Write-Host "Task 2.3: Despublicando las Extensiones"
Unpublish-NAVApp -ServerInstance $NombreServicio140 -Name 'Essential Business Headlines' -Version '14.14.43294.0'
Unpublish-NAVApp -ServerInstance $NombreServicio140 -Name 'Intelligent Cloud Base' -Version '14.14.43294.0'
Unpublish-NAVApp -ServerInstance $NombreServicio140 -Name 'Business Central Intelligent Cloud' -Version '14.14.43294.0'
Unpublish-NAVApp -ServerInstance $NombreServicio140 -Name '_Exclude_APIV1_' -Version '14.14.43294.0'
Unpublish-NAVApp -ServerInstance $NombreServicio140 -Name '_Exclude_ClientAddIns_' -Version '14.14.43294.0'
Unpublish-NAVApp -ServerInstance $NombreServicio140 -Name 'WorldPay Payments Standard' -Version '14.14.43294.0'
Unpublish-NAVApp -ServerInstance $NombreServicio140 -Name 'Sales and Inventory Forecast' -Version '14.14.43294.0'
Unpublish-NAVApp -ServerInstance $NombreServicio140 -Name 'PayPal Payments Standard' -Version '14.14.43294.0'

Write-Host "Task 2.4: Despublicando Symbols"
Get-NAVAppInfo -ServerInstance $NombreServicio140 -SymbolsOnly | % { Unpublish-NAVApp -ServerInstance $NombreServicio140 -Name $_.Name -Version $_.Version }

Write-Host "Task 2.5: Deteniendo el servicio"
Get-NAVAppInfo -ServerInstance $NombreServicio140 -tenant Default
Stop-NAVServerInstance -ServerInstance $NombreServicio140