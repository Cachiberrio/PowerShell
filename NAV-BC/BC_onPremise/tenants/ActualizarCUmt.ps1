# Script para actualziación de CU en multitenant
# https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/upgrade/upgrading-cumulative-update-v17

# BD APP
# VNT170mt App:
# Tenants:
# - FRR170
# - BLB170
# - BPN170
# - FLS170
# - BOM170

# Conectamos al PS remoto
# Conectar servidor remoto
$Remoto = "vnt170mt.tipsa.cloud" # Nombre del equipo al que conectarse, poner el dominio completo, por ejemplo nav2015.tipsa.local. Equipos disponibles: nav2015.# tipsa.local, nav2017.tipsa.local, bc365.tipsa.local y bc160.tipsa.local
$username = '' # Usuario Windows para acceder al servidor remoto
$pass = ''

$pass = ConvertTo-SecureString -string $pass -AsPlainText -Force
$cred = New-Object -typename System.Management.Automation.PSCredential -argumentlist $username, $pass
#$Cred = Get-Credential
$sessionOptions = New-PSSessionOption -IncludePortInSPN
Enter-PSSession -Computername $Remoto -SessionOption $sessionOptions -credential $Cred -UseSSL

# Importar módulo admin
Import-Module "C:\Program Files\Microsoft Dynamics 365 Business Central\170\service\NavAdminTool.ps1"

$Instancia = 'vnt'
$ApplicationDatabaseServer = 'sql2vnt170mt.database.windows.net'
$ApplicationDatabaseName = 'VNT170mt AppRec'
#$InstaciaSQL = 'sql2vnt170mt.database.windows.net' # Servidor Azure SQL
$UsuarioSQL = '' # Usuario para conectar con la BD en Azure
$PassSQL = '' # Contraseña del usuario

$RutaLicencia = 'C:\Users\Nav-tipsa\Downloads\TIPSA.flf' # Ruta y nombre del fichero de licencia a importar


$ApplicationDatabaseCredentials = (New-Object PSCredential -ArgumentList $UsuarioSQL,(ConvertTo-SecureString -AsPlainText -Force $PassSQL))


# Paso 1 - Backup BBDD App y Data
# BD APP:
# VNT170mt App ok
# Tenants:
# - FRR170 ok
# - BLB170 ok
# - BPN170 ok
# - FLS170 ok
# - BOM170 ok
# - Backup Carpeta ejecutables - Instantanea MV vnt170mt ok

# Paso 2 - unpublish the system symbols
    Import-NAVServerLicense $Instancia  -LicenseFile $RutaLicencia  -Database NavDatabase
    Restart-NAVServerInstance $Instancia

Unpublish-NAVApp -ServerInstance $instancia -Name System

# Listamos extensiones instaladas
Get-NAVAppInfo -ServerInstance $instancia # copiamos el resultado


# Desinstalamos todas las extensiones de todos los tenants

Get-NAVAppInfo -ServerInstance $instancia  | ForEach-Object { Uninstall-NAVApp -ServerInstance $instancia -tenant FRR -Name $_.Name -Version $_.Version -Force}
Get-NAVAppInfo -ServerInstance $instancia  | ForEach-Object { Uninstall-NAVApp -ServerInstance $instancia -tenant BLB -Name $_.Name -Version $_.Version -Force}
Get-NAVAppInfo -ServerInstance $instancia  | ForEach-Object { Uninstall-NAVApp -ServerInstance $instancia -tenant BPN -Name $_.Name -Version $_.Version -Force}
Get-NAVAppInfo -ServerInstance $instancia  | ForEach-Object { Uninstall-NAVApp -ServerInstance $instancia -tenant FLS -Name $_.Name -Version $_.Version -Force}
Get-NAVAppInfo -ServerInstance $instancia  | ForEach-Object { Uninstall-NAVApp -ServerInstance $instancia -tenant BOM -Name $_.Name -Version $_.Version -Force}

# Para eliminar referencias de extensiones en tenants antiguos, desde Manager SQL
#TRUNCATE TABLE "Installed Application";
#


