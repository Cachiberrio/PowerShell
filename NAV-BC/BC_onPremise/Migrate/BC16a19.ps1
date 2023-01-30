# https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/upgrade/upgrade-technical-upgrade-v19
# Migración URZANTE

$OldBcServerInstance = "URZ160Upg"
$NewBcServerInstance = "URZ190"
$TenantId = "default"
$TenantDatabase = "URZ190"
$ApplicationDatabase = "URZ190"
$DatabaseServer = "srv-sql"
$OldVersion = "16.0.14073.14195"
$NewVersion = '19.0.29894.30693'
$PartnerLicense = "C:\Users\tipsa.URZANTE\Downloads\MIG190\Microsoft Dynamics 365 Business Central on premises_19.flf"
$AddinsFolder = 'C:\Program Files\Microsoft Dynamics 365 Business Central\190\service\Add-ins'
$CustomerLicense = "C:\Users\tipsa.URZANTE\Downloads\MIG190\URZ_Urzante_BC-16.flf"
$Apps19folder =        'C:\Users\tipsa.URZANTE\Downloads\MIG190\ext19'
$AppsMicroSoftFolder = 'C:\Users\tipsa.URZANTE\Downloads\BC190\Applications'

# Versión original
import-module "C:\Program Files\Microsoft Dynamics 365 Business Central\160\service\NavAdminTool.ps1"

Get-NAVAppInfo -ServerInstance $oldBcServerInstance

# Desinstalamos extensiones
Get-NAVAppInfo -ServerInstance $OldBcServerInstance  | % { Uninstall-NAVApp -ServerInstance $OldBcServerInstance -Name $_.Name -Version $_.Version }
# Despublicamos symbols
Get-NAVAppInfo -ServerInstance $OldBcServerInstance  -SymbolsOnly | % { Unpublish-NAVApp -ServerInstance $OldBcServerInstance -Name $_.Name -Version $_.Version }
# paramos servicio antiguo
Stop-NAVServerInstance -ServerInstance $OldBcServerInstance

# Versión destino - CERAMOS POWERSHELL Y VOLVEMOS A ABRIR CON EL NUEVO MÓDULO
import-module "C:\Program Files\Microsoft Dynamics 365 Business Central\190\service\NavAdminTool.ps1"

# convertimos BD a v19
Invoke-NAVApplicationDatabaseConversion -DatabaseServer $DatabaseServer -DatabaseName $ApplicationDatabase

#En la nueva instancia de 19 configuramos la BD convertida
Set-NAVServerConfiguration -ServerInstance $NewBcServerInstance -KeyName DatabaseName -KeyValue $ApplicationDatabase

# Configuramos permission sets defined as data
Set-NavServerConfiguration -ServerInstance $NewBcServerInstance -KeyName "UsePermissionSetsFromExtensions" -KeyValue false

# Deshabilitamos Scheduler durante la migración
Set-NavServerConfiguration -ServerInstance $NewBcServerInstance -KeyName "EnableTaskScheduler" -KeyValue false

# Reiniciamos servicio
Restart-NAVServerInstance -ServerInstance $NewBcServerInstance

# Importamos licencia de Partner
Import-NAVServerLicense -ServerInstance $NewBcServerInstance -LicenseFile $PartnerLicense

# Compilamos todas las extensiones contra la nueva plataforma
Get-NAVAppInfo -ServerInstance $NewBcServerInstance | Repair-NAVApp

Repair-NAVApp -ServerInstance $NewBcServerInstance -Name "Application" -Version $ExtVersion

# Reiniciamos servicio
Restart-NAVServerInstance -ServerInstance $NewBcServerInstance

# sincronizamos
Sync-NAVTenant -ServerInstance $NewBcServerInstance  -Mode Sync



Get-NAVAppInfo -ServerInstance $NewBcServerInstance



