# Cambio de las opciones del servicio, cambio valores típicos

$NombreInstancia = "vnt"
$DefaultLanguage = "Es-es"
$LockoutPolicyFailedAuthenticationCount = 20
$LockoutPolicyFailedAuthenticationWindow = 20
$ServicesDefaultTimeZone = "Server Time Zone"
$ServicesLanguage = "es-es"
$ServicesUseNTLMAuthentication = "true"
$ODataServicesEnabled = "false"
$SOAPServicesEnabled = "false"

Get-NAVServerConfiguration $Instancia

Set-NAVServerConfiguration $Instancia -KeyName DefaultLanguage -KeyValue $DefaultLanguage
Set-NAVServerConfiguration $Instancia -KeyName LockoutPolicyFailedAuthenticationCount -KeyValue $LockoutPolicyFailedAuthenticationCount
Set-NAVServerConfiguration $Instancia -KeyName LockoutPolicyFailedAuthenticationWindow -KeyValue $LockoutPolicyFailedAuthenticationWindow
Set-NAVServerConfiguration $Instancia -KeyName ServicesDefaultTimeZone -KeyValue $ServicesDefaultTimeZone
Set-NAVServerConfiguration $Instancia -KeyName ServicesLanguage -KeyValue $ServicesLanguage
Set-NAVServerConfiguration $Instancia -KeyName ServicesUseNTLMAuthentication -KeyValue $ServicesUseNTLMAuthentication
Set-NAVServerConfiguration $Instancia -KeyName ODataServicesEnabled -KeyValue $ODataServicesEnabled
Set-NAVServerConfiguration $Instancia -KeyName SOAPServicesEnabled -KeyValue $SOAPServicesEnabled

#Set-NAVServerConfiguration -DatabaseCredentials $Credentials -ServerInstance $Instancia -Force
#Set-NAVServerConfiguration $Instancia -KeyName DatabaseServer -KeyValue $InstaciaSQL -Force
#Set-NAVServerConfiguration $Instancia -KeyName DatabaseName -KeyValue $DB

Restart-NAVServerInstance $NombreInstancia
