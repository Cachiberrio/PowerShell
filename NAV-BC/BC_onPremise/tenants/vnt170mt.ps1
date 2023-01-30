
# Conectar servidor remoto
$Remoto = "vnt170mt.tipsa.cloud" # Nombre del equipo al que conectarse, poner el dominio completo, por ejemplo nav2015.tipsa.local. Equipos disponibles: nav2015.# tipsa.local, nav2017.tipsa.local, bc365.tipsa.local y bc160.tipsa.local
$username = 'nav-tipsa' # Usuario Windows para acceder al servidor remoto
$pass = ''

$pass = ConvertTo-SecureString -string $pass -AsPlainText -Force
$cred = New-Object -typename System.Management.Automation.PSCredential -argumentlist $username, $pass
#$Cred = Get-Credential
$sessionOptions = New-PSSessionOption -IncludePortInSPN
Enter-PSSession -Computername $Remoto -SessionOption $sessionOptions -credential $Cred -UseSSL

$InstaciaSQL = 'sql2vnt170mt.database.windows.net' # Servidor Azure SQL
$UsuarioSQL = 'Sql-tipsa' # Usuario para conectar con la BD en Azure
$PassSQL = '' # Contraseña del usuario
$RutaLicencia = '' # Ruta de la licencia a subir
$RutaClaveCifrado = 'c:\Usuarios\Nav-tipsa\Descargas\vnt170mt_DynamicsNAV.key' # Ruta para generar la clave de cifrado
$PassClaveCifrado = "" # Contraseña de la clave de cifrado
$Instancia = "vnt" # Instancia de BC
$DB = "FRR170" # Base de datos de SQL
$tenant = "FRR"

$RutaModulo = "C:\Program Files\Microsoft Dynamics 365 Business Central\170\Service\NavAdminTool.ps1" # Ruta del módulo PS de BC

$UsuarioBC = "nav-tipsa" # Usuario a crear
$PassUsuarioBC = "P@ssw0rd" # Contraseña del nuevo Usuario





$Credentials = (New-Object PSCredential -ArgumentList $UsuarioSQL,(ConvertTo-SecureString -AsPlainText -Force $PassSQL))

Import-module $RutaModulo


Install-WindowsFeature -Name NET-HTTP-Activation

New-NAVEncryptionKey -KeyPath $RutaClaveCifrado -Password (ConvertTo-SecureString -AsPlainText -Force $PassClaveCifrado) -Force
Import-NAVEncryptionKey -ServerInstance $Instancia -ApplicationDatabaseServer $InstaciaSQL -ApplicationDatabaseCredentials $Credentials -ApplicationDatabaseName 'VNT170mt App' -KeyPath $RutaClaveCifrado -Password (ConvertTo-SecureString -AsPlainText -Force $PassClaveCifrado)


Start-NAVServerInstance –ServerInstance 'vnt'
Set-NAVServerConfiguration -DatabaseCredentials $Credentials -ServerInstance $Instancia -Force
Set-NAVServerConfiguration –ServerInstance $Instancia –element appSettings –KeyName 'DatabaseName' –KeyValue ''
Set-NAVServerConfiguration –ServerInstance $Instancia -KeyName ServicesCertificateThumbprint -KeyValue 'cc5413ae4659d8b65bd04f13cf534e8c450b94aa'
Set-NAVServerInstance $Instancia -start
Mount-NAVApplication –ServerInstance $Instancia –DatabaseServer $InstaciaSQL –DatabaseName 'VNT170mt App' -DatabaseCredentials $Credentials
Mount-NAVTenant –ServerInstance $Instancia -Id $tenant –DatabaseServer $InstaciaSQL -DatabaseName $DB -AlternateId @( "frr.tipsa.cloud") -OverwriteTenantIdInDatabase -AllowAppDatabaseWrite -DatabaseCredentials $Credentials

Mount-NAVTenant –ServerInstance $Instancia -Id BOM –DatabaseServer $InstaciaSQL -DatabaseName BOM170 -AlternateId @( "bom.tipsa.cloud") -OverwriteTenantIdInDatabase -AllowAppDatabaseWrite -DatabaseCredentials $Credentials


# Configuramos valores de la instancia idiome y zona horaria
$RutaLicencia = 'C:\Users\Nav-tipsa\Downloads\BOM.flf' # Ruta de la licencia a subir
$Tenant = 'BOM'
Import-NAVServerLicense $Instancia -LicenseFile $RutaLicencia  -Tenant $Tenant -database tenant # master
Restart-NAVServerInstance $Instancia



New-NAVServerUser $Instancia  -tenant $tenant -UserName $UsuarioBC -Password (ConvertTo-SecureString $PassUsuarioBC -AsPlainText -Force)
New-NavServerUserPermissionSet -tenant $tenant -username $UsuarioBC -ServerInstance $Instancia -PermissionSetId SUPER

# Otros
DisMount-NAVTenant –ServerInstance 'VNT' -Id BOM
remove-navserveruser -Tenant BPN -UserName NAV-TIPSA
GET-navserveruser -Tenant BLB
Export-NAVServerLicenseInformation