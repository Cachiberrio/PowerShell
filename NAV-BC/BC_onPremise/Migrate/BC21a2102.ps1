$BcServerInstance = "VDS210"
$TenantId = "default"
$TenantDatabase = "VDS210"
$ApplicationDatabase = "VDS210"
$DatabaseServer= "VDS\SQLEXPRESS"
$BaseAppPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\BaseApp\Source\Microsoft_Base Application.app"
$SystemAppPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\system application\source\Microsoft_System Application.app"
$ApplicationAppPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\Application\Source\Microsoft_Application.app"
$NewBcVersion = "21.2.49946.49990"
$ExtPath = "The path and file name to an extension package"
$ExtName = "The name of an extension"
$ExtVersion = "21.2.49990"
$AddinsFolder = "C:\Program Files\Microsoft Dynamics 365 Business Central\210\Service\Add-ins"
$PartnerLicense= "C:\Users\nav-tipsa\Downloads\tipsa.flf"
$CustomerLicense= "C:\Users\nav-tipsa\Desktop\Licencia\VDS_Valdesil BC-21.flf"

# Versión original
import-module "C:\Program Files\Microsoft Dynamics 365 Business Central\210\service\NavAdminTool.ps1"

# Listar extensiones
Get-NAVAppInfo -ServerInstance $BcServerInstance

# Desinstalar extenciones
Get-NAVAppInfo -ServerInstance $BcServerInstance  | % { Uninstall-NAVApp -ServerInstance $BcServerInstance  -Name $_.Name -Version $_.Version -Force}

# Despublicar Symbols
Unpublish-NAVApp -ServerInstance $BcServerInstance -Name System

# Paramos instancia
Stop-NAVServerInstance -ServerInstance $BcServerInstance

# Desinstalamos la versión actual del equipo

# Instalamos la nueva versión de BC
# Seleccionamos sólo server y Web Server
# Dejamos en blanco el campo SQL database, para que no falle la instalación

# Versión destino - CERAMOS POWERSHELL Y VOLVEMOS A ABRIR CON EL NUEVO MÓDULO
import-module "C:\Program Files\Microsoft Dynamics 365 Business Central\210\service\NavAdminTool.ps1"

# Convertimos BD a la nueva versión
Invoke-NAVApplicationDatabaseConversion -DatabaseServer $DatabaseServer -DatabaseName $ApplicationDatabase
# si da un error tipo: A technical upgrade of database ... cannot be run, because the databases application version XXX is greater than or equal to XX ...
# No es un error sino un aviso que indica que la ver actual de la BD es la misma que la anterior y no es necesaria la conversión

#En la nueva instancia de 19 configuramos la BD convertida
Set-NAVServerConfiguration -ServerInstance $BCServerInstance -KeyName DatabaseName -KeyValue $ApplicationDatabase

# Reiniciamos servicio
Restart-NAVServerInstance -ServerInstance $BcServerInstance

# Importamos licencia Partner
Import-NAVServerLicense -ServerInstance $BcServerInstance -LicenseFile $PartnerLicense
Restart-NAVServerInstance -ServerInstance $BcServerInstance

# Compilamos extensiones publicadas
Get-NAVAppInfo -ServerInstance $BcServerInstance | Repair-NAVApp

# Reiniciamos instancia
Restart-NAVServerInstance -ServerInstance $BcServerInstance

# sincronizamos tenant
Sync-NAVTenant -ServerInstance $BcServerInstance  -Mode Sync

# Instalamos extensiones MS

Get-NAVAppInfo -ServerInstance $BcServerInstance

Publish-NAVApp -ServerInstance $BcServerInstance -Path $SystemAppPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name "System Application" -version $NewBcVersion


Publish-NAVApp -ServerInstance $BcServerInstance -Path $BaseAppPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name "Base Application" -version $NewBcVersion


Publish-NAVApp -ServerInstance $BcServerInstance -Path $ApplicationAppPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name "Application" -version $NewBcVersion

Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name "System Application" -Version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name "Base Application" -Version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name "Application" -Version $NewBcVersion



# Actualizamos resto extensiones Microsoft instaladas
# Listamos Extensiones instaladas
Get-NAVAppInfo -ServerInstance $BcServerInstance #-Name "Late Payment Prediction"

# Actualizamos cada extensión
$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\LatePaymentPredictor\Source\Microsoft_Late Payment Prediction.app"
$Name = "Late Payment Prediction"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\CompanyHub\Source\Microsoft_Company Hub.app"
$Name = "Company Hub"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\EssentialBusinessHeadlines\Source\Microsoft_Essential Business Headlines.app"
$Name = "Essential Business Headlines"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\Email - Outlook REST API\Source\Microsoft_Email - Outlook REST API.app"
$Name = "Email - Outlook REST API"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\Email - Microsoft 365 Connector\Source\Microsoft_Email - Microsoft 365 Connector.app"
$Name = "Email - Microsoft 365 Connector"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\paypalpaymentsstandard\source\Microsoft_Payment Links to PayPal.app"
$Name = "Payment Links to PayPal"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\ContosoCoffeeDemoDataset\Source\Microsoft_Contoso Coffee Demo Dataset.app"
$Name = "Contoso Coffee Demo Dataset"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\DataSearch\app\Microsoft_Data Search.app"
$Name = "Data Search"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\Email - SMTP API\Source\Microsoft_Email - SMTP API.app"
$Name = "Email - SMTP API"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\Intrastat\Source\Microsoft_Intrastat Core.app"
$Name = "Intrastat Core"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion


