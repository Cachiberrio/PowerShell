
# Conectar servidor remoto
$Remoto = "vnt170mt.tipsa.local" # Nombre del equipo al que conectarse, poner el dominio completo, por ejemplo nav2015.tipsa.local. Equipos disponibles: nav2015.# tipsa.local, nav2017.tipsa.local, bc365.tipsa.local y bc160.tipsa.local
$username = '' # Usuario Windows para acceder al servidor remoto
$pass = ''

$pass = ConvertTo-SecureString -string $pass -AsPlainText -Force
$cred = New-Object -typename System.Management.Automation.PSCredential -argumentlist $username, $pass
#$Cred = Get-Credential
$sessionOptions = New-PSSessionOption -IncludePortInSPN
Enter-PSSession -Computername $Remoto -SessionOption $sessionOptions -credential $Cred

# Importar módulo admin
 Import-Module "C:\Program Files\Microsoft Dynamics 365 Business Central\170\service\NavAdminTool.ps1"


# Crear App database y borrar tablas de App de la BD - Usa como credencial el login "NT AUTHORITY\ANONYMOUS" - darlo temporalmente y quitarlo después del comando
Stop-NAVServerInstance –ServerInstance VNT
Export-NAVApplication –DatabaseServer 'VORTEX' –DatabaseInstance 'sql2k17' –DatabaseName 'FLS170' –DestinationDatabaseName 'VNT170mt App' -ServiceAccount "tipsa\servicios" | Remove-NAVApplication –DatabaseServer 'VORTEX' –DatabaseInstance 'sql2k17' –DatabaseName 'FLS170' -Force
Set-NAVServerConfiguration –ServerInstance 'VNT' –element appSettings –KeyName 'DatabaseName' –KeyValue ''
Start-NAVServerInstance –ServerInstance 'VNT'
Mount-NAVApplication –ServerInstance 'VNT' –DatabaseServer 'vortex\sql2k17' –DatabaseName 'VNT170mt App'
Mount-NAVTenant –ServerInstance 'VNT' -Id FLS –DatabaseServer 'VORTEX\sql2k17' -DatabaseName 'FLS170' -AlternateId @( "fls.tipsa.local") -OverwriteTenantIdInDatabase


# Añadir tenant
# Restauramos backup - si tiene datos de App los eliminamos
Mount-NAVTenant –ServerInstance 'VNT' -Id vnt170base –DatabaseServer 'VORTEX\sql2k17' -DatabaseName 'vnt170base' -AlternateId @( "vnt170base.tipsa.local") -OverwriteTenantIdInDatabase -AllowAppDatabaseWrite
#Remove-NAVApplication –DatabaseServer 'VORTEX' –DatabaseInstance 'sql2k17' –DatabaseName 'tenant' -Force
Sync-NAVTenant -ServerInstance vnt -Tenant vnt170base -Mode Sync

#Desmonatar tenant
Dismount-NAVTenant –ServerInstance 'VNT' -Id FLS

$InstaciaSQL = 'sql2vnt170mt.database.windows.net' # Servidor Azure SQL
$UsuarioSQL = 'Sql-tipsa' # Usuario para conectar con la BD en Azure
$PassSQL = 'P@ss_2o2o_VnTmt' # Contraseña del usuario
$Credentials = (New-Object PSCredential -ArgumentList $UsuarioSQL,(ConvertTo-SecureString -AsPlainText -Force $PassSQL))

mount-NAVTenant –ServerInstance 'VNT' -Id FLS –DatabaseServer $InstaciaSQL -DatabaseName 'FLS170' -AlternateId @( "fls.tipsa.local") -OverwriteTenantIdInDatabase -AllowAppDatabaseWrite -DatabaseCredentials $Credentials



New-NAVCompany -ServerInstance vnt -Tenant blb -CompanyName 'CRONUS'



Export-NAVData -ServerInstance vnt -Tenant FLS -FilePath "C:\Users\admin_dev\Desktop\empresas.navdata" -IncludeGlobalData -AllCompanies  -force
Import-NAVData -DatabaseServer 'vortex\sql2k17' -DatabaseName 'bpn170' -AllCompanies -ApplicationDatabaseServer 'vortex\sql2k17' -ApplicationDatabasename "VNT170mt App" -FilePath "C:\Users\admin_dev\Desktop\empresas.navdata"

Sync-NAVTenantDatabase -ServerInstance vnt -Id bpn -mode ForceSync



#Comandos varios info
Get-NAVWebServerInstance

Get-NAVTenant vnt


$InstaciaSQL = 'sql2vnt170mt.database.windows.net' # Servidor Azure SQL
$UsuarioSQL = 'Sql-tipsa' # Usuario para conectar con la BD en Azure
$PassSQL = 'P@ss_2o2o_VnTmt' # Contraseña del usuario
$Credentials = (New-Object PSCredential -ArgumentList $UsuarioSQL,(ConvertTo-SecureString -AsPlainText -Force $PassSQL))
Get-NAVTenant -ApplicationDatabaseServer $InstaciaSQL -ApplicationDatabaseCredentials $Credentials -ApplicationDatabaseName 'VNT170mt App'

Remove-NAVTenant -ServerInstance vnt -Tenant vnt170base -ApplicationDatabaseServer $InstaciaSQL -ApplicationDatabaseCredentials $Credentials -ApplicationDatabaseName 'VNT170mt App'

Get-NAVTenantDatabase

Export-NAVServerLicenseInformation



New-NAVCompany -ServerInstance vnt -Tenant bpn -CompanyName 'CRONUS Subsidiary'