# Paso 3  - Desmontar BBDD datos de tenants
Dismount-NAVTenant -ServerInstance $instancia -Tenant FRR
Dismount-NAVTenant -ServerInstance $instancia -Tenant BLB
Dismount-NAVTenant -ServerInstance $instancia -Tenant BPN
Dismount-NAVTenant -ServerInstance $instancia -Tenant FLS
Dismount-NAVTenant -ServerInstance $instancia -Tenant BOM
# Paso 4 - Paramos instancia
Stop-NAVServerInstance -ServerInstance $Instancia
# Paso 5 - Desinstalamos BC desde agregar o quitar programas

# Paso 6 - Instalamos nueva versión BC desde instalador - seleccionamos fichero de configuración guardado de la instalación - Con la BD en blanco
# En el fichero de configuración el parámetro "PostponeServerStartup" Value="false"
# Desconectar Powershell para cargar el módulo de la nueva versión
# Al reinstalar se pierde la modificación de web.config para la ruta de acceso a los Tenants
# Al reinstalar se pierde la configuración de la instancia: idiomas, zona horaria, etc. Pendiente cambiarlo desde comando
# REcargar Parámetros iniciales
Set-NAVServerConfiguration -ServerInstance $Instancia -KeyName ServicesLanguage -KeyValue 'es-ES'
Set-NAVServerConfiguration -ServerInstance $Instancia -KeyName DefaultLanguage -KeyValue 'es-ES'
Set-NAVServerConfiguration -ServerInstance $Instancia -KeyName ServicesDefaultTimeZone -KeyValue 'Server Time Zone'



# Paso 6.1 - Convertimos la bd de aplicación a la nueva versión
Invoke-NAVApplicationDatabaseConversion -DatabaseServer $ApplicationDatabaseServer -DatabaseName $ApplicationDatabaseName -ApplicationDatabaseCredentials $ApplicationDatabaseCredentials
# Si da el error There are records in the Installed Application table, comprobar en la tabla Installed Application que no han quedado referencias
# a tenants que ya no existen. Si hya eliminarlas con el siguiente T-SQL TRUNCATE TABLE "Installed Application"


# Paso 7 - Conectamos BD en la instancia
Set-NAVServerConfiguration -ServerInstance $Instancia -KeyName DatabaseName -KeyValue $ApplicationDatabaseName
Set-NAVServerConfiguration -ServerInstance $Instancia -KeyName DatabaseServer -KeyValue $ApplicationDatabaseServer
Set-NAVServerConfiguration $Instancia -KeyName EnableSqlConnectionEncryption -KeyValue true
Set-NAVServerConfiguration -DatabaseCredentials $ApplicationDatabaseCredentials -ServerInstance $Instancia -Force
Set-NAVServerConfiguration –ServerInstance $Instancia -KeyName ServicesCertificateThumbprint -KeyValue 'cc5413ae4659d8b65bd04f13cf534e8c450b94aa'

$RutaClaveCifrado = 'c:\Usuarios\Nav-tipsa\Descargas\vnt170mt_DynamicsNAV.key' # Ruta para generar la clave de cifrado
$PassClaveCifrado = 'P@ss_mt17o' # Contraseña de la clave de cifrado


New-NAVEncryptionKey -KeyPath $RutaClaveCifrado -Password (ConvertTo-SecureString -AsPlainText -Force $PassClaveCifrado) -Force
Import-NAVEncryptionKey -ServerInstance $Instancia -ApplicationDatabaseServer $ApplicationDatabaseServer -ApplicationDatabaseName 'VNT170mt AppRec' -ApplicationDatabaseCredentials $ApplicationDatabaseCredentials -KeyPath $RutaClaveCifrado -Password (ConvertTo-SecureString -AsPlainText -Force $PassClaveCifrado) -Force


Start-NAVServerInstance –ServerInstance $Instancia


# Paso 8 - Publicamos nuevos Symbols - ruta DVD ModernDev\program files\Microsoft Dynamics NAV\170\AL Development Environment folder
Publish-NAVApp -ServerInstance $Instancia -Path 'C:\Users\Nav-tipsa\Downloads\BC170Cu02\ModernDev\program files\Microsoft Dynamics NAV\170\AL Development Environment\System.app' -PackageType SymbolsOnly
# Paso 9 - REcompilar extensiones publicadas
Get-NAVAppInfo -ServerInstance $Instancia | Repair-NAVApp



