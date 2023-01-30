# Instala módulo
Install-Module PsdrawIO

# Muestra ayuda módulo
help New-NetworkMap

# lanzamos discover
New-Networkmap -Network 192.168.1.0/24 -Layout organic | out-file "redlocal.csv"