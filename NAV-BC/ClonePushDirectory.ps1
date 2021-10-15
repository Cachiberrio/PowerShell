#Compruebo que se ha introducido el mensaje
function CheckMessage {
    if ([string]::IsNullOrEmpty($MensajeCommit))
    {
        Write-Host "Para ejecutar el script es necesario que introduzca un mensaje"
        Return $false
    }
    else {
        Return $true
    }
}

#Creo un directorio nuevo para clonar el repositorio remoto
function SetCloneDirectory {
    New-Item -Path $RutaLocal -Name "${RepositoryName}" -ItemType "directory"
    git clone $RemoteRepository $RutaLocal\$RepositoryName
}

function MoveFiles {
    #Por cada fichero en el directorio, lo muevo a la ubicación donde se ha clonado el repositorio
    foreach($Item in Get-ChildItem $PathArchivos)
    {
        Move-Item -Path $Item -Destination $RutaLocal\$RepositoryName
    }
}

#Me cambio a la ruta donde está el .git para poder subir los ficheros que he copiado
function ChangePathCommit {
    Set-Location ${RutaLocal}\${RepositoryName}
    git add -A
    git commit -am "${MensajeCommit}"
    git push origin master
}

#Elimino el repositorio local para dejarlo todo como estaba
function DeletePath {
    Set-Location ${RutaLocal}
    Write-Host "Limpiando ruta local..."
    sleep 3
    Remove-Item -Path ${RutaLocal}\${RepositoryName} -Recurse -Force
}

Cls
#Pido por consola la dirección del repositorio remoto
#Y el mensaje de commit que se usará para hacer el push
$RemoteRepository = Read-Host "Introduce el directorio remoto"
$MensajeCommit = Read-Host "Introduce un mensaje para el commit"

#Establece y obtiene los ficheros a subir a partir de la ruta desde donde se ejecuta el PS
#Excluyo el propio PS
$RutaLocal = Get-Location
$PathArchivos = Get-ChildItem -Path . -Exclude *.ps1

#Obtengo el nombre del repositorio remoto
$RepositoryName = $RemoteRepository.Split('/')[4]
if (CheckMessage) {
    SetCloneDirectory
    MoveFiles
    ChangePathCommit
    DeletePath
}


