# Ver servicios de un servidor
$ServerName = 'NAV2015'
Get-Service -ComputerName $ServerName | Out-GridView

# Iniciar Servicio de un servidor
$ServerName = 'NAV2015'
$ServiceDisplayName = 'NAV Server EMO2016'
Get-Service -ComputerName $ServerName -DisplayName $ServiceDisplayName | Start-Service