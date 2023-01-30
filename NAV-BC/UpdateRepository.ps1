Function ExportObjectsToLocalRepository{
    $FicheroObjetos =    'C:\Compartida\FOB\'+ $DBName + '-' +$VersionList + '.txt'
    $RepositoryFolder =  'C:\Users\am\Documents\Repositorios\Gitea\' + $RepositoryName
    $FiltroVersionList = 'Version List=@*' + $VersionList + '*' 

    Import-Module $RutaModulo -verbose
    Export-NAVApplicationObject -DatabaseName $DBName `
                                -DatabaseServer $DBServer `
                                -path $FicheroObjetos `
                                -Filter $FiltroVersionList `
                                -Force
    Split-NAVApplicationObjectFile -Source $FicheroObjetos -Destination $RepositoryFolder -Force

}

Function CommitRepository{
    $RamaLocal = 'master'
    $RamaRemota = 'origin'
    $MensajeCommit = Read-Host 'am-Prueba'

    git checkout ${RamaLocal}
    git add -A
    git commit -am "${MensajeCommit}"
    git push ${RamaRemota} ${RamaLocal}
}

cls

$VersionList    = 'PTV'
$RepositoryName = 'PTV2016CU28'
$DBName         = 'PTV2016CU28'
$DBServer       = 'HOTH\SQL2K14'
$RutaModulo     = 'C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client CU28\Microsoft.Dynamics.Nav.Model.Tools.psd1'

ExportObjectsToLocalRepository
# CommitRepository