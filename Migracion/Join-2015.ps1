param(
[string]$SourceFiles,
[string]$DestinationFile
)

cls

Import-Module "C:\Program Files (x86)\Microsoft Dynamics NAV\80\RoleTailored Client CU53\Microsoft.Dynamics.Nav.Model.Tools.psd1"

Join-NAVApplicationObjectFile -source $SourceFiles  -Destination $DestinationFile

