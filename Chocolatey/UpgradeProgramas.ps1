# Paquetes https://chocolatey.org/packages

#Requires -RunAsAdministrator
#Set-ExecutionPolicy unrestricted


# Essentials
choco upgrade notepadplusplus -y
choco upgrade winrar -y
choco upgrade putty -y
choco upgrade foxitreader -y
choco upgrade paint.net -y
choco upgrade f.lux -y
choco upgrade anydesk -y
choco upgrade brave -y
choco upgrade filezilla -y
choco upgrade firefox -y
choco upgrade chocolateygui -y
choco upgrade lastpass -y
choco upgrade angryip -y
choco upgrade advanced-ip-scanner -y
choco upgrade wudt -y
choco upgrade files -y

# Management & dev Tools
choco upgrade dotnetfx   -y
#choco upgrade visualstudio2017community -y # Desarrollo de Reports activar si es necesario
#choco upgrade visualstudio2017-workload-webbuildtools
choco upgrade sql-server-management-studio   -y
choco upgrade microsoftazurestorageexplorer   -y
choco upgrade docker-desktop --pre -y
choco upgrade microsoft-windows-terminal   -y
#choco upgrade powerbi   -y
choco upgrade rdcman   -y
choco upgrade vscode-powershell   -y
# Sincronización settings VSCODE https://mikefrobbins.com/2019/03/21/backup-and-synchronize-vscode-settings-with-a-github-gist/
choco upgrade chocolatey-vscode   -y
choco upgrade git -y
choco upgrade vscode-intellicode   -y
choco upgrade vscode-mssql   -y
choco upgrade vscode   -y
choco upgrade ConEmu -y
choco upgrade nugetpackageexplorer -y

# Remotos y VPNs

# Es la nueva versión que no se lleva bien con las contraseña guardadas y no se pueden ver. Intalar la versión \\hoth\Software\RDCMan.msi
# choco install rdcman -y
choco upgrade forticlientvpn -y
choco upgrade radmin-vpn -y
choco upgrade openvpn -y
choco upgrade securepointsslvpn -y
choco upgrade openconnect-gui -y
choco upgrade citrix-workspace -y
choco upgrade anydesk -y
choco upgrade openvpn-connect

# Powershell
choco upgrade powershell-core   -y
choco upgrade az.powershell   -y
choco upgrade azurepowershell   -y



# Msft & Office
Copy-Item \\hoth\Software\ISOS\Microsoft\Aplicaciones\ConfiguracionOffice2019.xml c:\ConfiguracionOffice2019.xml
choco upgrade office365proplus   -y --params '/ConfigPath:c:\ConfiguracionOffice2019.xml'
choco upgrade microsoft-teams   -y





choco upgrade chocolatey -y