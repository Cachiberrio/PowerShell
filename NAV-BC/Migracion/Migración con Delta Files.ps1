﻿Function CrearDirectorio{
    Param([string]$RutaReferencia)
    echo ("Creando directorio " + $RutaReferencia)
    if (Test-Path $RutaReferencia) 
        {
        Remove-Item ($RutaReferencia) -Recurse | out-null
        }
    New-Item -Path $RutaReferencia -ItemType "directory" | out-null
}
Function BorrarNoConflictivos{
    Param([string]$RutaReferencia,[string]$RutaMaestra)
    Echo ("Borrando objetos no conflictivos " + $RutaReferencia)
    $Ficheros = (Get-Item ($RutaReferencia + "\*.*"))
    foreach ($Ficheros in $Ficheros)
        {
        if (-not (Test-Path ($RutaMaestra + "\" + $Ficheros.Name)))
            {
            Remove-Item $Ficheros
            }
        }
}
function Merge-NAVVersionList
{
    param (
        [String]$OriginalVersionList,
        [String]$ModifiedVersionList,
        [String]$TargetVersionList, 
        [String[]]$Versionprefix
    )

    Write-Verbose "Merging $OriginalVersionList, $ModifiedVersionList, $TargetVersionList"
    $allVersions = @() + $OriginalVersionList.Split(',')
    $allversions += $ModifiedVersionList.Split(',')
    $allversions += $TargetVersionList.Split(',')

    $mergedversions = @()
    foreach ($prefix in $Versionprefix)
    {
        #add the "highest" version that starts with the prefix
        $PrefixVersionLists = $allVersions | where { $_.StartsWith($prefix) }
        $CurrentHighestPrefixVersionList = ''
        foreach ($PrefixVersionList in $PrefixVersionLists){
            $CurrentHighestPrefixVersionList = Get-NAVHighestVersionList -VersionList1 $CurrentHighestPrefixVersionList -VersionList2 $PrefixVersionList -Prefix $prefix
        }

        $mergedversions += $CurrentHighestPrefixVersionList

        # remove all prefixed versions
        $allversions = $allVersions.Where({ !$_.StartsWith($prefix) })
    }

    # return a ,-delimited string consiting of the "hightest" prefixed versions and any other non-prefixed versions
    $mergedversions += $allVersions
    $mergedversions = $mergedversions | ? {$_} #Remove empty
    $Result = $mergedVersions -join ','
    write-verbose "Result $Result"
    $Result
}
function Get-NAVHighestVersionList
{
    param (
        [String]$VersionList1,
        [String]$VersionList2,
        [String]$Prefix
    )
   
    if ([string]::IsNullOrEmpty($Versionlist1)){return $VersionList2}
    if ([string]::IsNullOrEmpty($Versionlist2)){return $VersionList1}
    if ($VersionList1 -eq $VersionList2) {
        return $VersionList1
    }
    try{        
        if ([String]::IsNullOrEmpty($Prefix)) {
            [int[]] $SplitVersionlist1 = $VersionList1.split('.')
            [int[]] $SplitVersionlist2 = $VersionList2.split('.')
        } else {
            [int[]] $SplitVersionlist1 = $VersionList1.Replace($Prefix,'').split('.')
            [int[]] $SplitVersionlist2 = $VersionList2.Replace($Prefix,'').split('.')
        }
    } catch {
        $ReturnVersionList = $VersionList2
        try{
            [int[]] $SplitVersionlist2 = $VersionList2.Replace($Prefix,'').split('.')    
        } Catch {
            $ReturnVersionList = $VersionList1
        }

        $WarningMessage = "`r`nVersionlists are probaly too unstructured to compare."
        $WarningMessage += "`r`n    VersionList1  : $VersionList1"
        $WarningMessage += "`r`n    VersionList2  : $VersionList2"
        $WarningMessage += "`r`n    Prefix        : $Prefix"        
        $WarningMessage += "`r`n    Returned value: $ReturnVersionList"
        $WarningMessage += "`r`nNo further action required is this is OK."

         
        Write-Warning -Message $WarningMessage
        return $ReturnVersionList
    }

    $Count = $SplitVersionlist1.Count
    if ($SplitVersionlist2.count -gt $count){
        $Count = $SplitVersionlist2.Count
    }

    $HighestVersionList = ''
    for ($i=0;$i -lt $Count;$i++){
        if ($SplitVersionlist1[$i] -gt $SplitVersionlist2[$i]){
            $HighestVersionList = $VersionList1
        }
        if ($SplitVersionlist2[$i] -gt $SplitVersionlist1[$i]){
            $HighestVersionList = $VersionList2
        }
        if ($HighestVersionList -ne ''){
            $i = $Count
        }
    }

    return $HighestVersionList

}

$RutaModuloOriginal  = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\130\RoleTailored Client CU18\NavModelTools.ps1'
$RutaModuloTarget    = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\130\RoleTailored Client CU18\NavModelTools.ps1'

$FicheroOriginalBase = 'C:\Tipsa\PowerShell\Migracion\Objetos\BC365 CU00.txt'
$FicheroOriginal     = 'C:\Tipsa\PowerShell\Migracion\Objetos\BC365 CU18.txt'
$FicheroTargetBase   = 'C:\Tipsa\PowerShell\Migracion\Objetos\BC140 CU00.txt'
$FicheroTarget       = 'C:\Tipsa\PowerShell\Migracion\Objetos\BC140 CU17.txt'

$RutaMigracion       = $PSScriptRoot
$FicheroModified     = $PSScriptRoot + '\Modified.txt'
$RutaOriginal        = $PSScriptRoot + '\Original'
$RutaTarget          = $PSScriptRoot + '\Target'
$RutaModified        = $PSScriptRoot + '\Modified'
$RutaDelta           = $PSScriptRoot + '\Delta'
$RutaResult          = $PSScriptRoot + '\Result'

$ErrorActionPreference = "Stop"
$HoraComienzo = Get-Date;

CrearDirectorio $RutaOriginal
CrearDirectorio $RutaTarget
CrearDirectorio $RutaModified
CrearDirectorio $RutaDelta
CrearDirectorio $RutaResult

Import-Module $RutaModuloOriginal
echo "1.- Creando objetos versión original"
Split-NAVApplicationObjectFile -Source $FicheroOriginalBase -Destination $RutaOriginal -Force
Split-NAVApplicationObjectFile -Source $FicheroOriginal -Destination $RutaOriginal -Force

echo "2.- Creando objetos modificados"
Split-NAVApplicationObjectFile -Source $FicheroModified -Destination $RutaModified -Force

echo "3.- Borrando Objetos no conflictivos Versión Original"
BorrarNoConflictivos $RutaOriginal $RutaModified

echo "4.- Obtención de los Delta Files"
Compare-NAVApplicationObject -OriginalPath ($RutaOriginal + "\*.TXT") -ModifiedPath ($RutaModified + "\*.TXT") -DeltaPath $RutaDelta -Force

Import-Module $RutaModuloTarget

echo "5.- Creando objetos versión Target"
Split-NAVApplicationObjectFile -Source $FicheroTargetBase -Destination $RutaTarget -Force
Split-NAVApplicationObjectFile -Source $FicheroTarget -Destination $RutaTarget -Force

echo "6.- Borrando Objetos no conflictivos Versión Target"
BorrarNoConflictivos $RutaTarget $RutaModified

echo "7.- Creando objetos modificados versión target"
Update-NAVApplicationObject -TargetPath $RutaTarget -DeltaPath $RutaDelta -ResultPath $RutaResult

Echo "8.- Merging Version List"

# $OriginalFolder = $PSScriptRoot + '\Original'
# $ModifiedFolder = $PSScriptRoot + '\Modified'
# $TargetFolder = $PSScriptRoot + '\Target'
# $ResultFolder = $PSScriptRoot + '\Result'

$VersionListPrefixes = 'NAVW1', 'NAVES', 'IEP'

$OriginalFile = (Get-Item ($RutaOriginal + '\*.*'))
foreach ($OriginalFile in $OriginalFile)
    {
    $Object = Get-NAVApplicationObjectProperty -Source $OriginalFile 
    $OriginalVersionList = $Object.VersionList

    $ModifiedFile = (Get-Item ($RutaModified + '\' + $OriginalFile.Name))
    $Object = Get-NAVApplicationObjectProperty -Source $ModifiedFile 
    $ModifiedVersionList = $Object.VersionList
    $ModifiedDate = $Object.Date
    $ModifiedTime = $Object.Time

    $TargetFile = (Get-Item ($RutaTarget + '\' + $OriginalFile.Name))
    $Object = Get-NAVApplicationObjectProperty -Source $TargetFile
    $TargetVersionList = $Object.VersionList

    $ResultFile = (Get-Item ($RutaResult + '\' + $OriginalFile.Name))
    $Object = Get-NAVApplicationObjectProperty -Source $ResultFile

    $ResultVersionList = Merge-NAVVersionList $OriginalVersionList $ModifiedVersionList $TargetVersionList $VersionListPrefixes
    Set-NAVApplicationObjectProperty $ResultFile.FullName -VersionListProperty $ResultVersionList
    Set-NAVApplicationObjectProperty $ResultFile.FullName -DateTimeProperty ($ModifiedDate + ' ' + $ModifiedTime)
    }

Echo "9.- Creación del fichero de resultados"
Join-NAVApplicationObjectFile -Source ($RutaResult + "\*.txt") -Destination ($RutaMigracion + "\Result.txt") -Force

$HoraFinal = Get-Date;
echo "La migración ha finalizado correctamente."
echo ("Comienzo: " + $HoraComienzo)
echo ("Final   : " + $HoraFinal)