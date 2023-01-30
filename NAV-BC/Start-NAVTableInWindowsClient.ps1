﻿function Start-NAVTableInWindowsClient
{
    [cmdletbinding()]
    param(
        [string]$ServerName, 
        [int]$Port=7046, 
        [String]$ServerInstance, 
        [String]$Companyname, 
        [string]$tenant='default',
        [String]$TableID
        )

    if ([string]::IsNullOrEmpty($Companyname)) {
    }

    $ConnectionString = "DynamicsNAV://$Servername" + ":$Port/$ServerInstance/$Companyname/RunTable?Table=$TableID&tenant=$tenant"
    Write-Verbose "Starting $ConnectionString ..."
    Start-Process $ConnectionString
}
