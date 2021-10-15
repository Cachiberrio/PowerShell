param(
[string]$OriginalTxtFiles,
[string]$ModifiedTxtFiles,
[string]$DeltaPath,
[string]$Fileinfo
)

cls

Import-Module "C:\Program Files (x86)\Microsoft Dynamics NAV\80\RoleTailored Client CU53\Microsoft.Dynamics.Nav.Model.Tools.psd1"

Compare-NAVApplicationObject -OriginalPath $OriginalTxtFiles  -ModifiedPath $ModifiedTxtFiles  -DeltaPath $DeltaPath -Legacy -PassThru > $Fileinfo

