$sessionOptions = New-PSSessionOption -IncludePortInSPN  
Enter-PSSession -Computername tipsanav-2017 -SessionOption $sessionOptions -credential "tipsa\am"
cd\
cd '.\Program Files\Microsoft Dynamics NAV\110\Service'
.\NavAdminTool.ps1