# Actualizar Extensiones base
Publish-NAVApp -ServerInstance $NewBcServerInstance -Path "C:\Users\tipsa.URZANTE\Downloads\BC190\Applications\system application\source\Microsoft_System Application.app"
Sync-NAVApp -ServerInstance $NewBcServerInstance -Name "System Application" -version $NewVersion


Publish-NAVApp -ServerInstance $NewBcServerInstance -Path "C:\Users\tipsa.URZANTE\Downloads\BC190\Applications\Application\source\Microsoft_Application.app"
Sync-NAVApp -ServerInstance $NewBcServerInstance -Name "Application" -version $NewVersion


Publish-NAVApp -ServerInstance $NewBcServerInstance -Path "C:\Users\tipsa.URZANTE\Downloads\BC190\Applications\BaseApp\Source\Microsoft_Base Application.app"
Sync-NAVApp -ServerInstance $NewBcServerInstance -Name "Base Application" -version $NewVersion

# Fix JA
Publish-NAVApp -ServerInstance $NewBcServerInstance -Path $Apps19folder"\TIPSA_UPD19_1.0.0.8.app" –SkipVerification
Sync-NAVApp -ServerInstance $NewBcServerInstance -name 'UPD19' -Version '1.0.0.8' # -mode clean
install-navapp -ServerInstance $NewBcServerInstance -name 'UPD19' -Version '1.0.0.8'

Start-NAVAppDataUpgrade -ServerInstance $NewBcServerInstance -Name "System Application" -version $NewVersion
Start-NAVAppDataUpgrade -ServerInstance $NewBcServerInstance -Name "Base Application" -version $NewVersion
# Fin Fix JA

Start-NAVAppDataUpgrade -ServerInstance $NewBcServerInstance -Name "Application" -version $NewVersion




# Actualizar Extensiones TIPSA
Publish-NAVApp -ServerInstance $NewBcServerInstance -Path $Apps19folder"\DF_SII_17.1.20.31.app" –SkipVerification
Sync-NAVApp -ServerInstance $NewBcServerInstance -Name "SII" -version '17.1.20.31'
Start-NAVAppDataUpgrade -ServerInstance $NewBcServerInstance -Name "SII" -version '17.1.20.31'

Publish-NAVApp -ServerInstance $NewBcServerInstance -Path $Apps19folder"\Técnicas Informática Pro.Serv. y Ases,SL_TIP LicenseCheck_1.0.0.5.app" –SkipVerification
Sync-NAVApp -ServerInstance $NewBcServerInstance -Name "TIP LicenseCheck" -version '1.0.0.5'
Start-NAVAppDataUpgrade -ServerInstance $NewBcServerInstance -Name "TIP LicenseCheck" -version '1.0.0.5'

Publish-NAVApp -ServerInstance $NewBcServerInstance -Path $Apps19folder"\Técnicas Informática Pro.Serv. y Ases,SL_Bulk Items Management  Product Processing Orders_1.0.0.16.app" –SkipVerification
Sync-NAVApp -ServerInstance $NewBcServerInstance -Name "Bulk Items Management | Product Processing Orders" -version '1.0.0.16'
Start-NAVAppDataUpgrade -ServerInstance $NewBcServerInstance -Name "Bulk Items Management | Product Processing Orders" -version '1.0.0.16'

Publish-NAVApp -ServerInstance $NewBcServerInstance -Path $Apps19folder"\Técnicas Informática Pro.Serv. y Ases,SL_Lab Test Management_1.0.0.5.app" –SkipVerification
Sync-NAVApp -ServerInstance $NewBcServerInstance -Name "Lab Test Management" -version '1.0.0.5'
Start-NAVAppDataUpgrade -ServerInstance $NewBcServerInstance -Name "Lab Test Management" -version '1.0.0.5'

Publish-NAVApp -ServerInstance $NewBcServerInstance -Path $Apps19folder"\Técnicas Informática Pro.Serv. y Ases,SL_Gestión de recogida agraria - Harvest Management_1.0.0.27.app" –SkipVerification
Sync-NAVApp -ServerInstance $NewBcServerInstance -Name "Gestión de recogida agraria - Harvest Management" -version '1.0.0.27'
Start-NAVAppDataUpgrade -ServerInstance $NewBcServerInstance -Name "Gestión de recogida agraria - Harvest Management" -version '1.0.0.27'


