	# Crear y arrancar Contenedor con BC 14.0 Ãºltima CU
	# Crea accesos directos en el escritorio para las aplicaciones

	# Autentificación Windows
	#New-NavContainer -accept_eula -containerName "CRONUS140"  -imageName "mcr.microsoft.com/businesscentral/onprem:1904-es-ltsc2019" -includeCSide  -doNotExportObjectsToText -updateHosts -doNotCheckHealth -accept_outdated

#Requires -RunAsAdministrator

$User = "admin"
$passwordtxt = "P@ssw0rd"

$password = ConvertTo-SecureString -String $passwordtxt -AsPlainText -Force
$credential = New-Object PSCredential $User, $password

New-NavContainer -accept_eula -containerName "CRONUS140"  -imageName "mcr.microsoft.com/businesscentral/onprem:1904-es-ltsc2019" -includeCSide  -doNotExportObjectsToText -updateHosts -doNotCheckHealth -accept_outdated -shortcuts Desktop  -isolation hyperv -auth UserPassword -credential $credential
