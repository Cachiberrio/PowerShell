# Crea un contenedor con artifacts y guarda una imagen para poder reutilizar

$Nombre = "BC140CU30"
$NombreImagen = "BC140CU30"
$artifactUrl = Get-BCArtifactUrl -version 14.30 -select Latest -country es
$credential = New-Object pscredential 'admin', (ConvertTo-SecureString -String 'P@ssword' -AsPlainText -Force)
New-BCContainer -accept_eula -containerName $Nombre -artifactUrl $artifactUrl -Credential $credential -auth UserPassword -updateHosts -imagename $NombreImagen
