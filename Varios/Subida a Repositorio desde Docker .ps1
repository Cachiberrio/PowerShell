$RutaModuloTarget = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client CU07\NavModelTools.ps1'
Import-Module $RutaModuloTarget
Export-NAVApplicationObject Prueba.txt -DatabaseServer BC14CU15\SQLEXPRESS -DatabaseName CRONUS -Filter 'Version List=*EMC*' -UserName 'admin' -Password 'P@ssw0rd'| Split-NAVApplicationObjectFile -Destination 'C:\Compartida\FOB\VNT140'