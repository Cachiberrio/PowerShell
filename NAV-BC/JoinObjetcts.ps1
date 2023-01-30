$RutaResult = 'C:\Compartida\FOB\Compare\CRONUS'
$RutaMigracion = 'C:\Compartida\FOB\Compare\'
Join-NAVApplicationObjectFile -Source ($RutaResult + "\*.txt") -Destination ($RutaMigracion + "Resultado.txt") -Force