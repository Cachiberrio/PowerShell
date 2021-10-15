$Desarrollo      = 'REC'
$DBServerName    = 'VORTEX\SQL2K17'
$DBName          = 'VNT140AL'
$RutaRepositorio = 'C:\Users\am\Documents\Repositorios\VNT140'

$USR             = '' # Sólo cuando sea con usuario y contraseña
$PWD             = '' # Sólo cuando sea con usuario y contraseña

$NavIde = "C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client CU07\finsql.exe"
$RutaModuloTarget = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client CU07\NavModelTools.ps1'

$Filtro = 'Version List=*' + $Desarrollo + '*'
$FicheroExportacion = 'C:\Compartida\FOB\Repositorios\' + $Desarrollo + '.txt'
$RutaRepositorio = $RutaRepositorio + '\' + $Desarrollo

Import-Module $RutaModuloTarget

# Export-NAVApplicationObject $FicheroExportacion -DatabaseServer $DBServerName -DatabaseName $DBName -Filter $Filtro -Username $USR -Password $PWD -Force
Export-NAVApplicationObject $FicheroExportacion -DatabaseServer $DBServerName -DatabaseName $DBName -Filter $Filtro
Split-NAVApplicationObjectFile -Source $FicheroExportacion -Destination $RutaRepositorio -Force

# Despues de esto deberíamos abrir el VSCode y hacer el correspondiente COMMIT y el correspondiente PUSH