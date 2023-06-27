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

$OriginalFolder = $PSScriptRoot + '\Original'
$ModifiedFolder = $PSScriptRoot + '\Modified'
$TargetFolder = $PSScriptRoot + '\Target'
$ResultFolder = $PSScriptRoot + '\Result'
$VersionListPrefixes = 'NAVW1', 'NAVES', 'IEP'

$OriginalFile = (Get-Item ($OriginalFolder + '\*.*'))
foreach ($OriginalFile in $OriginalFile)
    {
    $Object = Get-NAVApplicationObjectProperty -Source $OriginalFile 
    $OriginalVersionList = $Object.VersionList

    $ModifiedFile = (Get-Item ($ModifiedFolder + '\' + $OriginalFile.Name))
    $Object = Get-NAVApplicationObjectProperty -Source $ModifiedFile 
    $ModifiedVersionList = $Object.VersionList
    $ModifiedDate = $Object.Date
    $ModifiedTime = $Object.Time

    $TargetFile = (Get-Item ($TargetFolder + '\' + $OriginalFile.Name))
    $Object = Get-NAVApplicationObjectProperty -Source $TargetFile
    $TargetVersionList = $Object.VersionList

    $ResultFile = (Get-Item ($ResultFolder + '\' + $OriginalFile.Name))
    $Object = Get-NAVApplicationObjectProperty -Source $ResultFile

    $ResultVersionList = Merge-NAVVersionList $OriginalVersionList $ModifiedVersionList $TargetVersionList $VersionListPrefixes
    Set-NAVApplicationObjectProperty $ResultFile.FullName -VersionListProperty $ResultVersionList
    Set-NAVApplicationObjectProperty $ResultFile.FullName -DateTimeProperty ($ModifiedDate + ' ' + $ModifiedTime)
    }
