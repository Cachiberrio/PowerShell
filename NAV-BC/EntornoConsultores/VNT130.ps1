	# Crea y arranca un contenedor de BC 13.0 CU03
    # Restaura una copia de seguridad de VNT y copia la licencia TPSA
    # La BD sin usuarios
    # Crea accesos directos en el escritorio para las aplicaciones
    # Opciones:
    # -alwaysPull: descarga siempre nueva images si están disponibles
    # -accept_outdated: acepta images antiguas
    # -bakFile $bakVNT


#Requires -RunAsAdministrator

$bakVNT = "C:\Tipsa\PowerShell\Scripts\EntornoConsultores\VNT130CU03_for_Docker.bak"
$LicTipsa = "C:\Tipsa\PowerShell\Scripts\EntornoConsultores\TIPSA365.flf"

$User = "admin"
$passwordtxt = "P@ssw0rd"

$password = ConvertTo-SecureString -String $passwordtxt -AsPlainText -Force
$credential = New-Object PSCredential $User, $password

new-navcontainer -accept_eula -containerName VNT130 -imageName mcr.microsoft.com/businesscentral/onprem:13.3.27233.0-es-ltsc2019  -bakFile $bakVNT -includeCSide  -doNotExportObjectsToText   -useBestContainerOS -updateHosts  -licenseFile $LicTipsa -doNotCheckHealth -alwaysPull -accept_outdated -isolation hyperv -auth UserPassword -credential $credential
