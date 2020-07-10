# ============================================================================
# 
# MUY IMPORTANTE
# 
# Este script no está creado para ejecutarse de una sóla vez porque hay sitios
# en los que tenemos que decoger valores de variables no disponibles hasta 
# ese momento.
# Las cnsecuencias de la ejecución del script pueden ser catastróficas.
# Se recomienda ir copiando y pegando las instrucciones en el NavAdminTool.pd1
# de forma manual.
# 
# ============================================================================

# Variables a rellenar
$NombreServicio160 = 'URZ160'

$NombreServidorBBDD140 = 'SRV-SQL'
$NombreServidorBBDD160 = 'SRV-SQL'
$NombreBBDD = 'URZANTE'

$VersionAplicacion160 = '16.0.14073.14195'

$TenantId140 = 'default'
$TenantId160 = 'default'

$PathLicenseFile = 'C:\Users\tipsa.URZANTE\Desktop\Tipsa\Tipsa160.flf'
$PathSystemApp = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\160\AL Development Environment\System.app'

$RutaApplicationsDVD = 'C:\Users\tipsa.URZANTE\Downloads\BC160CU03\Applications\'
$PathSystemApp = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\160\AL Development Environment\System.app'
$RutaApplicationsDVD = 'C:\Users\tipsa.URZANTE\Downloads\BC160CU03\Applications\'

# ============================================================================

Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\160\Service\NavAdminTool.ps1'

Write-Host "Task 3: Convert the version 14 database"
Invoke-NAVApplicationDatabaseConversion -DatabaseServer $NombreServidorBBDD140 -DatabaseName $NombreBBDD

# ============================================================================

Write-Host "Task 4: Configure version 16 server for DestinationAppsForMigration"
Set-NAVServerConfiguration -ServerInstance $NombreServicio160 -KeyName DatabaseName -KeyValue $NombreBBDD
Set-NAVServerConfiguration -ServerInstance $NombreServicio160 -KeyName "DestinationAppsForMigration" -KeyValue '[{"appId":"63ca2fa4-4f03-4f2b-a480-172fef340d3f", "name":"System Application", "publisher": "Microsoft"},{"appId":"437dbf0e-84ff-417a-965d-ed2bb9650972", "name":"Base Application", "publisher": "Microsoft"}]'
Set-NavServerConfiguration -ServerInstance $NombreServicio160 -KeyName "EnableTaskScheduler" -KeyValue false
Restart-NAVServerInstance -ServerInstance $NombreServicio160

# ============================================================================

Write-Host "Task 5: Increase application version"
Set-NAVApplication -ServerInstance $NombreServicio160 -ApplicationVersion $VersionAplicacion160 -Force

# ============================================================================

Write-Host "Task 6: Import version 16 license"
Import-NAVServerLicense -ServerInstance $NombreServicio160 -LicenseFile $PathLicenseFile
Restart-NAVServerInstance -ServerInstance $NombreServicio160

# ============================================================================

Write-Host "Task 6: Publish symbols and extensions"

Publish-NAVApp -ServerInstance $NombreServicio160 -Path $PathSystemApp -PackageType SymbolsOnly

$RutaFicheroApp = $RutaApplicationsDVD + 'system application\source\Microsoft_System Application.app'
Publish-NAVApp -ServerInstance $NombreServicio160 -Path $RutaFicheroApp
$RutaFicheroApp = $RutaApplicationsDVD + 'BaseApp\Source\Microsoft_Base Application.app'
Publish-NAVApp -ServerInstance $NombreServicio160 -Path $RutaFicheroApp
$RutaFicheroApp = $RutaApplicationsDVD + 'Application\Source\Microsoft_Application.app'
Publish-NAVApp -ServerInstance $NombreServicio160 -Path $RutaFicheroApp