# Paso 10  - Montar BBDD datos de tenants
Set-NAVServerConfiguration -ServerInstance $Instancia -KeyName Multitenant -KeyValue $True
Restart-NAVServerInstance -ServerInstance $Instancia

#Eliminar tenant
Remove-NAVTenant -ServerInstance vnt -Tenant BOM -DatabaseServer $ApplicationDatabaseServer -Credentials $ApplicationDatabaseCredentials -ApplicationDatabaseName 'VNT170mt App2'

#


Mount-NAVTenant –ServerInstance $instancia -Id FRR –DatabaseServer $ApplicationDatabaseServer -DatabaseName 'FRR170Rec' -AlternateId @( "frr.tipsa.cloud") -OverwriteTenantIdInDatabase -DatabaseCredentials $ApplicationDatabaseCredentials
Mount-NAVTenant –ServerInstance $instancia -Id BLB –DatabaseServer $ApplicationDatabaseServer -DatabaseName 'BLB170Rec' -AlternateId @( "blb.tipsa.cloud") -OverwriteTenantIdInDatabase -DatabaseCredentials $ApplicationDatabaseCredentials
Mount-NAVTenant –ServerInstance $instancia -Id BPN –DatabaseServer $ApplicationDatabaseServer -DatabaseName 'BPN170Rec' -AlternateId @( "bpn.tipsa.cloud") -OverwriteTenantIdInDatabase -DatabaseCredentials $ApplicationDatabaseCredentials
Mount-NAVTenant –ServerInstance $instancia -Id FLS –DatabaseServer $ApplicationDatabaseServer -DatabaseName 'FLS170Rec' -AlternateId @( "fls.tipsa.cloud") -OverwriteTenantIdInDatabase -DatabaseCredentials $ApplicationDatabaseCredentials
Mount-NAVTenant –ServerInstance $instancia -Id BOM –DatabaseServer $ApplicationDatabaseServer -DatabaseName 'BOM170Rec' -AlternateId @( "bom.tipsa.cloud") -OverwriteTenantIdInDatabase -DatabaseCredentials $ApplicationDatabaseCredentials

Sync-NAVTenant -ServerInstance $Instancia -Tenant FRR -Mode Sync
Sync-NAVTenant -ServerInstance $Instancia -Tenant BLB -Mode Sync
Sync-NAVTenant -ServerInstance $Instancia -Tenant BPN -Mode Sync
Sync-NAVTenant -ServerInstance $Instancia -Tenant FLS -Mode Sync
Sync-NAVTenant -ServerInstance $Instancia -Tenant BOM -Mode Sync


# Actualizar APPLICATION
Publish-NAVApp -ServerInstance $Instancia -Path "C:\Users\Nav-tipsa\Downloads\BC170Cu02\Applications\System Application\Source\Microsoft_System Application.app"

Get-NavAppTenant -ServerInstance vnt -Name 'System Application'

Sync-NAVApp -ServerInstance $Instancia -Name "System Application" -Tenant FRR -version '17.2.19367.19735'
Sync-NAVApp -ServerInstance $Instancia -Name "System Application" -Tenant BLB -version '17.2.19367.19735'
Sync-NAVApp -ServerInstance $Instancia -Name "System Application" -Tenant BPN -version '17.2.19367.19735'
Sync-NAVApp -ServerInstance $Instancia -Name "System Application" -Tenant FLS -version '17.2.19367.19735'
Sync-NAVApp -ServerInstance $Instancia -Name "System Application" -Tenant BOM -version '17.2.19367.19735'


Start-NAVAppDataUpgrade -ServerInstance $Instancia -Tenant FRR -Name "System Application" -version '17.2.19367.19735'
Start-NAVAppDataUpgrade -ServerInstance $Instancia -Tenant BLB -Name "System Application" -version '17.2.19367.19735'
Start-NAVAppDataUpgrade -ServerInstance $Instancia -Tenant BPN -Name "System Application" -version '17.2.19367.19735'
Start-NAVAppDataUpgrade -ServerInstance $Instancia -Tenant FLS -Name "System Application" -version '17.2.19367.19735'
Start-NAVAppDataUpgrade -ServerInstance $Instancia -Tenant BOM -Name "System Application" -version '17.2.19367.19735'

