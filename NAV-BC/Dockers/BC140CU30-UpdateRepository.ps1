Function UpdateRepository {
    $FicheroObjetos =    'C:\Compartida\FOB\'+ $DBName + '-' +$VersionList + '.txt'
    $RepositoryFolder =  'C:\Users\am\Documents\Repositorios\Gitea\' + $VersionList
    $FiltroVersionList = 'Version List=@*' + $VersionList + '*' 

    Import-Module $RutaModulo -verbose
    Export-NAVApplicationObject -DatabaseName $DBName `
                                -DatabaseServer $DBServer `
                                -path $FicheroObjetos `
                                -Filter $FiltroVersionList `
                                -username 'admin' `
                                -password 'P@ssw0rd' `
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

$VersionList = 'PTV'
$DBName =      'CRONUS'
$DBServer =    'BC140CU30\SQLEXPRESS'
$RutaModulo =  'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client CU30\Microsoft.Dynamics.Nav.Model.Tools.psd1'

UpdateRepository
# CommitRepository