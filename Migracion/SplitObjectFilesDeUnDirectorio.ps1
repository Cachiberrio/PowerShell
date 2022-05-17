# El presente script coge todos los ficheros de texto (*.txt) del directorio en el que se ubica el script y por cada uno de ellos
# - Genera un directorio con el nombre del fichero.
# - Explosiona el fichero de objetos en el directorio del mismo nombre.
#
# Esto lo hace con la totalidad de los ficheros de texto que se encuentre.

Function CrearDirectorio{
    Param([string]$RutaReferencia)
    echo ("Creando directorio " + $RutaReferencia)
    if (Test-Path $RutaReferencia) 
        {
        Remove-Item ($RutaReferencia) -Recurse | out-null
        }
    New-Item -Path $RutaReferencia -ItemType "directory" | out-null
}

$RutaModulo = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client CU15\NavModelTools.ps1'
Import-Module $RutaModulo

$Ficheros = (Get-Item ($PSScriptRoot + "\*.txt"))
foreach ($Ficheros in $Ficheros)
    {
    if (-not (Test-Path ($PSScriptRoot + "\" + $Ficheros.BaseName)))
        {
        CrearDirectorio $Ficheros.BaseName
        }
    Split-NAVApplicationObjectFile -Source $Ficheros `
                                    -Destination ($PSScriptRoot + "\" + $Ficheros.BaseName) `
                                    -Force
    }
