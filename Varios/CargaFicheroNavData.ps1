# Importación de un fichero .navdata en una base de datos
# =======================================================================================================================
$Servidor  = 'SDC2013R2'
$Fichero = 'C:\Users\ism\Desktop\PVF\PVF.TD.151216.navdata'
# =======================================================================================================================
Set-ExecutionPolicy RemoteSigned -Force
Import-Module "C:\Program Files\Microsoft Dynamics NAV\80\Service\NavAdminTool.ps1"
Import-NAVData -AllCompanies -ServerInstance $Servidor -Filename $Fichero
