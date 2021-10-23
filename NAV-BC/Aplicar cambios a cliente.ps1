# Véase la sección "Instalación de objetos a clientes" el Manual de usuario antes de utilizar el Script: 
# \\tipsa.local\tipsa\Documentos\Desarrollo NAV\RET Integración Sistema RETO\Versiones\Desarrollo\0900 - 2016\Documentación\Formación\MAN Integración Sistem RETO - Manual de usuario.docx

# Rangos de objetos que entran en la instalación:
#     - Tablas: 18|23|27|36|38|110|112|114|120|122|124|225|6650|6660
#     - Pages : 21|26|30|42|50|51|52|132|134|138|140|367

Function CrearDirectorio{
    Param([string]$RutaReferencia)
    echo ("Creando directorio " + $RutaReferencia)
    if (Test-Path $RutaReferencia) 
        {
        Remove-Item ($RutaReferencia) -Recurse | out-null
        }
    New-Item -Path $RutaReferencia -ItemType "directory" | out-null
}

Function CreateDeltaFiles {
    Param([string]$FicheroOriginal,
          [string]$FicheroModified)
    echo "Creando DELTA Files"
    $RutaModified    = $PSScriptRoot + '\Modified'
    $RutaOriginal    = $PSScriptRoot + '\Original'
    CrearDirectorio $RutaModified
    CrearDirectorio $RutaOriginal
    Split-NAVApplicationObjectFile -Source $FicheroOriginal -Destination $RutaOriginal -Force
    Split-NAVApplicationObjectFile -Source $FicheroModified -Destination $RutaModified -Force
    Compare-NAVApplicationObject -OriginalPath ($RutaOriginal + "\*.txt") -ModifiedPath ($RutaModified + "\*.txt") -DeltaPath $RutaDelta
}
Function AplicarDeltaFiles{
    Param([string]$FicheroTarget,
          [string]$FicheroResult,
          [string]$RutaTarget,
          [string]$RutaResult)
    echo ("Aplicando DELTA Files: " + $FicheroTarget)
    Split-NAVApplicationObjectFile -Source $FicheroTarget -Destination $RutaTarget -Force
    Update-NAVApplicationObject -TargetPath $RutaTarget -DeltaPath $RutaDelta -ResultPath $RutaResult
    Join-NAVApplicationObjectFile -Source ($RutaResult + '\*.txt') -Destination $FicheroResult -Force
}

Function ActualizarCliente{
    Param([string]$IdCliente)
    echo '**********************************************************'
    echo 'Actualizando cliente ' $IdCliente
    echo '**********************************************************'
    $RutaResult    = $PSScriptRoot + '\Clientes\' + $IdCliente + '\Result'
    $RutaTarget    = $PSScriptRoot + '\Clientes\' + $IdCliente + '\Target'
    CrearDirectorio $RutaResult
    CrearDirectorio $RutaTarget

    $FicheroResult = $PSScriptRoot + '\Cliente-' + $IdCliente + '-Resultado.txt'
    $FicheroTarget = $PSScriptRoot + '\Cliente-' + $IdCliente + '.txt'

    AplicarDeltaFiles -FicheroTarget $FicheroTarget `
                      -FicheroResult $FicheroResult `
                      -RutaTarget $RutaTarget `
                      -RutaResult $RutaResult 
    Split-NAVApplicationObjectFile -Source ($PSScriptRoot + '\NAV2016-Nuevos.txt') `
                                   -Destination $RutaResult `
                                   -Force
    Join-NAVApplicationObjectFile -Source ($RutaResult + '\*.txt') `
                                  -Destination $FicheroResult `
                                  -Force
}
Clear

$HoraComienzo = Get-Date;
# $ErrorActionPreference = "Stop"

$RutaLog = $PSScriptRoot + '\Log.txt'
new-item $RutaLog -Force

$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
# $ErrorActionPreference = "Continue"
$ErrorActionPreference = "Stop"
Start-Transcript -path '\\tipsa.local\tipsa\Documentos\Desarrollo NAV\RET Integración Sistema RETO\Desarrollo\Instalación\Log.txt' -append

$RutaDelta = $PSScriptRoot + '\Delta'
CrearDirectorio $RutaDelta

$RutaModulo = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client CU15\NavModelTools.ps1'
Import-Module $RutaModulo

CreateDeltaFiles -FicheroOriginal ($PSScriptRoot + '\NAV2016-Originales.txt') `
                 -FicheroModified ($PSScriptRoot + '\NAV2016-Modificados.txt')

ActualizarCliente -IdCliente 'REI'
ActualizarCliente -IdCliente 'CCI'
ActualizarCliente -IdCliente 'CVP'
ActualizarCliente -IdCliente 'SSB'

$HoraFinal = Get-Date;
echo "La migración ha finalizado correctamente."
echo ("Comienzo: " + $HoraComienzo)
echo ("Final   : " + $HoraFinal)

Stop-Transcript