Publish-NAVApp -ServerInstance $Instancia -Path "C:\Users\nav-tipsa\Downloads\BC170CU02\Applications\BaseApp\Source\Microsoft_Base Application.app"

Sync-NAVApp -ServerInstance $Instancia -Tenant FRR -Name "Base Application" -version '17.2.19367.19735'
Sync-NAVApp -ServerInstance $Instancia -Tenant BLB -Name "Base Application" -version '17.2.19367.19735'
Sync-NAVApp -ServerInstance $Instancia -Tenant BPN -Name "Base Application" -version '17.2.19367.19735'
Sync-NAVApp -ServerInstance $Instancia -Tenant FLS -Name "Base Application" -version '17.2.19367.19735'
Sync-NAVApp -ServerInstance $Instancia -Tenant BOM -Name "Base Application" -version '17.2.19367.19735'

Start-NAVAppDataUpgrade -ServerInstance $Instancia -Tenant FRR -Name "Base Application" -version '17.2.19367.19735'
Start-NAVAppDataUpgrade -ServerInstance $Instancia -Tenant BLB -Name "Base Application" -version '17.2.19367.19735'
Start-NAVAppDataUpgrade -ServerInstance $Instancia -Tenant BPN -Name "Base Application" -version '17.2.19367.19735'
Start-NAVAppDataUpgrade -ServerInstance $Instancia -Tenant FLS -Name "Base Application" -version '17.2.19367.19735'
Start-NAVAppDataUpgrade -ServerInstance $Instancia -Tenant BOM -Name "Base Application" -version '17.2.19367.19735'


Publish-NAVApp -ServerInstance $Instancia -Path "C:\Users\nav-tipsa\Downloads\BC170CU02\Applications\Application\source\Microsoft_Application.app"

Sync-NAVApp -ServerInstance $Instancia -Tenant FRR -Name "Application" -version '17.2.19367.19735'
Sync-NAVApp -ServerInstance $Instancia -Tenant BLB -Name "Application" -version '17.2.19367.19735'
Sync-NAVApp -ServerInstance $Instancia -Tenant BPN -Name "Application" -version '17.2.19367.19735'
Sync-NAVApp -ServerInstance $Instancia -Tenant FLS -Name "Application" -version '17.2.19367.19735'
Sync-NAVApp -ServerInstance $Instancia -Tenant BOM -Name "Application" -version '17.2.19367.19735'

Start-NAVAppDataUpgrade -ServerInstance $Instancia -Tenant FRR -Name "Application" -version '17.2.19367.19735'
Start-NAVAppDataUpgrade -ServerInstance $Instancia -Tenant BLB -Name "Application" -version '17.2.19367.19735'
Start-NAVAppDataUpgrade -ServerInstance $Instancia -Tenant BPN -Name "Application" -version '17.2.19367.19735'
Start-NAVAppDataUpgrade -ServerInstance $Instancia -Tenant FLS -Name "Application" -version '17.2.19367.19735'
Start-NAVAppDataUpgrade -ServerInstance $Instancia -Tenant BOM -Name "Application" -version '17.2.19367.19735'


# Publicamos Extensiones de Microsoft desde la carpeta: C:\Users\admin_dev\Downloads\CU02\Applications
Publish-NAVApp -ServerInstance $Instancia -Path "C:\Users\nav-tipsa\Downloads\BC170CU02\Applications\companyHub\Source\Microsoft_Company Hub.app"
$NombreApp = 'Company Hub'

Sync-NAVApp -ServerInstance $Instancia -Tenant FRR -Name $NombreApp -version '17.2.19367.19735'
Sync-NAVApp -ServerInstance $Instancia -Tenant BLB -Name $NombreApp -version '17.2.19367.19735'
Sync-NAVApp -ServerInstance $Instancia -Tenant BPN -Name $NombreApp -version '17.2.19367.19735'
Sync-NAVApp -ServerInstance $Instancia -Tenant FLS -Name $NombreApp -version '17.2.19367.19735'
Sync-NAVApp -ServerInstance $Instancia -Tenant BOM -Name $NombreApp -version '17.2.19367.19735'

