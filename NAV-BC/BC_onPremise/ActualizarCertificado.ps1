# actualizar certificado


# Mostrar referencias SSL
netsh http show sslcert

# Eliminar referencia antigua
netsh http delete sslcert ipport=0.0.0.0:7058


# Añadir nueva referencia
netsh http add sslcert ipport=0.0.0.0:7058 appid={a5455c78-6489-4e13-b395-47fbdee0e7e6} certhash=<thumprint without space>

# Eliminar urlac
netsh http delete urlacl url=http://+:7047/instancia

netsh http add urlacl url=http://+:7047/%SERVICE%/ user=todos