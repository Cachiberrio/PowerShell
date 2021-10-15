
$Remoto = "equipo.tipsa.local" # Nombre del equipo al que conectarse, poner el dominio completo, por ejemplo nav2015.tipsa.local. Equipos disponibles: nav2015.tipsa.local, nav2017.tipsa.local, bc365.tipsa.local y bc160.tipsa.local
$username = 'tipsa\' # Usuario de dominio para acceder al servidor remoto
$pass = ''

$pass = ConvertTo-SecureString -string $pass -AsPlainText -Force
$cred = New-Object -typename System.Management.Automation.PSCredential -argumentlist $username, $pass
$sessionOptions = New-PSSessionOption -IncludePortInSPN
Enter-PSSession -Computername $Remoto -SessionOption $sessionOptions -credential $Cred

# Ahora los comandos powershell que ejecutemos son desde el servidor al que estamos conectados
# por ejemplo:
# Import-Module "C:\Program Files\Microsoft Dynamics NAV\90\CRONUS2016\NavAdminTool.ps1"
# Sync-NAVTenat "Instancia servicio" -mode checkonly    # Sync-NAVTenant CRONUS140 -mode checkonly

# Y para desconectar la conexión con exit