Start-NAVAppDataUpgrade $Instancia -Tenant FRR -Name $NombreApp -version '17.2.19367.19735'
Start-NAVAppDataUpgrade $Instancia -Tenant BLB -Name $NombreApp -version '17.2.19367.19735'
Start-NAVAppDataUpgrade $Instancia -Tenant BPN -Name $NombreApp -version '17.2.19367.19735'
Start-NAVAppDataUpgrade $Instancia -Tenant FLS -Name $NombreApp -version '17.2.19367.19735'
Start-NAVAppDataUpgrade $Instancia -Tenant BOM -Name $NombreApp -version '17.2.19367.19735'

Install-NAVApp -ServerInstance  $Instancia -Name $NombreApp -Tenant 'fls' -version '17.2.19367.19735'
Install-NAVApp -ServerInstance  $Instancia -Name $NombreApp -Tenant 'frr' -version '17.2.19367.19735'
Install-NAVApp -ServerInstance  $Instancia -Name $NombreApp -Tenant 'bpn' -version '17.2.19367.19735'
Install-NAVApp -ServerInstance  $Instancia -Name $NombreApp -Tenant 'blb' -version '17.2.19367.19735'
Install-NAVApp -ServerInstance  $Instancia -Name $NombreApp -Tenant 'bom' -version '17.2.19367.19735'


Restart-NAVServerInstance -ServerInstance $Instancia

# Actualizar Add-ins
$ServicesAddinsFolder = 'C:\Program Files\Microsoft Dynamics 365 Business Central\170\Service\Add-ins'
Set-NAVAddIn -ServerInstance $Instancia -AddinName 'Microsoft.Dynamics.Nav.Client.BusinessChart' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $ServicesAddinsFolder 'BusinessChart\Microsoft.Dynamics.Nav.Client.BusinessChart.zip')
Set-NAVAddIn -ServerInstance $Instancia -AddinName 'Microsoft.Dynamics.Nav.Client.FlowIntegration' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $ServicesAddinsFolder 'FlowIntegration\Microsoft.Dynamics.Nav.Client.FlowIntegration.zip')
Set-NAVAddIn -ServerInstance $Instancia -AddinName 'Microsoft.Dynamics.Nav.Client.OAuthIntegration' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $ServicesAddinsFolder 'OAuthIntegration\Microsoft.Dynamics.Nav.Client.OAuthIntegration.zip')
Set-NAVAddIn -ServerInstance $Instancia -AddinName 'Microsoft.Dynamics.Nav.Client.PageReady' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $ServicesAddinsFolder 'PageReady\Microsoft.Dynamics.Nav.Client.PageReady.zip')
Set-NAVAddIn -ServerInstance $Instancia -AddinName 'Microsoft.Dynamics.Nav.Client.PowerBIManagement' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $ServicesAddinsFolder 'PowerBIManagement\Microsoft.Dynamics.Nav.Client.PowerBIManagement.zip')
Set-NAVAddIn -ServerInstance $Instancia -AddinName 'Microsoft.Dynamics.Nav.Client.RoleCenterSelector' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $ServicesAddinsFolder 'RoleCenterSelector\Microsoft.Dynamics.Nav.Client.RoleCenterSelector.zip')
Set-NAVAddIn -ServerInstance $Instancia -AddinName 'Microsoft.Dynamics.Nav.Client.SatisfactionSurvey' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $ServicesAddinsFolder 'SatisfactionSurvey\Microsoft.Dynamics.Nav.Client.SatisfactionSurvey.zip')
Set-NAVAddIn -ServerInstance $Instancia -AddinName 'Microsoft.Dynamics.Nav.Client.SocialListening' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $ServicesAddinsFolder 'SocialListening\Microsoft.Dynamics.Nav.Client.SocialListening.zip')
Set-NAVAddIn -ServerInstance $Instancia -AddinName 'Microsoft.Dynamics.Nav.Client.VideoPlayer' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $ServicesAddinsFolder 'VideoPlayer\Microsoft.Dynamics.Nav.Client.VideoPlayer.zip')
Set-NAVAddIn -ServerInstance $Instancia -AddinName 'Microsoft.Dynamics.Nav.Client.WebPageViewer' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $ServicesAddinsFolder 'WebPageViewer\Microsoft.Dynamics.Nav.Client.WebPageViewer.zip')
Set-NAVAddIn -ServerInstance $Instancia -AddinName 'Microsoft.Dynamics.Nav.Client.WelcomeWizard' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $ServicesAddinsFolder 'WelcomeWizard\Microsoft.Dynamics.Nav.Client.WelcomeWizard.zip')