$RutaFicheroApp = $RutaApplicationsDVD + 'AMCBanking365Fundamentals\Source\Microsoft_AMC Banking 365 Fundamentals.app'
Publish-NAVApp -ServerInstance $NombreServicio160 -Path $RutaFicheroApp
$RutaFicheroApp = $RutaApplicationsDVD + 'APIV1\Source\Microsoft__Exclude_APIV1_.app'
Publish-NAVApp -ServerInstance $NombreServicio160 -Path $RutaFicheroApp
$RutaFicheroApp = $RutaApplicationsDVD + 'ClientAddIns\Source\Microsoft__Exclude_ClientAddIns_.app'
Publish-NAVApp -ServerInstance $NombreServicio160 -Path $RutaFicheroApp
$RutaFicheroApp = $RutaApplicationsDVD + 'EssentialBusinessHeadlines\Source\Microsoft_Essential Business Headlines.app'
Publish-NAVApp -ServerInstance $NombreServicio160 -Path $RutaFicheroApp
$RutaFicheroApp = $RutaApplicationsDVD + 'HybridBaseDeployment\Source\Microsoft_Intelligent Cloud Base.app'
Publish-NAVApp -ServerInstance $NombreServicio160 -Path $RutaFicheroApp
$RutaFicheroApp = $RutaApplicationsDVD + 'HybridBC\Source\Microsoft_Business Central Intelligent Cloud.app'
Publish-NAVApp -ServerInstance $NombreServicio160 -Path $RutaFicheroApp
$RutaFicheroApp = $RutaApplicationsDVD + 'LatePaymentPredictor\Source\Microsoft_Late Payment Prediction.app'
Publish-NAVApp -ServerInstance $NombreServicio160 -Path $RutaFicheroApp
$RutaFicheroApp = $RutaApplicationsDVD + 'PayPalPaymentsStandard\Source\Microsoft_PayPal Payments Standard.app'
Publish-NAVApp -ServerInstance $NombreServicio160 -Path $RutaFicheroApp
$RutaFicheroApp = $RutaApplicationsDVD + 'SalesAndInventoryForecast\Source\Microsoft_Sales and Inventory Forecast.app'
Publish-NAVApp -ServerInstance $NombreServicio160 -Path $RutaFicheroApp
$RutaFicheroApp = $RutaApplicationsDVD + 'SendToEmailPrinter\Source\Microsoft_Send To Email Printer.app'
Publish-NAVApp -ServerInstance $NombreServicio160 -Path $RutaFicheroApp
$RutaFicheroApp = $RutaApplicationsDVD + 'WorldPayPaymentsStandard\Source\Microsoft_WorldPay Payments Standard.app'
Publish-NAVApp -ServerInstance $NombreServicio160 -Path $RutaFicheroApp

# ============================================================================

Write-Host "Task 7: Restart server instance"
Restart-NAVServerInstance -ServerInstance $NombreServicio160

# ============================================================================
#
#  CUIDADO: NOS DEBEMOS DETENER AQUÍ
#  En este punto debemos utilizar la instrucción Get-NavAppInfo -ServerInstance URZ160 y ver la versión que tienen las siguientes Apps:
#  
#  - System Application
#  - Base Application
#  - Application
#  
#  porque debemos actualizar el valor de las variables:
#  
#  - $SystemApplicationVersion 
#  - $BaseApplicationVersion 
#  - $ApplicationVersion 
# 
# ============================================================================

$SystemApplicationVersion = '16.3.14085.14238'
$BaseApplicationVersion = '16.3.14085.14238' 
$ApplicationVersion = '16.3.14085.14238' 

Write-Host "Task 8.1: Synchronize tenant"
Sync-NAVTenant -ServerInstance $NombreServicio160 -Mode Sync
Sync-NAVApp -ServerInstance $NombreServicio160 -Name "System Application" -Version $SystemApplicationVersion
Sync-NAVApp -ServerInstance $NombreServicio160 -Name "Base Application" -Version $BaseApplicationVersion
Sync-NAVApp -ServerInstance $NombreServicio160 -Name "Application" -Version $ApplicationVersion

