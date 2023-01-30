Function ConectarAServidor{
    Param([string]$NombreServidorRemoto,
          [string]$AdminUserName, 
          [string]$AdminPass)

# Requisitos en el equipo destino. Ejecutar lo siguiente:
# SetSPN.exe -s HTTP/$($env:COMPUTERNAME):5985 $env:COMPUTERNAME
# SetSPN.exe -s HTTP/$($env:COMPUTERNAME).$($env:USERDNSDOMAIN):5985 $env:COMPUTERNAME

# Equipos disponibles: 
# - nav2015.tipsa.local 
# - nav2017.tipsa.local 
# - bc365.tipsa.local 
# - bc160.tipsa.local

$AdminPass = ConvertTo-SecureString -string $AdminPass -AsPlainText -Force
$cred = New-Object -typename System.Management.Automation.PSCredential -argumentlist $AdminUserName, $AdminPass
$sessionOptions = New-PSSessionOption -IncludePortInSPN
Enter-PSSession -Computername $NombreServidorRemoto -SessionOption $sessionOptions -credential $Cred
}
Function CambiarLicencia{
    Param([string]$NombreInstancia,
          [string]$Tenant,
          [string]$RutaLicencia)
    Import-NAVServerLicense $NombreInstancia -Tenant $Tenant  -LicenseFile $RutaLicencia  -Database Tenant # master, NavDatabase o Tenant

}
Function ReiniciarServicio{
    Param([string]$NombreInstancia)
    Restart-NAVServerInstance $NombreInstancia
}

$NombreServidor = "nav2017.tipsa.local"
$NombreInstancia = 'BRA2017'
$Tenant = ''

$UserName = 'am' # Usuario Windows para acceder al servidor remoto
$Pass = 'PintoTont0055'

$RutaLicencia = '\\am\Compartida\Licencia\Tipsa.flf'

# Conextar a servidor
# =================================================================
$AdminUserName = $UserName
$AdminPass = $Pass
$NombreServidorRemoto = $NombreServidor

$AdminPass = ConvertTo-SecureString -string $AdminPass -AsPlainText -Force
$cred = New-Object -typename System.Management.Automation.PSCredential -argumentlist $AdminUserName, $AdminPass
$sessionOptions = New-PSSessionOption -IncludePortInSPN
Enter-PSSession -Computername $NombreServidorRemoto -SessionOption $sessionOptions -credential $Cred

# Cambiar Licencia
# =================================================================
Import-NAVServerLicense $NombreInstancia -LicenseFile $RutaLicencia  -Database NavDatabase # master, NavDatabase o Tenant


# ConectarAServidor $NombreServidor $UserName $Pass
# CambiarLicencia $NombreInstancia $Tenant $RutaLicencia
# ReiniciarServicio $NombreInstancia