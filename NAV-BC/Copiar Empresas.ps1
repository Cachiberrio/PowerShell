# Copia de empresas (muy util para el montaje de BBDD Demo)
Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\160\Service\NavAdminTool.ps1'
Remove-NAVCompany -ServerInstance BC -CompanyName 'CRONUS Bodegas S.L.'
Copy-NAVCompany -ServerInstance BC -DestinationCompanyName 'CRONUS Bodegas S.L.' -SourceCompanyName 'CRONUS España S.A.' 