# Actualizar versión de la application
Set-NAVServerConfiguration -ServerInstance $Instancia -KeyName SolutionVersionExtension -KeyValue 437dbf0e-84ff-417a-965d-ed2bb9650972 -ApplyTo All


# Instalamos nuestras extensiones

#publicar una extensión para todos los tenant
$Extension = 'C:\Users\nav-tipsa\Downloads\apps\ELAv2.app'

Publish-NAVApp -ServerInstance  $Instancia -Path $Extension -Scope Global -SkipVerification

#Sincronizar la app en todos los tenant (se debe poner instancia y tenant)
Sync-NAVApp -ServerInstance  $Instancia -Path $Extension -Tenant 'fls'
Sync-NAVApp -ServerInstance  $Instancia -Path $Extension -Tenant 'frr'
Sync-NAVApp -ServerInstance  $Instancia -Path $Extension -Tenant 'bpn'
Sync-NAVApp -ServerInstance  $Instancia -Path $Extension -Tenant 'blb'
Sync-NAVApp -ServerInstance  $Instancia -Path $Extension -Tenant 'bom'

#Instalar una app en todos los tenant (se debe poner instancia y tenant)
Install-NAVApp -ServerInstance  $Instancia -Path $Extension -Tenant 'fls'
Install-NAVApp -ServerInstance  $Instancia -Path $Extension -Tenant 'frr'
Install-NAVApp -ServerInstance  $Instancia -Path $Extension -Tenant 'bpn'
Install-NAVApp -ServerInstance  $Instancia -Path $Extension -Tenant 'blb'
Install-NAVApp -ServerInstance  $Instancia -Path $Extension -Tenant 'bom'

$Extension = 'C:\Users\nav-tipsa\Downloads\apps\LABv3.app'

Publish-NAVApp -ServerInstance  $Instancia -Path $Extension -Scope Global -SkipVerification

#Sincronizar la app en todos los tenant (se debe poner instancia y tenant)
Sync-NAVApp -ServerInstance  $Instancia -Path $Extension -Tenant 'fls'
Sync-NAVApp -ServerInstance  $Instancia -Path $Extension -Tenant 'frr'
Sync-NAVApp -ServerInstance  $Instancia -Path $Extension -Tenant 'bpn'
Sync-NAVApp -ServerInstance  $Instancia -Path $Extension -Tenant 'blb'
Sync-NAVApp -ServerInstance  $Instancia -Path $Extension -Tenant 'bom'

#Instalar una app en todos los tenant (se debe poner instancia y tenant)
Install-NAVApp -ServerInstance  $Instancia -Path $Extension -Tenant 'fls'
Install-NAVApp -ServerInstance  $Instancia -Path $Extension -Tenant 'frr'
Install-NAVApp -ServerInstance  $Instancia -Path $Extension -Tenant 'bpn'
Install-NAVApp -ServerInstance  $Instancia -Path $Extension -Tenant 'blb'
Install-NAVApp -ServerInstance  $Instancia -Path $Extension -Tenant 'bom'



Get-NAVAppInfo $Instancia

