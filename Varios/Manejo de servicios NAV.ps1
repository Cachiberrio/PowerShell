Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
import-module "${env:ProgramFiles}\Microsoft Dynamics NAV\71\Service\NavAdminTool.ps1”
Import-Module "${env:ProgramFiles(x86)}\Microsoft Dynamics NAV\71 CU16\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1" -force
Get-NAVServerInstance
Get-NAVCompany -ServerInstance DES2013R2
New-NAVCompany -ServerInstance DES2013R2 -CompanyName "Madrid MVP"