# Por cada extension que haya que instalar. Si venimos de versiones viejas no ejecutar:
# Sync-NAVApp -ServerInstance BC160 -Tenant default -Name "<extension name>" -Version <extension version>
Write-Host "Task 8.2: Upgrade data"
Sync-NAVApp -ServerInstance $NombreServicio160  -Name "Intelligent Cloud Base" -Version '16.3.14085.14238'
Sync-NAVApp -ServerInstance $NombreServicio160  -Name "AMC Banking 365 Fundamentals" -Version '16.3.14085.14238'
Sync-NAVApp -ServerInstance $NombreServicio160  -Name "PayPal Payments Standard" -Version '16.3.14085.14238'
Sync-NAVApp -ServerInstance $NombreServicio160  -Name "Essential Business Headlines" -Version '16.3.14085.14238'
Sync-NAVApp -ServerInstance $NombreServicio160  -Name "_Exclude_ClientAddIns_" -Version '16.3.14085.14238'
Sync-NAVApp -ServerInstance $NombreServicio160  -Name "Send To Email Printer" -Version '16.3.14085.14238'
Sync-NAVApp -ServerInstance $NombreServicio160  -Name "Business Central Intelligent Cloud" -Version '16.3.14085.14238'
Sync-NAVApp -ServerInstance $NombreServicio160  -Name "_Exclude_APIV1_" -Version '16.3.14085.14238'
Sync-NAVApp -ServerInstance $NombreServicio160  -Name "WorldPay Payments Standard" -Version '16.3.14085.14238'
Sync-NAVApp -ServerInstance $NombreServicio160  -Name "Late Payment Prediction" -Version '16.3.14085.14238'
Sync-NAVApp -ServerInstance $NombreServicio160  -Name "Sales and Inventory Forecast" -Version '16.3.14085.14238'
# Sync-NAVApp -ServerInstance $NombreServicio160  -Name "Intelligent Cloud Base" -Version '14.14.43294.0'

# ============================================================================

Write-Host "Task 9.1: Upgrade data"
Start-NAVDataUpgrade -ServerInstance $NombreServicio160 -FunctionExecutionMode Serial -SkipAppVersionCheck
Restart-NAVServerInstance -ServerInstance $NombreServicio160

Write-Host "Task 9.2: Instalando Applicación"
Install-NAVApp -ServerInstance $NombreServicio160 -Name "Application"

# Por cada una de las extensiones instaladas en la Version origen. Si venimos de versiones viejas no ejecutar las dos siguientes versiones

Start-NAVAppDataUpgrade -ServerInstance $NombreServicio160  -Name "Intelligent Cloud Base" -Version '16.3.14085.14238'
Start-NAVAppDataUpgrade -ServerInstance $NombreServicio160  -Name "PayPal Payments Standard" -Version '16.3.14085.14238'
Start-NAVAppDataUpgrade -ServerInstance $NombreServicio160  -Name "Essential Business Headlines" -Version '16.3.14085.14238'
Start-NAVAppDataUpgrade -ServerInstance $NombreServicio160  -Name "_Exclude_ClientAddIns_" -Version '16.3.14085.14238'
Start-NAVAppDataUpgrade -ServerInstance $NombreServicio160  -Name "Business Central Intelligent Cloud" -Version '16.3.14085.14238'
Start-NAVAppDataUpgrade -ServerInstance $NombreServicio160  -Name "_Exclude_APIV1_" -Version '16.3.14085.14238'
Start-NAVAppDataUpgrade -ServerInstance $NombreServicio160  -Name "WorldPay Payments Standard" -Version '16.3.14085.14238'
Start-NAVAppDataUpgrade -ServerInstance $NombreServicio160  -Name "Sales and Inventory Forecast" -Version '16.3.14085.14238'

# Las siguientes extensiones no se actualizan porque son nuevas dentro de la versión:
# Start-NAVAppDataUpgrade -ServerInstance $NombreServicio160  -Name "AMC Banking 365 Fundamentals" -Version '16.3.14085.14238'
# Start-NAVAppDataUpgrade -ServerInstance $NombreServicio160  -Name "Send To Email Printer" -Version '16.3.14085.14238'
# Start-NAVAppDataUpgrade -ServerInstance $NombreServicio160  -Name "Late Payment Prediction" -Version '16.3.14085.14238'

# ============================================================================

Write-Host "Task 10: Install 3rd-party extensions"
# Por cada una de las extensiones instaladas en la Version origen. Si venimos de versiones viejas no ejecutar la siguiente Version
# Install-NAVApp -ServerInstance $NombreServicio160 -Name <extension name> -Version <extension version>
