# Paquetes https://chocolatey.org/packages

# Para errores de checksum se puede ignorar. Cuidado con esto --ignore-checksums

#Requires -RunAsAdministrator
#Set-ExecutionPolicy unrestricted


# Essentials
choco install notepadplusplus -y
choco install winrar -y
choco install putty -y
choco install foxitreader -y
choco install paint.net -y
choco install f.lux -y
choco install anydesk -y
choco install brave -ypui
choco install filezilla -y
choco install firefox -y
choco install chocolateygui -y
choco install lastpass -y
choco install angryip -y
choco install advanced-ip-scanner -y
choco install wudt -y
choco install files -y


# Management & dev Tools
choco install dotnetfx -y
#choco install visualstudio2017community # Desarrollo de Reports activar si es necesario
#choco install visualstudio2017-workload-webbuildtools
choco install sql-server-management-studio -y
choco install vscode -y
choco install vscode-powershell -y
choco install git -y
choco install chocolatey-vscode -y
choco install vscode-intellicode -y
choco install vscode-mssql -y
# Sincronización settings VSCODE https://mikefrobbins.com/2019/03/21/backup-and-synchronize-vscode-settings-with-a-github-gist/
choco install microsoftazurestorageexplorer -y
choco install docker-desktop -y
choco install microsoft-windows-terminal -y
choco install ConEmu -y
#choco install powerbi -y
choco install nugetpackageexplorer -y


# Remotos y VPNs

# Es la nueva versión que no se lleva bien con las contraseña guardadas y no se pueden ver. Intalar la versión \\hoth\Software\RDCMan.msi
# choco install rdcman -y
choco install forticlientvpn -y
choco install radmin-vpn -y
choco install openvpn -y
choco install openvpn-connect
choco install securepointsslvpn -y
choco install openconnect-gui -y
choco install citrix-workspace -y
choco install anydesk -y


# Powershell
choco install powershell-core -y
choco install az.powershell -y
choco install azurepowershell -y


# Msft & Office
# Copiar ficher configuración \\hoth\Software\ISOS\Microsoft\Aplicaciones\ConfiguracionOffice2019.xml
Copy-Item \\vortex\Software\ISOS\Microsoft\Aplicaciones\ConfiguracionOffice2019.xml c:\ConfiguracionOffice2019.xml
choco install office365proplus -y --params '/ConfigPath:c:\ConfiguracionOffice2019.xml'
choco install microsoft-teams -y



