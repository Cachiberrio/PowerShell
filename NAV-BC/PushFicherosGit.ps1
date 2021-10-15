#
# Se debe ejecutar en la carpeta donde esté ubicado el .git del repositorio
#

$RamaLocal = Read-Host "Introduce la rama local"
$RamaRemota = Read-Host "Introduce la rama remota"
$MensajeCommit = Read-Host "Introduce un mensaje para el commit"

git checkout ${RamaLocal}
git add -A
git commit -am "${MensajeCommit}"
git push ${RamaRemota} ${RamaLocal}