
# Script de actualización de Apps por tenant
#https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/upgrade/upgrade-unmodified-application

#Importar módulo para tener poder ejecutar los comandos
Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\170\Service\NavAdminTool.ps1'

$Path = '.app'
$Name=''
$Instance = ''
$Tenant1 = ''
$Version = '1.0.0.1'

#Se desinstala la extensión
Uninstall-NAVApp -ServerInstance $Instance -Name $Name -Version $Version -Tenant $Tenant1

#Se despublica la extensión para poder actualizarla con la nueva .app
Unpublish-NAVApp -ServerInstance $Instance -Name $Name -Version $Version -Tenant $Tenant1

#Se publica la extensión modificada
Publish-NAVApp -ServerInstance $Instance -Path $Path -Scope Tenant -Tenant $Tenant1 -SkipVerification

#Se sincroniza en la instancia y el tenant del cliente
Sync-NAVApp -ServerInstance $Instance -Name $Name -Version $Version -Tenant $Tenant1

#Se instala la extensión modificada
Install-NAVApp -ServerInstance $Instance -Name $Name -Version $Version -Tenant $Tenant1

Write-Host "Actualización completada"
