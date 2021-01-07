# Crea un contenedor con artifacts y guarda una imagen para poder reutilizar

# $Nombre = "BC140"
# $NombreImagen = "miimagen"
# $artifactUrl = Get-BCArtifactUrl -version 14.9 -select Latest -country es
# $credential = New-Object pscredential 'admin', (ConvertTo-SecureString -String 'P@ssword' -AsPlainText -Force)
# New-BCContainer -accept_eula -containerName $Nombre -artifactUrl $artifactUrl -Credential $credential -auth UserPassword -updateHosts -imagename $NombreImagen

# Instalación onPrem
$containerName = 'BC140CU09'
$NombreImagen = 'imagen'
$password = 'P@ssw0rd'
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object pscredential 'admin', $securePassword
$auth = 'UserPassword'
$artifactUrl = Get-BcArtifactUrl -type 'OnPrem' -version '14.9' -country 'es' -select 'Latest'
New-BcContainer `
    -accept_eula `
    -containerName $containerName `
    -credential $credential `
    -auth $auth `
    -artifactUrl $artifactUrl `
    #-imageName $NombreImagen `
    -isolation 'hyperv' `
    -updateHosts