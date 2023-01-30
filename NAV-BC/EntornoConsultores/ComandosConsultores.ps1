# Comando PowerShell de uso habitual para gestión instancias BC

# Script para conectar por PowerShell
$Remoto = "" # Nombre del equipo al que conectarse, poner el dominio completo, por ejemplo nav2015.tipsa.local. Equipos disponibles: nav2015.tipsa.local, nav2017.tipsa.local, bc365.tipsa.local, bc160.tipsa.local y vnt170mt.tipsa.local o equipos en Azure

$username = '' # Usuario Windows para acceder al servidor remoto
$pass = ''

$pass = ConvertTo-SecureString -string $pass -AsPlainText -Force
$cred = New-Object -typename System.Management.Automation.PSCredential -argumentlist $username, $pass
#$Cred = Get-Credential
$sessionOptions = New-PSSessionOption -IncludePortInSPN
Enter-PSSession -Computername $Remoto -SessionOption $sessionOptions -credential $Cred


# Importar módulo administración de BC, cambiar la versión en la ruta si es necesario
Import-Module "C:\Program Files\Microsoft Dynamics 365 Business Central\170\service\NavAdminTool.ps1"


# Importar nueva licencia y reiniciar servicio

$NombreInstancia ="" # Nombre instancia BC
$RutaLicencia = "" # Ruta y nombre del fichero de licencia a importar
$NombreDatabase = "" # Nombre de la BD de la instancia, si se pone master se importará a todas las BBDD


Import-NAVServerLicense $NombreInstancia -LicenseFile $RutaLicencia  -Database $NombreDatabase # master
Restart-NAVServerInstance $NombreInstancia


# Implantar paquetes rapistart

$RutaPaquete = "c:\compartida\VNTCONFIG.rapidstart" # fichero rapistart
$ServerInstance = "vnt" # instancia BC

Import-NAVConfigurationPackageFile -Path $RutaPaquete -ServerInstance $ServerInstance
# Si es en una implantación multi tenant hay que habilitar el paquete por el cliente web


# Crear usuarios Nativos  SUPER de BC -

$InstanciaBC = "" # Instancia BC
$tenant= ""
$UsuarioBC = "" # Usuario a crear
$PassUsuarioBC = "" # Contraseña del nuevo Usuario

New-NAVServerUser $InstanciaBC  -tenant $tenant -UserName $UsuarioBC -Password (ConvertTo-SecureString $PassUsuarioBC -AsPlainText -Force)
New-NavServerUserPermissionSet -tenant $tenant -username $UsuarioBC -ServerInstance $InstanciaBC -PermissionSetId SUPER

# Crear usuarios Windows  SUPER de BC -

$InstanciaBC = "" # Instancia BC
$UsuarioBC = "" # Usuario a crear
$tenant= ""

New-NAVServerUser $InstanciaBC  -tenant $tenant -Windowsaccount $UsuarioBC
New-NavServerUserPermissionSet  -tenant $tenant -Windowsaccount $UsuarioBC -ServerInstance $InstanciaBC -PermissionSetId SUPER

# Eliminar todos los usuarios y personalizaciones de una BD BC - desde el Management Studio
# Comando T-SQL
TRUNCATE TABLE "User Personalization";
TRUNCATE TABLE "User Property";
TRUNCATE TABLE "Access Control";
TRUNCATE TABLE "User";


# Listar empresas
# https://docs.microsoft.com/en-us/powershell/module/microsoft.dynamics.nav.management/get-navcompany?view=businesscentral-ps-18

Get-NAVCompany -ServerInstance BC


# Exportar empresa
# https://docs.microsoft.com/en-us/powershell/module/microsoft.dynamics.nav.management/export-navdata?view=businesscentral-ps-18

Export-NAVData -ServerInstance BC -CompanyName "Company A" -FilePath C:\file\Companies.navdata


# Importar empresa
# https://docs.microsoft.com/en-us/powershell/module/microsoft.dynamics.nav.management/import-navdata?view=businesscentral-ps-18

Import-NAVData -ServerInstance BC -CompanyName "CRONUS International Ltd.", "My Company" -IncludeGlobalData -FilePath C:\file\CompaniesAndGlobalData.navdata

# Copiar empresa
https://docs.microsoft.com/en-us/powershell/module/microsoft.dynamics.nav.management/copy-navcompany?view=businesscentral-ps-18

Copy-NAVCompany -ServerInstance BC -DestinationCompanyName 'Cronus Subsidiary' -SourceCompanyName 'Cronus International Ltd.'

