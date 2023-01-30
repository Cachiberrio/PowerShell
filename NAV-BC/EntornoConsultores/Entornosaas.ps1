# Crear Entorno SaaS

# Datos extendidos https://yzhums.com/11629/

# Parámetros
$containerName = 'saas'
$password = 'P@ssw0rd'
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object pscredential 'admin', $securePassword
$auth = 'UserPassword'
$artifactUrl = Get-BcArtifactUrl -type 'Sandbox' -country 'es' -select 'Latest'
$licenseFile = "C:\Users\ng\Downloads\Descargas Temporales\TIPSA_Business Central on Premises_18.flf"
$PathAPPs = 'C:\Compartida\SaaS\'

New-BcContainer `
    -accept_eula `
    -containerName $containerName `
    -credential $credential `
    -auth $auth `
    -artifactUrl $artifactUrl `
    -includeTestToolkit `
    -assignPremiumPlan `
    -licenseFile $licenseFile `
    -isolation 'hyperv' `
    -includeAL -doNotExportObjectsToText `
    -vsixFile (Get-LatestAlLanguageExtensionUrl) `
    -updateHosts
# Configurar usuarios test
Setup-BcContainerTestUsers -containerName $containerName -Password $credential.Password -credential $credential

# Instalar Apps VinoTEC
Publish-NewApplicationToBcContainer -containerName saas -appFile $PathAPPs'Técnicas Informática Pro.Serv. y Ases,SL_TIP LicenseCheck_1.0.0.3.app' -credential $credential

Publish-NewApplicationToBcContainer -containerName saas -appFile $PathAPPs'Técnicas Informática Pro.Serv. y Ases,SL_VinoTEC Core_1.0.0.0.app' -credential $credential

Publish-NewApplicationToBcContainer -containerName saas -appFile $PathAPPs'Técnicas Informática Pro.Serv. y Ases,SL_Bulk Items Management  Product Processing Orders_1.0.0.6.app' -credential $credential

Publish-NewApplicationToBcContainer -containerName saas -appFile $PathAPPs'Técnicas Informática Pro.Serv. y Ases,SL_Lab Test Management_1.0.0.2.app' -credential $credential

Publish-NewApplicationToBcContainer -containerName saas -appFile $PathAPPs'Técnicas Informática Pro.Serv. y Ases,SL_EMCS Spain_1.0.0.1.app' -credential $credential

Publish-NewApplicationToBcContainer -containerName saas -appFile $PathAPPs'Técnicas Informática Pro.Serv. y Ases,SL_INFOVI - Wine Reporting Management - Spain_1.0.0.0.app' -credential $credential

Publish-NewApplicationToBcContainer -containerName saas -appFile $PathAPPs'Técnicas Informática Pro.Serv. y Ases,SL_Excise Taxes Spain - IIEE alcohol y SILICIE_16.0.0.4.app' -credential $credential

Publish-NewApplicationToBcContainer -containerName saas -appFile $PathAPPs'Técnicas Informática Pro.Serv. y Ases,SL_Reporting Books - VinoTEC_1.0.0.6.app' -credential $credential

Publish-NewApplicationToBcContainer -containerName saas -appFile $PathAPPs'Técnicas Informática Pro.Serv. y Ases,SL_JCCM - Regional Reporting Books - VinoTEC_1.0.0.3.app' -credential $credential

Publish-NewApplicationToBcContainer -containerName saas -appFile $PathAPPs'Técnicas Informática Pro.Serv. y Ases,SL_Andalucía - Regional Reporting Books - VinoTEC_1.0.0.5.app' -credential $credential


# Otros comandos útiles
Import-BcContainerLicense $containerName $licenseFile
Get-BcContainerServerConfiguration $containerName