Publish-NAVApp -ServerInstance $NewBcServerInstance -Path $Apps19folder"\TIPSA_SGA URZANTE_1.0.7.1.app" –SkipVerification
Sync-NAVApp -ServerInstance $NewBcServerInstance -Name "SGA URZANTE" -version '1.0.7.1'
Start-NAVAppDataUpgrade -ServerInstance $NewBcServerInstance -Name "SGA URZANTE" -version '1.0.7.1'

Publish-NAVApp -ServerInstance $NewBcServerInstance -Path $Apps19folder"\TIPSA_URZANTE_ANTICIPOS_1.0.0.4.app" –SkipVerification
Sync-NAVApp -ServerInstance $NewBcServerInstance -Name "URZANTE_ANTICIPOS" -version '1.0.0.4'
Start-NAVAppDataUpgrade -ServerInstance $NewBcServerInstance -Name "URZANTE_ANTICIPOS" -version '1.0.0.4'

Publish-NAVApp -ServerInstance $NewBcServerInstance -Path $Apps19folder"\TIPSA_URZANTE_BASE_1.0.8.39.app" –SkipVerification
Sync-NAVApp -ServerInstance $NewBcServerInstance -Name "URZANTE_BASE" -version '1.0.8.39' -mode ForceSync
Start-NAVAppDataUpgrade -ServerInstance $NewBcServerInstance -Name "URZANTE_BASE" -version '1.0.8.39'


# Instalamos apps de Microsoft por defecto
Publish-NAVApp -ServerInstance $NewBcServerInstance -Path $AppsMicroSoftFolder"\sendtoemailprinter\source\Microsoft_Send To Email Printer.app"
Sync-NAVApp -ServerInstance $NewBcServerInstance -Name "Send To Email Printer" -version $NewVersion
Start-NAVAppDataUpgrade -ServerInstance $NewBcServerInstance -Name "Send To Email Printer" -version $NewVersion

Publish-NAVApp -ServerInstance $NewBcServerInstance -Path $AppsMicroSoftFolder"\WorldPayPaymentsStandard\Source\Microsoft_WorldPay Payments Standard.app"
Sync-NAVApp -ServerInstance $NewBcServerInstance -Name "WorldPay Payments Standard" -version $NewVersion
Start-NAVAppDataUpgrade -ServerInstance $NewBcServerInstance -Name "WorldPay Payments Standard" -version $NewVersion

Publish-NAVApp -ServerInstance $NewBcServerInstance -Path $AppsMicroSoftFolder"\LatePaymentPredictor\Source\Microsoft_Late Payment Prediction.app"
Sync-NAVApp -ServerInstance $NewBcServerInstance -Name "Late Payment Prediction" -version $NewVersion
Start-NAVAppDataUpgrade -ServerInstance $NewBcServerInstance -Name "Late Payment Prediction" -version $NewVersion

Publish-NAVApp -ServerInstance $NewBcServerInstance -Path $AppsMicroSoftFolder"\paypalpaymentsstandard\source\Microsoft_PayPal Payments Standard.app"
Sync-NAVApp -ServerInstance $NewBcServerInstance -Name "PayPal Payments Standard" -version $NewVersion
Start-NAVAppDataUpgrade -ServerInstance $NewBcServerInstance -Name "PayPal Payments Standard" -version $NewVersion

Publish-NAVApp -ServerInstance $NewBcServerInstance -Path $AppsMicroSoftFolder"\paypalpaymentsstandard\source\Microsoft_PayPal Payments Standard.app"
Sync-NAVApp -ServerInstance $NewBcServerInstance -Name "PayPal Payments Standard" -version $NewVersion
Start-NAVAppDataUpgrade -ServerInstance $NewBcServerInstance -Name "PayPal Payments Standard" -version $NewVersion