# Desinstalamos extensiones antiguas versión 17.1.18256.18474
Unpublish-NAVApp -ServerInstance $instancia -Name 'AMC Banking 365 Fundamentals' -version '17.1.18256.18474'
Unpublish-NAVApp -ServerInstance $instancia -Name 'Application' -version '17.1.18256.18474'
Unpublish-NAVApp -ServerInstance $instancia -Name 'Base Application' -version '17.1.18256.18474'
Unpublish-NAVApp -ServerInstance $instancia -Name 'Company Hub' -version '17.1.18256.18474'
Unpublish-NAVApp -ServerInstance $instancia -Name 'Email - Current User Connector' -version '17.1.18256.18474'
Unpublish-NAVApp -ServerInstance $instancia -Name 'Email - Microsoft 365 Connector' -version '17.1.18256.18474'
Unpublish-NAVApp -ServerInstance $instancia -Name 'Email - Outlook REST API' -version '17.1.18256.18474'
Unpublish-NAVApp -ServerInstance $instancia -Name 'Email - SMTP Connector' -version '17.1.18256.18474'
Unpublish-NAVApp -ServerInstance $instancia -Name 'Essential Business Headlines' -version '17.1.18256.18474'
Unpublish-NAVApp -ServerInstance $instancia -Name 'Late Payment Prediction' -version '17.1.18256.18474'
Unpublish-NAVApp -ServerInstance $instancia -Name 'PayPal Payments Standard' -version '17.1.18256.18474'
Unpublish-NAVApp -ServerInstance $instancia -Name 'Sales and Inventory Forecast' -version '17.1.18256.18474'
Unpublish-NAVApp -ServerInstance $instancia -Name 'Send To Email Printer' -version '17.1.18256.18474'
Unpublish-NAVApp -ServerInstance $instancia -Name 'System Application' -version '17.1.18256.18474'
Unpublish-NAVApp -ServerInstance $instancia -Name 'WorldPay Payments Standard' -version '17.1.18256.18474'

# Ponemos licencias correctas por tenant

$RutaLicencia = 'C:\Users\Nav-tipsa\Downloads\FRR.flf'
$tenant = 'FRR'
Import-NAVServerLicense $Instancia  -LicenseFile $RutaLicencia -tenant $tenant  -Database tenant

$RutaLicencia = 'C:\Users\Nav-tipsa\Downloads\FLS.flf'
$tenant = 'FLS'
Import-NAVServerLicense $Instancia  -LicenseFile $RutaLicencia -tenant $tenant  -Database tenant

$RutaLicencia = 'C:\Users\Nav-tipsa\Downloads\BOM.flf'
$tenant = 'BOM'
Import-NAVServerLicense $Instancia  -LicenseFile $RutaLicencia -tenant $tenant  -Database tenant

$RutaLicencia = 'C:\Users\Nav-tipsa\Downloads\BLB.flf'
$tenant = 'BLB'
Import-NAVServerLicense $Instancia  -LicenseFile $RutaLicencia -tenant $tenant  -Database tenant

$RutaLicencia = 'C:\Users\Nav-tipsa\Downloads\BPN.flf'
$tenant = 'BPN'
Import-NAVServerLicense $Instancia  -LicenseFile $RutaLicencia -tenant $tenant  -Database tenant


Restart-NAVServerInstance $Instancia

# Comando varios de apoyo
# Consultar tenants en la instancia
Get-NAVTenant -serverinstance $Instancia -ApplicationDatabaseServer $ApplicationDatabaseServer -ApplicationDatabaseCredentials $ApplicationDatabaseCredentials -ApplicationDatabaseName $ApplicationDatabaseName

# Listar extensiones publicadas
Get-NAVAppinfo -ServerInstance $Instancia

# NO temporales
Get-NAVAppInfo -ServerInstance $Instancia -Name 'Company Hub'
Repair-NAVApp -Name 'System Application'
Repair-NAVApp -Name 'Base Application'
Repair-NAVApp -Name 'Application'
Unpublish-NAVApp -ServerInstance $instancia -Name 'System Application' -version '17.2.19367.19735'

Get-NavAppTenant -ServerInstance vnt -Name 'Company Hub'
Sync-NAVTenant vnt -Mode ForceSync

Sync-NAVTenant -ServerInstance $Instancia -Tenant FRR -Mode ForceSync
Sync-NAVTenant -ServerInstance $Instancia -Tenant BLB -Mode ForceSync
Sync-NAVTenant -ServerInstance $Instancia -Tenant BPN -Mode ForceSync
Sync-NAVTenant -ServerInstance $Instancia -Tenant FLS -Mode ForceSync
Sync-NAVTenant -ServerInstance $Instancia -Tenant BOM -Mode ForceSync

Import-NAVServerLicense $Instancia -LicenseFile $RutaLicencia  -Tenant BOM -database tenant # master

# NO
