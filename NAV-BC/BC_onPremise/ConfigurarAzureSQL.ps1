# Script para configurar un servicio de BC contra una instancia de Azure SQL


# Parámetros a rellenar
$InstaciaSQL = "" # Servidor Azure SQL
$UsuarioSQL = "" # Usuario para conectar con la BD en Azure
$PassSQL = "" # Contraseña del usuario
$RutaLicencia = "" # Ruta de la licencia a subir
$RutaClaveCifrado = "C:\Users\nav-tipsa\Downloads\CódCliente_DynamicsNAV.key" # Ruta para generar la clave de cifrado
$PassClaveCifrado = "" # Contraseña de la clave de cifrado
$Instancia = "" # Instancia de BC
$DB = "" # Base de datos de SQL
$RutaModulo = "C:\Program Files\Microsoft Dynamics 365 Business Central\170\Service\NavAdminTool.ps1" # Ruta del módulo PS de BC

$Credentials = (New-Object PSCredential -ArgumentList $UsuarioSQL,(ConvertTo-SecureString -AsPlainText -Force $PassSQL))

Import-module $RutaModulo
Install-WindowsFeature -Name NET-HTTP-Activation

New-NAVEncryptionKey -KeyPath $RutaClaveCifrado -Password (ConvertTo-SecureString -AsPlainText -Force $PassClaveCifrado) -Force

Import-NAVEncryptionKey -ServerInstance $Instancia -ApplicationDatabaseServer $InstaciaSQL -ApplicationDatabaseCredentials $Credentials -ApplicationDatabaseName $DB -KeyPath $RutaClaveCifrado -Password (ConvertTo-SecureString -AsPlainText -Force $PassClaveCifrado)

Set-NAVServerConfiguration -DatabaseCredentials $Credentials -ServerInstance $Instancia -Force
Set-NAVServerConfiguration $Instancia -KeyName DatabaseServer -KeyValue $InstaciaSQL -Force
Set-NAVServerConfiguration $Instancia -KeyName DatabaseName -KeyValue $DB
Set-NAVServerConfiguration $Instancia -KeyName EnableSqlConnectionEncryption -KeyValue true
Set-NAVServerInstance $Instancia -Restart
Import-NAVServerLicense $Instancia -LicenseFile $RutaLicencia -Database NavDatabase -Force
Set-NAVServerInstance $Instancia -Restart