Publish-NAVApp -ServerInstance $NewBcServerInstance -Path $AppsMicroSoftFolder"\ClientAddIns\Source\Microsoft__Exclude_ClientAddIns_.app"
Sync-NAVApp -ServerInstance $NewBcServerInstance -Name "_Exclude_ClientAddIns_" -version $NewVersion
Start-NAVAppDataUpgrade -ServerInstance $NewBcServerInstance -Name "_Exclude_ClientAddIns_" -version $NewVersion

Publish-NAVApp -ServerInstance $NewBcServerInstance -Path $AppsMicroSoftFolder"\APIV1\Source\Microsoft__Exclude_APIV1_.app"
Sync-NAVApp -ServerInstance $NewBcServerInstance -Name "_Exclude_APIV1_" -version $NewVersion
Start-NAVAppDataUpgrade -ServerInstance $NewBcServerInstance -Name "_Exclude_APIV1_" -version $NewVersion

Publish-NAVApp -ServerInstance $NewBcServerInstance -Path $AppsMicroSoftFolder"\EssentialBusinessHeadlines\Source\Microsoft_Essential Business Headlines.app"
Sync-NAVApp -ServerInstance $NewBcServerInstance -Name "Essential Business Headlines" -version $NewVersion
Start-NAVAppDataUpgrade -ServerInstance $NewBcServerInstance -Name "Essential Business Headlines" -version $NewVersion

Publish-NAVApp -ServerInstance $NewBcServerInstance -Path $AppsMicroSoftFolder"\AMCBanking365Fundamentals\Source\Microsoft_AMC Banking 365 Fundamentals.app"
Sync-NAVApp -ServerInstance $NewBcServerInstance -Name "AMC Banking 365 Fundamentals" -version $NewVersion
Start-NAVAppDataUpgrade -ServerInstance $NewBcServerInstance -Name "AMC Banking 365 Fundamentals" -version $NewVersion

Publish-NAVApp -ServerInstance $NewBcServerInstance -Path $AppsMicroSoftFolder"\salesandinventoryforecast\source\Microsoft_Sales and Inventory Forecast.app"
Sync-NAVApp -ServerInstance $NewBcServerInstance -Name "Sales and Inventory Forecast" -version $NewVersion
Start-NAVAppDataUpgrade -ServerInstance $NewBcServerInstance -Name "Sales and Inventory Forecast" -version $NewVersion

# Consultamos lista extensiones  nos aseguramos de desinsalar todas las versiones anteriores
Get-NAVAppInfo -ServerInstance $NewBcServerInstance | Select-Object Name, Version
Get-NAVAppInfo -ServerInstance $NewBcServerInstance -Tenant Default -Publisher 'Técnicas Informática Pro.Serv. y Ases,SL' -TenantSpecificProperties | Select-Object Name, Version
Get-NAVAppInfo -ServerInstance $NewBcServerInstance -Tenant Default -Publisher 'TIPSA' -TenantSpecificProperties | Select-Object Name, Version
Get-NAVAppInfo -ServerInstance $NewBcServerInstance -Tenant Default -Publisher 'Microsoft' -TenantSpecificProperties | Select-Object Name, Version


# Desinstalamos versiones antiguas
Unpublish-NAVApp -ServerInstance $NewBcServerInstance -Name 'Gestión de recogida agraria - Harvest Management' -version '1.0.0.23'
Unpublish-NAVApp -ServerInstance $NewBcServerInstance -Name 'Lab Test Management' -version '1.0.0.4'
Unpublish-NAVApp -ServerInstance $NewBcServerInstance -Name 'TIP LicenseCheck' -version '1.0.0.3'
Unpublish-NAVApp -ServerInstance $NewBcServerInstance -Name 'Bulk Items Management | Product Processing Orders' -version '1.0.0.15'
Unpublish-NAVApp -ServerInstance $NewBcServerInstance -Name 'SGA URZANTE' -version '1.0.4.5'
Unpublish-NAVApp -ServerInstance $NewBcServerInstance -Name 'SII' -version '16.173.20.13'

