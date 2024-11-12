# Diversos comandos de docker

# Generador de scripts para BC
New-BcContainerWizard


# Localizar URL de la versión que nos interesa
$Version = "16.5"
$TipoBC = "onprem" #onprem o sandbox
$artifactUrl = Get-BCArtifactUrl -version $Version -country es -select Latest -type $TipoBC
$artifactUrl
# Crear contenedor con artifacts

$Nombre = "BC160"
$credential = New-Object pscredential 'admin', (ConvertTo-SecureString -String 'P@ssword' -AsPlainText -Force)

New-BcContainer  -accept_eula -containerName $Nombre -artifactUrl $artifactUrl -Credential $credential -auth UserPassword -updateHosts

# Muestra la URL de Artifact utilizado en un contenedor
Get-BcContainerArtifactUrl

# Crea un contenedor con artifacts y guarda una imagen para poder reutilizar

$Nombre = "BC160"
$NombreImagen = "miimagen"
$artifactUrl = Get-BCArtifactUrl -version 16.5 -select Latest -country es
$credential = New-Object pscredential 'admin', (ConvertTo-SecureString -String 'P@ssword' -AsPlainText -Force)
New-BCContainer -accept_eula -containerName $Nombre -artifactUrl $artifactUrl -Credential $credential -auth UserPassword -updateHosts -imagename $NombreImagen

# Instalación onPrem
$containerName = 'bc160'
$password = 'P@ssw0rd'
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object pscredential 'admin', $securePassword
$auth = 'UserPassword'
$artifactUrl = Get-BcArtifactUrl -type 'OnPrem' -version '' -country 'es' -select 'Latest'
New-BcContainer `
    -accept_eula `
    -containerName $containerName `
    -credential $credential `
    -auth $auth `
    -artifactUrl $artifactUrl `
    -imageName 'myimage' `
    -isolation 'hyperv' `
    -updateHosts

# Instalación SAS
$containerName = 'bc170'
$password = 'P@ssw0rd'
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object pscredential 'admin', $securePassword
$auth = 'UserPassword'
$artifactUrl = Get-BcArtifactUrl -type 'Sandbox' -version '' -country 'es' -select 'Latest'
New-BcContainer `
    -accept_eula `
    -containerName $containerName `
    -credential $credential `
    -auth $auth `
    -artifactUrl $artifactUrl `
    -imageName 'myimage' `
    -isolation 'hyperv' `
    -updateHosts


# Eliminar caché Artifacts
Flush-ContainerHelperCache -cache bcartifacts


#Revisar visor de sucesos del docker
#Desde el acceso de Prompt creado por el Contenedor en el escritorio

wevtutil epl Application C:\run\my\AppLogBackup.evtx

#Se mapea aquí
C:\ProgramData\NavContainerHelper\Extensions\[Container Name]\my


