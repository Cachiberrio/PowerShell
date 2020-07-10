$sessionOptions = New-PSSessionOption -IncludePortInSPN  
Enter-PSSession -Computername nav2015 -SessionOption $sessionOptions -credential "tipsa\am"
Import-Module "C:\Program Files\Microsoft Dynamics NAV\90\CRONUS2016\NavAdminTool.ps1"