$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\IntrastatES\Source\Microsoft_Intrastat ES.app"
$Name = "Intrastat ES"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\testframework\TestRunner\Microsoft_Test Runner.app"
$Name = "Test Runner"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\onprem permissions\source\Microsoft_OnPrem Permissions.app"
$Name = "OnPrem Permissions"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\WorldPayPaymentsStandard\Source\Microsoft_WorldPay Payments Standard.app"
$Name = "WorldPay Payments Standard"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\salesandinventoryforecast\source\Microsoft_Sales and Inventory Forecast.app"
$Name = "Sales and Inventory Forecast"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\simplifiedbankstatementimport\source\Microsoft_Simplified Bank Statement Import.app"
$Name = "Simplified Bank Statement Import"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\DataArchive\app\Microsoft_Data Archive.app"
$Name = "Data Archive"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\microsoftuniversalprint\source\Microsoft_Universal Print Integration.app"
$Name = "Universal Print Integration"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\microsoftuniversalprint\source\Microsoft_Universal Print Integration.app"
$Name = "Universal Print Integration"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\Email - Current User Connector\Source\Microsoft_Email - Current User Connector.app"
$Name = "Email - Current User Connector"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\AMCBanking365Fundamentals\Source\Microsoft_AMC Banking 365 Fundamentals.app"
$Name = "AMC Banking 365 Fundamentals"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\vatgroupmanagement\source\Microsoft_VAT Group Management.app"
$Name = "VAT Group Management"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\sendtoemailprinter\source\Microsoft_Send To Email Printer.app"
$Name = "Send To Email Printer"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\APIReportsFinance\Source\Microsoft_API Reports - Finance.app"
$Name = "API Reports - Finance"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\testframework\performancetoolkit\Microsoft_Performance Toolkit.app"
$Name = "Performance Toolkit"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion

$ExtPath = "C:\Users\nav-tipsa\Downloads\BC21_CU02\Applications\recommendedapps\source\Microsoft_Recommended Apps.app"
$Name = "Recommended Apps"
Publish-NAVApp -ServerInstance $BcServerInstance -Path $ExtPath
Sync-NAVApp -ServerInstance $BcServerInstance -Name $Name -version $NewBcVersion
Start-NAVAppDataUpgrade -ServerInstance $BcServerInstance -Name $Name -Version $NewBcVersion





# Actualizamos add-ins
Set-NAVAddIn -ServerInstance $BcServerInstance -AddinName 'Microsoft.Dynamics.Nav.Client.BusinessChart' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'BusinessChart\Microsoft.Dynamics.Nav.Client.BusinessChart.zip')
Set-NAVAddIn -ServerInstance $BcServerInstance -AddinName 'Microsoft.Dynamics.Nav.Client.FlowIntegration' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'FlowIntegration\Microsoft.Dynamics.Nav.Client.FlowIntegration.zip')
Set-NAVAddIn -ServerInstance $BcServerInstance -AddinName 'Microsoft.Dynamics.Nav.Client.OAuthIntegration' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'OAuthIntegration\Microsoft.Dynamics.Nav.Client.OAuthIntegration.zip')
Set-NAVAddIn -ServerInstance $BcServerInstance -AddinName 'Microsoft.Dynamics.Nav.Client.PageReady' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'PageReady\Microsoft.Dynamics.Nav.Client.PageReady.zip')
Set-NAVAddIn -ServerInstance $BcServerInstance -AddinName 'Microsoft.Dynamics.Nav.Client.PowerBIManagement' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'PowerBIManagement\Microsoft.Dynamics.Nav.Client.PowerBIManagement.zip')
Set-NAVAddIn -ServerInstance $BcServerInstance -AddinName 'Microsoft.Dynamics.Nav.Client.RoleCenterSelector' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'RoleCenterSelector\Microsoft.Dynamics.Nav.Client.RoleCenterSelector.zip')
Set-NAVAddIn -ServerInstance $BcServerInstance -AddinName 'Microsoft.Dynamics.Nav.Client.SatisfactionSurvey' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'SatisfactionSurvey\Microsoft.Dynamics.Nav.Client.SatisfactionSurvey.zip')
Set-NAVAddIn -ServerInstance $BcServerInstance -AddinName 'Microsoft.Dynamics.Nav.Client.VideoPlayer' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'VideoPlayer\Microsoft.Dynamics.Nav.Client.VideoPlayer.zip')
Set-NAVAddIn -ServerInstance $BcServerInstance -AddinName 'Microsoft.Dynamics.Nav.Client.WebPageViewer' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'WebPageViewer\Microsoft.Dynamics.Nav.Client.WebPageViewer.zip')
Set-NAVAddIn -ServerInstance $BcServerInstance -AddinName 'Microsoft.Dynamics.Nav.Client.WelcomeWizard' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'WelcomeWizard\Microsoft.Dynamics.Nav.Client.WelcomeWizard.zip')

# Actualizamos versión
Set-NAVServerConfiguration -ServerInstance $BcServerInstance -KeyName SolutionVersionExtension -KeyValue 437dbf0e-84ff-417a-965d-ed2bb9650972 -ApplyTo All

# Importamos licencia cliente
Import-NAVServerLicense -ServerInstance $BcServerInstance -LicenseFile $CustomerLicense
Restart-NAVServerInstance -ServerInstance $BcServerInstance