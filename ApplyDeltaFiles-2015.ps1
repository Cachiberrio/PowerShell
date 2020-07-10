param(
[string]$DeltaTxtFiles,
[string]$TargetTxtFiles,
[string]$ResultFolder,
[string]$FileInfo
)

cls

Import-Module "C:\Program Files (x86)\Microsoft Dynamics NAV\80\RoleTailored Client CU53\Microsoft.Dynamics.Nav.Model.Tools.psd1"

Update-NAVApplicationObject -TargetPath $TargetTxtFiles –DeltaPath $DeltaTxtFiles -ResultPath $ResultFolder -ModifiedProperty Yes -VersionListProperty FromModified -DocumentationConflict ModifiedFirst -Legacy -PassThru > $Fileinfo
