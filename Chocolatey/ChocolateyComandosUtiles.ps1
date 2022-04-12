# Lista completa de comandos:
# https://docs.chocolatey.org/en-us/choco/commands/list

# Consulta de la lista de aplicaciones instaladas en local y controlables mediante Chocolatey
Choco list -li

# Búsqueda de aplicaciones para instalar
Choco search <Nombre App>

# Instalación de Apps (Si no se conoce el nombre del paquete, utilizar choco search)
Choco install <Nombre Paquete>

# Desinstalación de Apps (Si no se conoce el nombre del paquete, utilizar choco search)
Choco uninstall <Nombre Paquete>

# Actualización de la App (Si no se conoce el nombre del paquete, utilizar choco search)
Choco Upgrade <Nombre paquete> 