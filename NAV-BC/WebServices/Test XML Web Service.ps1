$NombreServicioWeb = "http://hoth:7047/BAI2009R2_Pruebas/WS/Baigorri%20(Local)/Codeunit/NAV_TPV_Web_Services" # Con Nombre empresa y Nombre Servicio Web Publicado
$NombreRootXMLPort = 'Root_TPVProductos'
# =================================================================================================================================================================
cls
$webservice = New-WebServiceProxy -Uri $NombreServicioWeb -UseDefaultCredential true
$webservice.Timeout = 7200000
$Entorno = $WebService.getType().Namespace
$Salida = ($Entorno + '.' + $NombreRootXMLPort)
$XMLPort = New-Object $Salida;
$webservice.NAVtoTPV_Productos('01',[ref] $XMLPort)  # A modificar en todos los casos con el Nombre de la función. Ojo con los parámetros
$XMLPort.TPVProductos | Out-GridView                 # A modificar en todos los casos con el Nombre del Elemento Table del XMLPort que se quiere mostrar