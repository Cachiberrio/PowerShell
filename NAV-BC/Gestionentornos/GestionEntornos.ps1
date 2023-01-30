# Script para gestionar entornos desarrollo / demo de Apps con dockers
# https://ricardopaiva.github.io/cheatsheet/business-central-bccontainerhelper-cheat-sheet/
# Requisitos:
# - Tener instalado y ejecutado Docker Desktop
# - Tener instalado y actualizado el módulo BcContainerHelper
# - Acceso a las rutas donde están las Apps


# Se reciben como parámetros:

# - App o familia a instalar
# - Tipo entorno: Dev / estable


# Parámetros fijos
$ListaApps = "\\tipsa.local\tipsa\Documentos\Desarrollo AL\Apps.xml"
# - Ruta licencia TIPSA
# - Credenciales conenedor
# - límite memoria docker
# - límite memoria SQL docker
# - isolation contenedor
# - copia seguridad BD


# Lectura fichero \\tipsa.local\tipsa\Documentos\Desarrollo AL\Apps.xml
# https://adamtheautomator.com/powershell-parse-xml/




# Creamos Docker - https://github.com/microsoft/navcontainerhelper/blob/master/ContainerHandling/New-NavContainer.ps1
# Parámetros:
$containerName = "test" # AppName o Familia+Tipo_Entorno_verBC¿?
$artifactUrl = (Get-BcArtifactUrl -type onprem -country es)
$credential = New-Object pscredential 'admin', (ConvertTo-SecureString -String 'P@ssword' -AsPlainText -Force)
$auth = "NavUserPassword"
$memoryLimit = '3G'
$sqlMemoryLimit = '500M'
$licenseFile = "\\coruscant\Compartida\Microsoft Dynamics 365 Business Central on premises_19.flf"
# isolation
# bakFile
$shortcuts = "Desktop" # None, Desktop or StartMenu ¿se crean accesos?

# includeAL Para opción dev¿?
# enableSymbolLoading ¿?
# enableTaskScheduler false - Por defecto está desactivado
# assignPremiumPlan ¿?
# includeTestToolkit - se necesita para dev ¿?
# myscripts
$finalizeDatabasesScriptBlock = {Import-BCContainerLicense c:\licencia.flf}




New-BcContainer -accept_eula -accept_outdated -containerName $containerName -artifactUrl $artifactUrl -credential $credential -memoryLimit $memoryLimit -sqlMemoryLimit $sqlMemoryLimit -updateHosts  -useSSL -installCertificateOnHost -alwaysPull -useBestContainerOS -doNotCheckHealth  -licenseFile $licenseFile -shortcuts $shortcuts#-finalizeDatabasesScriptBlock $finalizeDatabasesScriptBlock

New-BcContainer -accept_eula -containerName $containerName -artifactUrl $artifactUrl -credential $credential -updateHosts -alwaysPull -useBestContainerOS -shortcuts $shortcuts -memoryLimit $memoryLimit -auth $auth -useSSL -installCertificateOnHost


# Importamos nuestra licencia
Import-BCContainerLicense

# Instalamos Apps
Install-BCContainerApp  containerName appName appPublisher appVersion language force
Install-BcContainerApp -containerName test2 -appName myapp

