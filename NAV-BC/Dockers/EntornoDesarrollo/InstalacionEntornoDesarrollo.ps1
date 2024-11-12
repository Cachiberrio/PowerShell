# Script para instalar el entorno Docker en Windows 10 para desarrollo
# Requisitos:
# Windows 10 64-bit: Pro, Enterprise, or Education (Build 15063 or later).
# Hyper-V and Containers Windows features must be enabled.
# 64 bit processor with Second Level Address Translation (SLAT)
# 16GB system RAM
# BIOS-level hardware virtualization support must be enabled in the BIOS settings. For more information, see Virtualization.

# Módulo Chocolatey
# https://git.tipsa.cloud:3000/TIPSA_SL/Powershell/src/branch/master/Utilidades/Chocolatey/InstallChocolaey.ps1
# Se pueden consultar otro software que se puede gestionar aquí:
# https://git.tipsa.cloud:3000/TIPSA_SL/Powershell/src/branch/master/Utilidades/Chocolatey/InstallProgramas.ps1

# To-DO:
# Comando para el cambio a contenedores Windows




#requires -RunAsAdministrator

# Activación de características de Windows - Es posible que sea necesario reiniciar
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V, Containers -All

# Instalación Docker-Desktop por Chocolatey - Si no está instalado Chocolatey ejecutar el siguiente script:
# https://git.tipsa.cloud:3000/TIPSA_SL/Powershell/src/branch/master/Utilidades/Chocolatey/InstallChocolaey.ps1
choco install docker-desktop -y

# Una vez instalado es posible que haya que cambiar el modo a Contenedores Windows ya que este en Linux
# Botón derecho en el icono de Docker y seleccionar "Cambiar a Contenedores Windows"

# Añadimos el usuario actual al grupo local Dockers
Add-LocalGroupMember -Group "docker-users" -Member $env:UserName


# Instalamos el módulo de gestión para NAV/BC
install-module -Name navcontainerhelper

# Ejecutamos generador de Scripts de creación de contenedores para NAV / BC
# Abrirá una nueva terminal de Powershell con un Wizard, una vez finalizado
# tendremos el script para generar el contenedor que deseemos
# Para Windows 10 hay que forzar la selección de hyper-v cuando nos pregunte
New-BcContainerWizard


# Post instalación
# Se recomienda mantener actualizados los programas y módulos regularmente
choco upgrade docker-desktop -y
install-module -Name  -force