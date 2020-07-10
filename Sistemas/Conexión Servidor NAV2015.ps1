$sessionOptions = New-PSSessionOption -IncludePortInSPN  
Enter-PSSession -Computername nav2015 -SessionOption $sessionOptions -credential "tipsa\am"
cd\
cd '.\Program Files\Microsoft Dynamics NAV\110\Service'
.\NavAdminTool.ps1
