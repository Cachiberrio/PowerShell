Function CrearDirectorio{
    Param([string]$RutaReferencia)
    if (Test-Path $RutaReferencia) 
        {
        Remove-Item ($RutaReferencia) -Recurse | out-null
        }
    New-Item -Path $RutaReferencia -ItemType "directory" | out-null
}

Function SubirARepositorio{
    $RamaLocal = 'master'
    $RamaRemota = 'origin'
    $MensajeCommit = Read-Host "Introduce un mensaje para el commit"

    git checkout ${RamaLocal}
    git add -A
    git commit -am "${MensajeCommit}"
    git push ${RamaRemota} ${RamaLocal}
}

Function SubirARepositorioDesarrollo{
    Param([string]$RutaRepositorio,[string]$Desarrollo)
    $Filtro = 'Version List=*' + $Desarrollo + '*'
    $FicheroExportacion = 'C:\Compartida\FOB\Repositorios\' + $Desarrollo + '.txt'
    $RutaRepositorio = $RutaRepositorio + '\' + $Desarrollo
    CrearDirectorio $RutaRepositorio
    Export-NAVApplicationObject $FicheroExportacion -DatabaseServer 'BC14CU15\SQLEXPRESS' -DatabaseName 'CRONUS' -Filter $Filtro -Username 'admin' -Password 'P@ssw0rd' -Force
    Split-NAVApplicationObjectFile -Source $FicheroExportacion -Destination $RutaRepositorio -Force
}

cls
$NavIde = "C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client CU07\finsql.exe"
$RutaModuloTarget = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client CU07\NavModelTools.ps1'
Import-Module $RutaModuloTarget

$RutaRepositorios = 'C:\Users\am\Documents\Repositorios\VNT140'
# CrearDirectorio $RutaRepositorios

# SubirARepositorioDesarrollo $RutaRepositorios 'REC'
SubirARepositorioDesarrollo $RutaRepositorios 'IIEE'
SubirARepositorioDesarrollo $RutaRepositorios 'BAS'
SubirARepositorioDesarrollo $RutaRepositorios 'DEC'
SubirARepositorioDesarrollo $RutaRepositorios 'CEX'
SubirARepositorioDesarrollo $RutaRepositorios 'EMC'

SubirARepositorio