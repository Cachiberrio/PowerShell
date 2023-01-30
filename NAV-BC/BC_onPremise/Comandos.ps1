# Comandos genéricos de Powershell para BC on-premise


# Crear nueva instancia BC

$Instancia = "VNT"
$ServiceAccountCredential = "P@ssw0rd99"
$ManagementServicesPort = 7045
$ClientServicesPort = 7046
$SOAPServicesPort = 7047
$ODataServicesPort = 7048
$UsuarioServicio = "tipsa\servicios"
$PassServicio = "P@ssw0rd99"

$ServiceAccountCredential = (New-Object PSCredential -ArgumentList $UsuarioServicio,(ConvertTo-SecureString -AsPlainText -Force $PassServicio))

New-NAVServerInstance $Instancia -Multitenant -ServiceAccount User -ServiceAccountCredential $ServiceAccountCredential -ManagementServicesPort $ManagementServicesPort -ClientServicesPort $ClientServicesPort -SOAPServicesPort $SOAPServicesPort -ODataServicesPort $ODataServicesPort -verbose

# Configurar parámetros instancia
Set-NAVServerConfiguration $Instancia -KeyName DatabaseServer -KeyValue $InstaciaSQL -Force
Set-NAVServerConfiguration $Instancia -KeyName DatabaseName -KeyValue $DB


# Crear nueva instancia Web

    $NameWebInstance = "" # Nombre de la nueva instancia Web
    $NameServer = "localhost" # Nombre del servidor
    $NameServerInstance = "" # Nombre de la instancia de BC
    $ClientServicesPort = 7046 # Puerto servicio cliente BC
    $ManagementServicesPort = 7049 # Puerto servici gestión BC
    $WebSitePort = 8080 # Puerto de la instancia Web

    Import-Module “C:\Program Files\Microsoft Dynamics 365 Business Central\160\Service\NAVAdminTool.ps1” -force

    # Carpeta root
    New-NAVWebServerInstance -WebServerInstance $NameWebInstance -Server $NameServer -ServerInstance $NameServerInstance -ClientServicesPort $ClientServicesPort -ManagementServicesPort $ManagementServicesPort -WebSitePort $WebSitePort

    # Subsitio
    New-NAVWebServerInstance -WebServerInstance $NameWebInstance -Server $NameServer -ServerInstance $NameServerInstance -SiteDeploymentType Subsite -ContainerSiteName “Microsoft Dynamics 365 Business Central Web Client” -WebSitePort $WebSitePort


# Devolver información licencia cargada
    $NombreInstancia ="" # Nombre instancia BC
    $Tenant = ''

    Export-NAVServerLicenseInformation $NombreInstancia -Tenant $Tenant


# Importar nueva licencia y reiniciar servicio
# Más info: https://docs.microsoft.com/en-us/powershell/module/microsoft.dynamics.nav.management/import-navserverlicense?view=businesscentral-ps-16

    $NombreInstancia ="" # Nombre instancia BC
    $RutaLicencia = "" # Ruta y nombre del fichero de licencia a importar
    $Tenant = ''

    Import-NAVServerLicense $NombreInstancia -Tenant $Tenant  -LicenseFile $RutaLicencia  -Database Tenant # master, NavDatabase o Tenant
    Restart-NAVServerInstance $NombreInstancia



# Crear usuarios Nativos  SUPER de BC -

    $InstanciaBC = "VNT" # Instancia BC
    $tenant= "bpn"
    $UsuarioBC = "nav-tipsa" # Usuario a crear
    $PassUsuarioBC = "P@ssw0rd" # Contraseña del nuevo Usuario

    New-NAVServerUser $InstanciaBC  -tenant $tenant -UserName $UsuarioBC -Password (ConvertTo-SecureString $PassUsuarioBC -AsPlainText -Force)
    New-NavServerUserPermissionSet -tenant $tenant -username $UsuarioBC -ServerInstance $InstanciaBC -PermissionSetId SUPER

# Crear usuarios Windows  SUPER de BC -

$InstanciaBC = "VNT" # Instancia BC
$UsuarioBC = "tipsa\dr" # Usuario a crear
$tenant= "vnt170base"

New-NAVServerUser $InstanciaBC  -tenant $tenant -Windowsaccount $UsuarioBC
New-NavServerUserPermissionSet  -tenant $tenant -Windowsaccount $UsuarioBC -ServerInstance $InstanciaBC -PermissionSetId SUPER

# Eliminar todos los usuarios y personalizaciones de una BD BC
# T-SQL
TRUNCATE TABLE "User Personalization";
TRUNCATE TABLE "User Property";
TRUNCATE TABLE "Access Control";
TRUNCATE TABLE "User";


# Cambiar el servicio para que comparta puerto

    ServiceInstance = "CRONUS160"
    sc.exe config (get-service  "*$ServiceInstance").Name depend= HTTP/NetTcpPortSharing


# Implantar paquetes rapistart

$RutaPaquete = "c:\compartida\VNTCONFIG.rapidstart" # fichero rapistart
$ServerInstance = "vnt" # instancia BC

Import-NAVConfigurationPackageFile -Path $RutaPaquete -ServerInstance $ServerInstance

# Para habilitar el paquete en un tenant
# No se puede hacer por PS, hay que ir por cliente Web
# TODO: Se puede utilzar la API: https://robberse-it-services.nl/blog/2019/06/11/importing-rapidstart-packages-with-automation-apis-demystified/


# Exportar empresa
$ServerInstance = "vnt"
$Tenant = "vnt170base"
$CompanyName = "VinoTEC Base" # empresa o empresas separadas por coma
$FilePath = "c:\compartida\vntbase.navdata"

Export-NAVData -ServerInstance $ServerInstance -Tenant $Tenant -CompanyName $CompanyName -FilePath $FilePath

# Importar empresa
$ServerInstance = "vnt"
$Tenant = "blb"
$CompanyName = "VinoTEC Base" # empresa o empresas separadas por coma
$FilePath = "c:\compartida\vntbase.navdata"

import-NAVData -ServerInstance $ServerInstance -Tenant $Tenant -AllCompanies -FilePath $FilePath -force


# Eliminar empresa
$ServerInstance = "vnt"
$Tenant = "blb"
$CompanyName = "VinoTEC Base" # empresa o empresas separadas por coma

Remove-NAVCompany -ServerInstance $ServerInstance -Tenant $Tenant -CompanyName $CompanyName

# Copiar empresa - Ejecutar en el servidor
$ServerInstance = ""
$DestinationCompanyName = ""
$SourceCompanyName = ""
$Path = "C:\Program Files\Microsoft Dynamics 365 Business Central\160\Service\NAVAdminTool.ps1"
Import-Module $Path -force

Copy-NAVCompany -ServerInstance $ServerInstance -DestinationCompanyName $DestinationCompanyName -SourceCompanyName $SourceCompanyName