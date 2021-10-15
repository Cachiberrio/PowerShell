cls
$NavIde = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client CU15\finsql.exe'
Import-Module "C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client CU15\Microsoft.Dynamics.Nav.Model.Tools.psd1" -verbose
$Directorio='C:\Tipsa\PowerShell\Txt2AL\EMCS';
$FileName=$Directorio + '\TodosLosObjetos.txt';
$TodosFicheroTexto=$Directorio + '\*.txt';
Remove-Item $TodosFicheroTexto;
Export-NAVApplicationObject $FileName -DatabaseServer 'BC14CU15\SQLEXPRESS' -DatabaseName CRONUS -Filter 'Version List=*DEC*;Id=52099' -ExportToNewSyntax -Username 'admin' -Password 'P@ssw0rd'
Split-NAVApplicationObjectFile -Source $FileName -Destination $Directorio
Remove-Item $FileName;
Remove-Item $Directorio + '\*.*';
CD "C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client CU15\"
.\\txt2al.exe --source $Directorio --target $Directorio