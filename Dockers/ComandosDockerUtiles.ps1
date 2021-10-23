# Listar contenedores creados
docker ps -a
 
# Listar contenedores en ejecución
docker ps
 
# Arrancar contenedor
Docker start <id contenedor o nombre>
 
# Parar contenedor
Docker stop  <id contenedor o nombre>
 
# Borrar Contenedor
Docker rm  <id contenedor o nombre>

# Borrado completo de todo lo descargado y creado con Docker – Limpieza general
docker system prune

# Sincronización del servicio NAV del docker (el nombre del servicio suele ser NAV)
Sync-NavTenant <Nombre del servicio> 

# Reinicio del servicio NAV del docker (el nombre del servicio suele ser NAV)
Set-NAVServerInstance <Nombre del servicio> -Restart

# Desinstalar NavContainer Helper
Uninstall-Module NavContainerHelper -force

# Instalar BcContainer Helper (a veces es necesario desinstalar NavContainerHelper)
Install-Module BcContainerHelper -force -AllowClobber

# Desinstalar BcContainer Helper
Uninstall-Module BcContainerHelper -force

#Creación container BC140 CU15 (Actualizado 22/10/21)
$containerName = 'bc14cu15'
$password = 'P@ssw0rd'
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object pscredential 'admin', $securePassword
$auth = 'UserPassword'
$artifactUrl = Get-BcArtifactUrl -type 'OnPrem' -version '14.15.43800.0' -country 'es' -select 'Latest'
$licenseFile = 'c:\Compartida\TIPSA_Perpetual.flf'
New-BcContainer `
    -accept_eula `
    -containerName $containerName `
    -credential $credential `
    -auth $auth `
    -artifactUrl $artifactUrl `
    -licenseFile $licenseFile `
    -includeCSIDE `
    -updateHosts
