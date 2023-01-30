# Menú para entorno DEMO de consultores
# Opciones disponibles:
#   Instalar Entorno: Motor Docker y módulo navcontainerhelper
#   Eliminar todo: Contenedores, imágenes, módulo navcontainerhelper y desinstala Docker
#   Crear y arrancar CRONUS14.0 última CU - Si es la primera ejecución tardará en realizar la descarga de la imágen
#   Crear y arrancar VNT13.0 CU 03 - Si es la primera ejecución tardará en realizar la descarga de la imágen
#
#
#   Pendientes:
#   - Codificación scripts, al ejecutarse no reconoce acentos, ñ, etc
#   Por powershell cambiar el espacio de ejecución de Linux a Windows [& "C:\Program Files\Docker\Docker\DockerCli.exe" -SwitchDaemon]
#   Docker requiere cerrar sesión, Hay que ver la forma de al entrar en el menu continue desde ahí
#   Comprobar si Docker está instalado para que no se lance de nuevo la instalación
#   Añadir fichero de configuración para cambiar parámetros, rita imágenes y contenedores, parámetro memoria, etc

#Requires -RunAsAdministrator

Function showmenu {
    Clear-Host
    Write-Host "Entorno Demo - ejecutar como administrador -"
    Write-Host "1. Instalar entorno"
    Write-Host "2. Crea / recrea y ejecuta una instancia de CRONUS 14.0 ultima CU"
    Write-Host "21. Inicia la instancia de CRONUS 14.0 ultima CU"
    Write-Host "22. Para la instancia de CRONUS 14.0 ultima CU"
    Write-Host "3. Crea / recrea y ejecuta una instancia de CRONUS 15.0 ultima CU"
    Write-Host "31. Inicia la instancia de CRONUS 15.0 ultima CU"
    Write-Host "32. Para la instancia de CRONUS 15.0 ultima CU"
    Write-Host "5. Crea / recrea y ejecuta una instancia de VNT 14.0 CU06"
    Write-Host "51. Inicia la instancia de VNT 14.0 CU06"
    Write-Host "52. Para la instancia de VNT 14.0 CU06"
    Write-Host "8. "
    Write-Host "9. Exit"
}

showmenu

while(($inp = Read-Host -Prompt "Seleciona una opcion") -ne "9"){

switch($inp){
        1 {
            Clear-Host
            Write-Host "------------------------------";
            Write-Host "Instalación entorno - se descargarán varios programas por lo que puede tardar un tiempo en completarse la instalacion";
            Write-Host "------------------------------";
            C:\Tipsa\PowerShell\Scripts\EntornoConsultores\Install-DockerDesktopOnWindows10.ps1
            pause;
            break
        }
        2 {
            Clear-Host
            Write-Host "------------------------------";
            Write-Host "Creando instanacia CRONUS 14.0 ultima CU - si es la primera ejecucion puede tardar un tiempo en descargar al imagen. Por favor espere";
            Write-Host "------------------------------";
            C:\Tipsa\PowerShell\Scripts\EntornoConsultores\CRONUS140.ps1
            pause;
            break
        }
        21 {
            Clear-Host
            Write-Host "------------------------------";
            Write-Host "Iniciando instanacia CRONUS 14.0 ultima CU";
            Write-Host "------------------------------";
            Docker start CRONUS140
            pause;
            break
            }

        22 {
            Clear-Host
            Write-Host "------------------------------";
            Write-Host "Parando instanacia CRONUS 14.0 ultima CU";
            Write-Host "------------------------------";
            Docker stop CRONUS140
            pause;
            break
            }
        3 {
            Clear-Host
            Write-Host "------------------------------";
            Write-Host "Creando instanacia CRONUS 15.0 ultima CU - si es la primera ejecucion puede tardar un tiempo en descargar al imagen. Por favor espere";
            Write-Host "------------------------------";
            C:\Tipsa\PowerShell\Scripts\EntornoConsultores\CRONUS150.ps1
            pause;
            break
        }
        31 {
            Clear-Host
            Write-Host "------------------------------";
            Write-Host "Iniciando instanacia CRONUS 15.0 ultima CU";
            Write-Host "------------------------------";
            Docker start CRONUS150
            pause;
            break
            }

        32 {
            Clear-Host
            Write-Host "------------------------------";
            Write-Host "Parando instanacia CRONUS 15.0 ultima CU";
            Write-Host "------------------------------";
            Docker stop CRONUS150
            pause;
            break
            }
        5 {
            Clear-Host
            Write-Host "------------------------------";
            Write-Host "Creando instanacia VinoTEC 14.0 CU06 - si es la primera ejecucion puede tardar un tiempo en descargar al imagen. Por favor espere";
            Write-Host "------------------------------";
            C:\Tipsa\PowerShell\Scripts\EntornoConsultores\VNT140.ps1
            pause;
            break
            }

        51 {
            Clear-Host
            Write-Host "------------------------------";
            Write-Host "Iniciando instanacia VNT 14.0";
            Write-Host "------------------------------";
            Docker start VNT140
            pause;
            break
            }
        52 {
            Clear-Host
            Write-Host "------------------------------";
            Write-Host "Parando instanacia VNT 14.0";
            Write-Host "------------------------------";
            Docker stop VNT140
            pause;
            break
            }
        8 {
            Clear-Host
            Write-Host "------------------------------";
            Write-Host "";
            Write-Host "------------------------------";
            pause;
            break
        }
        9 {"Exit"; break}
        default {Write-Host -ForegroundColor red -BackgroundColor white "Opción invalida. Por favor seleciona otra opcion";pause}

    }

showmenu
}
