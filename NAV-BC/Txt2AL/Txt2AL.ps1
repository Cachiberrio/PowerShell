$NavExeFolder = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client CU15\';
$Directorio='C:\Tipsa\PowerShell\Txt2AL\IIEE';

$Database140Name = 'VNT140AL';
$ObjectFilter = 'Version List=*IE*|*DAV*;Date=10/08/14..';

$NavModule = $NavExeFolder + 'Microsoft.Dynamics.Nav.Model.Tools.psd1';
$FileName=$Directorio + '\TodosLosObjetos.txt';
$TodosFicheros=$Directorio + '\*';

Import-Module $NavModule -verbose
Remove-Item $TodosFicheros;
Export-NAVApplicationObject $FileName -DatabaseServer 'VORTEX\SQL2K17' -DatabaseName $Database140Name -Filter $ObjectFilter -ExportToNewSyntax #-Username 'admin' -Password 'P@ssw0rd'

Split-NAVApplicationObjectFile -Source $FileName -Destination $Directorio
Remove-Item $FileName;
CD $NavExeFolder
.\\txt2al.exe --source $Directorio --target $Directorio