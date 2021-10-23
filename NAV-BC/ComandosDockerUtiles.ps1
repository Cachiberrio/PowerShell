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

# Instalar BcContainer Helper
Install-Module BcContainerHelper -force -AllowClobber