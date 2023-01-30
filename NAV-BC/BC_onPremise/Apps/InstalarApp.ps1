Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\170\Service\NavAdminTool.ps1'

$Path = 'C:\Users\Nav-tipsa\Documents\Apps\Globales\VinoTEC NEXT\Instaladas\Técnicas Informática Pro.Serv. y Ases,SL_Gestión de recogida agraria - Harvest Management_1.0.0.1.app'
$Name='Gestión de recogida agraria - Harvest Management'
$Version = '1.0.0.1'
$Instance = 'vnt'
$Tenant1 = 'BCM'


Publish-NAVApp -ServerInstance $Instance -Path $Path -Scope Global -SkipVerification
Sync-NAVApp -ServerInstance $Instance -Name $Name -Version $Version -Tenant $Tenant1 #-Mode ForceSync -Force -Verbose
Install-NAVApp -ServerInstance $Instance -Name $Name -Tenant $Tenant1
