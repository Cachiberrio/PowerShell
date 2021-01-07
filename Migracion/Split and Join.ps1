$RutaModulo   = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client CU15\NavModelTools.ps1'
Import-Module $RutaModulo

$FicheroBase = 'C:\Compartida\FOB\IIEE\EMC.txt'
$RutaSplit = 'C:\Compartida\FOB\IIEE\EMC'
Split-NAVApplicationObjectFile -Source $FicheroBase -Destination $RutaSplit -Force

$FicheroBase = 'C:\Compartida\FOB\IIEE\IIEE.txt'
$RutaSplit = 'C:\Compartida\FOB\IIEE\IIEE'
Split-NAVApplicationObjectFile -Source $FicheroBase -Destination $RutaSplit -Force

$RutaResultado = 'C:\Compartida\FOB\IIEE\IIEE'
Join-NAVApplicationObjectFile -Source ($RutaSplit + "\*.txt") -Destination ($RutaResultado + "Resultado.txt") -Force