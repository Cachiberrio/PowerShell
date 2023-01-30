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

# Acceso al visor de sucesos del contenedor
Get-BcContainerEventLog -containerName BC140

# to retrieve a snapshot of the event log from the container
Get-BcContainerEventLog -containerName BC140 

# to get debug information about the container
Get-BcContainerDebugInfo -containerName BC140 

# to open a PowerShell prompt inside the container
Enter-BcContainer -containerName BC140 

# to remove the container again
Remove-BcContainer -containerName BC140 

# to retrieve information about URL's again
docker logs BC140 

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


# Restauración de copia de seguridad en el docker
$SQLInstanceName  = 'BC140CU30\SQLEXPRESS'
$DatabaseName = 'CRONUS'
$BackupFileName = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\Backup\CRONUS.bak'
$DynamicsNAVServerName = 'MicrosoftDynamicsNavServer$NAV'

stop-service $DynamicsNAVServerName
invoke-sqlcmd -ServerInstance $SQLInstanceName -Query "Drop database CRONUS;"
restore-SqlDatabase -ServerInstance $SQLInstanceName -Database $DatabaseName -BackupFile $BackupFileName
start-service $DynamicsNAVServerName

