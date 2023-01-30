﻿function Start-NAVWindowsClient
{
    [cmdletbinding()]
    param(
        [string]$ServerName, 
        [int]$Port, 
        [String]$ServerInstance, 
        [String]$Companyname, 
        [string]$tenant='default'
        )

    if ([string]::IsNullOrEmpty($Companyname)) {
    }

    $ConnectionString = "DynamicsNAV://$Servername" + ":$Port/$ServerInstance/$Companyname/?tenant=$tenant"
    Write-Verbose "Starting $ConnectionString ..."
    Start-Process $ConnectionString
}