Unpublish-NAVApp -ServerInstance $NewBcServerInstance -Name 'Base Application' -version '16.3.14085.14238'
Unpublish-NAVApp -ServerInstance $NewBcServerInstance -Name 'Application' -version '16.3.14085.14238'
Unpublish-NAVApp -ServerInstance $NewBcServerInstance -Name 'system Application' -version '16.3.14085.14238'

Unpublish-NAVApp -ServerInstance $NewBcServerInstance -Name 'Send To Email Printer' -version '16.3.14085.14238'
Unpublish-NAVApp -ServerInstance $NewBcServerInstance -Name 'WorldPay Payments Standard' -version '16.3.14085.14238'
Unpublish-NAVApp -ServerInstance $NewBcServerInstance -Name 'Late Payment Prediction' -version '16.3.14085.14238'
Unpublish-NAVApp -ServerInstance $NewBcServerInstance -Name 'PayPal Payments Standard' -version '16.3.14085.14238'
Unpublish-NAVApp -ServerInstance $NewBcServerInstance -Name 'Business Central Intelligent Cloud' -version '16.3.14085.14238'
Unpublish-NAVApp -ServerInstance $NewBcServerInstance -Name '_Exclude_ClientAddIns_' -version '16.3.14085.14238'
Unpublish-NAVApp -ServerInstance $NewBcServerInstance -Name '_Exclude_APIV1_' -version '16.3.14085.14238'
Unpublish-NAVApp -ServerInstance $NewBcServerInstance -Name 'Intelligent Cloud Base' -version '16.3.14085.14238'
Unpublish-NAVApp -ServerInstance $NewBcServerInstance -Name 'Essential Business Headlines' -version '16.3.14085.14238'
Unpublish-NAVApp -ServerInstance $NewBcServerInstance -Name 'AMC Banking 365 Fundamentals' -version '16.3.14085.14238'
Unpublish-NAVApp -ServerInstance $NewBcServerInstance -Name 'Sales and Inventory Forecast' -version '16.3.14085.14238'

# Fix JA
unPublish-NAVApp -ServerInstance $NewBcServerInstance -Name 'UPD19' -version '1.0.0.2'
uninstall-navapp -ServerInstance $NewBcServerInstance -name 'UPD19' -Version '1.0.0.2'
# Fin Fix JA

# Actualizar Addins
Set-NAVAddIn -ServerInstance $NewBcServerInstance -AddinName 'Microsoft.Dynamics.Nav.Client.BusinessChart' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'BusinessChart\Microsoft.Dynamics.Nav.Client.BusinessChart.zip')
Set-NAVAddIn -ServerInstance $NewBcServerInstance -AddinName 'Microsoft.Dynamics.Nav.Client.FlowIntegration' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'FlowIntegration\Microsoft.Dynamics.Nav.Client.FlowIntegration.zip')
Set-NAVAddIn -ServerInstance $NewBcServerInstance -AddinName 'Microsoft.Dynamics.Nav.Client.OAuthIntegration' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'OAuthIntegration\Microsoft.Dynamics.Nav.Client.OAuthIntegration.zip')
Set-NAVAddIn -ServerInstance $NewBcServerInstance -AddinName 'Microsoft.Dynamics.Nav.Client.PageReady' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'PageReady\Microsoft.Dynamics.Nav.Client.PageReady.zip')
Set-NAVAddIn -ServerInstance $NewBcServerInstance -AddinName 'Microsoft.Dynamics.Nav.Client.PowerBIManagement' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'PowerBIManagement\Microsoft.Dynamics.Nav.Client.PowerBIManagement.zip')
Set-NAVAddIn -ServerInstance $NewBcServerInstance -AddinName 'Microsoft.Dynamics.Nav.Client.RoleCenterSelector' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'RoleCenterSelector\Microsoft.Dynamics.Nav.Client.RoleCenterSelector.zip')
Set-NAVAddIn -ServerInstance $NewBcServerInstance -AddinName 'Microsoft.Dynamics.Nav.Client.SatisfactionSurvey' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'SatisfactionSurvey\Microsoft.Dynamics.Nav.Client.SatisfactionSurvey.zip')
Set-NAVAddIn -ServerInstance $NewBcServerInstance -AddinName 'Microsoft.Dynamics.Nav.Client.SocialListening' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'SocialListening\Microsoft.Dynamics.Nav.Client.SocialListening.zip')
Set-NAVAddIn -ServerInstance $NewBcServerInstance -AddinName 'Microsoft.Dynamics.Nav.Client.VideoPlayer' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'VideoPlayer\Microsoft.Dynamics.Nav.Client.VideoPlayer.zip')
Set-NAVAddIn -ServerInstance $NewBcServerInstance -AddinName 'Microsoft.Dynamics.Nav.Client.WebPageViewer' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'WebPageViewer\Microsoft.Dynamics.Nav.Client.WebPageViewer.zip')
Set-NAVAddIn -ServerInstance $NewBcServerInstance -AddinName 'Microsoft.Dynamics.Nav.Client.WelcomeWizard' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'WelcomeWizard\Microsoft.Dynamics.Nav.Client.WelcomeWizard.zip')

