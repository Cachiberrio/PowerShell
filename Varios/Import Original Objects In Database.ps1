$DatabaseName   = 'NAV2015'
$ServerInstance = 'DynamicsNAV80'

cd $PSScriptRoot 

$null = Import-Module 'C:\Program Files (x86)\Microsoft Dynamics NAV\80\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1'
$null = import-module 'C:\Program Files\Microsoft Dynamics NAV\80\Service\NavAdminTool.ps1'
$null = import-module '.\..\MyPSFunctions\Start-NAVTableInWindowsClient.ps1'
$null = import-module '.\..\MyPSFunctions\Start-NAVIdeClient.ps1'

Import-NAVApplicationObject -Path .\Objects\*_Original.txt -DatabaseName $DatabaseName -LogPath .\Log -DatabaseServer ([net.dns]::GetHostName()) -ImportAction Overwrite -SynchronizeSchemaChanges Force -Confirm:$false
Import-NAVApplicationObject -Path .\Objects\FillTable.txt -DatabaseName $DatabaseName -LogPath .\Log -DatabaseServer ([net.dns]::GetHostName()) -ImportAction Overwrite -SynchronizeSchemaChanges Force -Confirm:$false
Compile-NAVApplicationObject -Filter "ID=56700..56701" -DatabaseName $Databasename -DatabaseServer ([net.dns]::GetHostName()) -LogPath .\Log

Get-NAVServerINstance -ServerInstance $ServerInstance | Get-NAVCompany | ForEach {
    Invoke-NAVCodeunit -ServerInstance $ServerInstance -CompanyName $_.CompanyName -CodeunitId 56700 
    Start-NAVTableInWindowsClient -ServerName ([net.dns]::GetHostName()) -ServerInstance $ServerInstance -Companyname $_.CompanyName -TableID 56700
    Start-NAVTableInWindowsClient -ServerName ([net.dns]::GetHostName()) -ServerInstance $ServerInstance -Companyname $_.CompanyName -TableID 56701
}

Delete-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer ([net.dns]::GetHostName()) -LogPath .\Log -Filter 'Type=Codeunit;Id=56700' -Confirm:$false

Start-NAVIdeClient -ServerName ([Net.dns]::GetHostName()) -Database $DatabaseName


