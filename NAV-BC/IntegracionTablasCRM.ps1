# Definición de variables
$RutaModulo = 'C:\Program Files (x86)\Microsoft Dynamics NAV\100\RoleTailored Client CU12\NavModelTools.ps1'
$NombreServidorCRM = 'https://evasa.crm4.dynamics.com'
$NombreEntidadCRM = 'account'
$NoTablaNAV = 5341
$NombreTablaNAV = "CRM Account"
$DirectorioObjetos = 'c:\Compartida\CRMObjects'

# Proceso
cls
Import-Module 'C:\Program Files (x86)\Microsoft Dynamics NAV\100\RoleTailored Client CU12\NavModelTools.ps1'
# New-NavCrmTable -CRMServer https://evasatest.crm4.dynamics.com -EntityLogicalName contact -Name "CRM Contact" -ObjectId 50500 -OutputPath c:\CrmObjects
New-NavCrmTable -CRMServer https://evasatest.crm4.dynamics.com -EntityLogicalName account -Name "CRM Account" -ObjectId 50501 -OutputPath c:\CrmObjects