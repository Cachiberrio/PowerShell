function Merge-NAVDateTime
{
    param (
        [String]$OriginalDate,
        [String]$OriginalTime,
        [String]$ModifiedDate,
        [String]$ModifiedTime,
        [String]$TargetDate,
        [String]$TargetTime
    )

    $_Date = Get-Date ($OriginalDate)
    $OriginalDateTime = $_Date + $OriginalTime
    $_Date = Get-Date ($ModifiedDate)
    $ModifiedDateTime = $_Date + $ModifiedTime
    $_Date = Get-Date ($TargetDate)
    $TargetDateTime = $_Date + $TargetTime

    $FinalDateTime =  Get-Date ($TargetDateTime)
    if ($FinalDateTime -lt $ModifiedDateTime)
    {
        $FinalDateTime = $ModifiedDateTime
    }
    Get-Date $FinalDateTime -Format g
}