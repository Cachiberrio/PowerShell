# Para añadir capas de idioma hay que instalar la App correspondiente
# Idiomas disponibles en: https://aka.ms/bccountries
# Ruta por defecto en dvd instalación: Applications\BaseApp\Source

$Instancia = 'vnt'
$RutaApp = 'C:\Users\Nav-tipsa\Downloads\BC170Cu02\Applications\BaseApp\Source\Microsoft_German language (Germany).app'
$tenant = 'BCM'
$App = 'German language (Germany)'
$Remoto = "vnt170mt.tipsa.local" # Nombre del equipo al que conectarse, poner el dominio completo, por ejemplo nav2015.tipsa.local. Equipos disponibles: nav2015.# tipsa.local, nav2017.tipsa.local, bc365.tipsa.local y bc160.tipsa.local
$username = '' # Usuario Windows para acceder al servidor remoto
$pass = ''


$pass = ConvertTo-SecureString -string $pass -AsPlainText -Force
$cred = New-Object -typename System.Management.Automation.PSCredential -argumentlist $username, $pass
#$Cred = Get-Credential
$sessionOptions = New-PSSessionOption -IncludePortInSPN
Enter-PSSession -Computername $Remoto -SessionOption $sessionOptions -credential $Cred -UseSSL

# Importar módulo admin
Import-Module "C:\Program Files\Microsoft Dynamics 365 Business Central\170\service\NavAdminTool.ps1"



Publish-NAVApp -ServerInstance $Instancia -Path $RutaApp
Sync-NAVApp -ServerInstance $Instancia -Name $App -Tenant $tenant
Install-NAVApp -ServerInstance  $Instancia -Name $App -Tenant $tenant
Restart-NAVServerInstance -ServerInstance $Instancia

Get-NAVAppInfo $Instancia