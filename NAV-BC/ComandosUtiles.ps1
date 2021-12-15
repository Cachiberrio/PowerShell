# Ver servicios de un servidor
$ServerName = 'NAV2015'
Get-Service -ComputerName $ServerName | Out-GridView

# Iniciar Servicio de un servidor
$ServerName = 'BC365'
$ServiceDisplayName = 'NAV Server VNT140AL'
Get-Service -ComputerName $ServerName -DisplayName $ServiceDisplayName | Start-Service

# Detener Servicio de un servidor
$ServerName = 'BC365'
$ServiceDisplayName = 'NAV Server VNT140AL'
Get-Service -ComputerName $ServerName -DisplayName $ServiceDisplayName | Stop-Service
