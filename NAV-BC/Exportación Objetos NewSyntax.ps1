cls

$DBName = 'CRONUS140CU08'
$DBServer = "KAMINO"
$FicheroObjetos = 'C:\Tipsa\PowerShell\Txt2AL\CRONUS140CU08.txt'
$VersionList = 'LAB'
$FiltroVersionList = 'Version List=@*' + $VersionList + '*' 

Import-Module "C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client CU08\Microsoft.Dynamics.Nav.Model.Tools.psd1" -verbose
Export-NAVApplicationObject -DatabaseName $DBName -DatabaseServer $DBServer  -path $FicheroObjetos -Filter $FiltroVersionList -ExportToNewSyntax 