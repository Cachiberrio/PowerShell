$NavServerName = 'HPE170'
$LicensePath = 'HPE_PabloEsparza_BC_17.flf'

Import-NAVServerLicense $NavServerName -LicenseData ([Byte[]]$(Get-Content -Path $LicensePath -Encoding Byte)) -Database NavDatabase
Reiniciar el servicio (desde cualquier ruta)
Restart-NAVServerInstance -ServerInstance $NavServerName -Verbose