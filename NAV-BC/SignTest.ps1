$RutaCertificado = Read-Host "Indique la ruta del certificado"
$Password = Read-Host "Indique la contraseña del certificado"
$RutaApp = Read-Host "Indique la ruta de la app"
$RutaHerramientaFirma = Read-Host "Indique la ruta del archivo signtool.exe"


function Sign-App {
param(
        [string]$AppPath,
        [string]$CertPath,
        [string]$CertPass           
    )

    Set-Location -Path "${RutaHerramientaFirma}" 
    ./signtool.exe sign /f $CertPath /p $CertPass /t http://timestamp.verisign.com/scripts/timestamp.dll $AppPath
}

$fileName = "${RutaApp}"
Sign-App -AppPath $fileName -CertPath "${RutaCertificado}" -CertPass "${Password}" 