# Habilitamos Scheduler durante la migración
Set-NavServerConfiguration -ServerInstance $NewBcServerInstance -KeyName "EnableTaskScheduler" -KeyValue true

# Cambiamos la versión en la BD
Set-NAVApplication -ServerInstance $NewBcServerInstance -ApplicationVersion $NewVersion -Force
Sync-NAVTenant -ServerInstance $NewBcServerInstance  -Mode Sync

Restart-NAVServerInstance -ServerInstance $NewBcServerInstance






# Comprobar que no queden Apps de versiones antiguas
Get-NAVAppInfo -ServerInstance $NewBcServerInstance | Select-Object Name, Version

# Sincronizar todas las APPs
Get-NAVAppInfo -ServerInstance $NewBcServerInstance | % { Sync-NAVApp -ServerInstance $NewBcServerInstance -Name $_.Name -Version $_.Version }

# Finalizamos migración con este comando
Start-NavDataUpgrade -ServerInstance $NewBcServerInstance -FunctionExecutionMode Serial -ContinueOnError
Get-NAVDataUpgrade # Comprobar progreso

# comprobar versión y State
Get-NAVApplication $NewBcServerInstance
Get-NAVServerInstance $NewBcServerInstance
Get-NAVTenant $NewBcServerInstance # Comprobamos que el estado este operational





# Crear nueva instancia Web

    $NameWebInstance = "URZ190upg" # Nombre de la nueva instancia Web
    $NameServer = "localhost" # Nombre del servidor
    $NameServerInstance = "URZ190upg" # Nombre de la instancia de BC
    $ClientServicesPort = 7046 # Puerto servicio cliente BC
    $ManagementServicesPort = 7049 # Puerto servici gestión BC
    $WebSitePort = 8080 # Puerto de la instancia Web


    # Subsitio
    New-NAVWebServerInstance -WebServerInstance $NameWebInstance -Server $NameServer -ServerInstance $NameServerInstance -SiteDeploymentType Subsite -ContainerSiteName “Microsoft Dynamics 365 Business Central Web Client” -WebSitePort $WebSitePort


#Eliminar instancia Web antigua
Remove-NAVWebServerInstance -WebServerInstance URZ190

# Comprobar usuarios
Get-NAVServerUser -ServerInstance $NewBcServerInstance

# Crear Usuario

$InstanciaBC = "URZ190" # Instancia BC
$UsuarioBC = "urzante\tipsa" # Usuario a crear
$tenant= "vnt170base"

New-NAVServerUser $InstanciaBC  -Windowsaccount $UsuarioBC
New-NavServerUserPermissionSet  -Windowsaccount $UsuarioBC -ServerInstance $InstanciaBC -PermissionSetId SUPER