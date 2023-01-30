	# Crear y arrancar Contenedor con BC 15.0 última CU
	# Crea accesos directos en el escritorio para las aplicaciones

#Requires -RunAsAdministrator

$User = "admin"
$passwordtxt = "P@ssw0rd"

$password = ConvertTo-SecureString -String $passwordtxt -AsPlainText -Force
$credential = New-Object PSCredential $User, $password

New-NavContainer -accept_eula -containerName "CRONUS150"  -imageName "mcr.microsoft.com/businesscentral/onprem:1910-es-ltsc2019" -doNotExportObjectsToText -updateHosts -doNotCheckHealth -shortcuts Desktop -auth UserPassword -credential $credential

