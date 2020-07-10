Function ActualizarVersion {
    Param([string]$VersionNAV,[string]$VersionNAVAbsoluta)

    # Búsqueda del último directorio de la CU ============================================================================
    foreach ($Directorio in (Get-ChildItem -Path ($DirectorioDVD + '\' + $VersionNAV) -Directory))
    {
        $IdCU = $Directorio
    }
    
    # Búsqueda del anterior directorio de la CU ==========================================================================
    foreach ($Directorio in Get-ChildItem -Path ($DirectorioVersiones + '\' + $VersionNAVAbsoluta) -Directory)
    {
        $IdCUAnterior = $Directorio
    }

    $IdCU                     = $IdCU.Name
    $IdCUAnterior             = $IdCUAnterior.Name.Substring(20,4)
    $FechaCU                  = $IdCU.CreationTime;
    $DirectorioCU             = $DirectorioDVD + '\' + $VersionNAV + '\' + $IdCU
    $NombreServidorNAV        = 'Microsoft Dynamics NAV Server ' + $VersionNAV
    $NombreBBDD               = 'CRONUS' + $VersionNAV
    $FicheroObjetos           = Get-ChildItem -Path ($DirectorioCU + '\APPLICATION') -recurse -Include *.fob
    $FicheroBackUpBBDDCU      = Get-ChildItem -Path ($DirectorioCU + '\DVD\SQLDemoDatabase') -Recurse -Include *.bak
    $IdCompilacion            = $FicheroObjetos.Name.Substring(8,5)
    $DirectorioRTCDVD         = $DirectorioCU + '\DVD\RoleTailoredClient\program files\Microsoft Dynamics NAV\' + $VersionNAVAbsoluta + '\RoleTailored Client'
    $DirectorioServiceDVD     = $DirectorioCU + '\DVD\ServiceTier\program files\Microsoft Dynamics NAV\' + $VersionNAVAbsoluta + '\Service'
    $DirectorioRTCDestino     = $DirectorioVersiones + '\' + $VersionNAVAbsoluta
    $DirectorioServiceDestino = 'C:\Program Files\Microsoft Dynamics NAV\' + $VersionNAVAbsoluta + '\Service'
    $DirectorioLinks          = $DirectorioVersiones + '\Links\Estándar\Cronus'
    
    if ($IdCU -eq $IdCUAnterior) {
        Write-Host -foregroundcolor Red 'La versión ' + $VersionNAV + ' está actualizada.'
        Return
    }
   
    # Actualizar fichero de versiones para incluir las nuevas versiones ==================================================
    add-Content $FicheroVersiones ($IdCompilacion+ ' ' + 'NAV ' + $VersionNav + ' ' + $IdCU +'	' + $FechaCU)
    
    # Actualización del directorio del RTC de la nueva version ===========================================================
    Copy-Item ($DirectorioRTCDestino + '\RoleTailored Client ' + $IdCUAnterior) ($DirectorioRTCDestino + '\RoleTailored Client ' + $IdCU) -Force -Recurse
    Copy-Item $DirectorioRTCDVD ($DirectorioRTCDestino + '\RoleTailored Client ' + $IdCU) -Force -Recurse

    # Actualizar el directorio del servidor NAV: A definir por Nacho =====================================================
    Copy-Item $DirectorioServiceDVD $DirectorioServiceDestino -Force -Recurse -Exclude CustomSettings.config
    
    # Detencion del servicio actual (Variable NombreServidorNAV) =========================================================
    Stop-Service $NombreServidorNAV

    # Actualización de la base de datos ==================================================================================
    $null = import-module SQLPS
    # Restore-SqlDatabase -BackupFile $FicheroBackUpBBDDCU -ServerInstance $NombreServidorSQL
    
    # Iniciar el NombreServidorNAV =======================================================================================
    Start-Service $NombreServidorNAV
    
    # Actualización del directorio de accesos directos:
    
    # Cambio de la propiedad Destino del icono de desarrollo
    # '"C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client ' + IdCUAnterior + '\finsql.exe" servername=Bbdd-desarrollo\SQL2k14,database=CRONUS2016,NTAUTHENTICATION=1'
    # a
    # '"C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client ' + IdCU + '\finsql.exe" servername=Bbdd-desarrollo\SQL2k14,database=CRONUS2016,NTAUTHENTICATION=1'
    
    # Cambio de la propiedad Destino del icono del cliente RTC
    # '"C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client ' + IdCUAnterior + '\Microsoft.Dynamics.Nav.Client.x86.exe" "DynamicsNAV://' + NombreServidorNAV + '//"'
    # a
    # '"C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client ' + IdCU + '\Microsoft.Dynamics.Nav.Client.x86.exe" "DynamicsNAV://' + NombreServidorNAV + '//"'
    }


$null = Import-Module 'C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1'
$null = Import-Module 'C:\Program Files\Microsoft Dynamics NAV\90\Service\NavAdminTool.ps1'

$DirectorioDVD       = '\\tipsa.local\tipsa\CD Producto NAV'
$NombreServidorSQL   = 'HOTH\SQL2K14'
$DirectorioVersiones = '\\tipsa.local\tipsa\Documentacion Clientes\Equipo01\NAV\RoleTailored Clients'
$FicheroVersiones    = '\\tipsa.local\tipsa\Documentacion Clientes\Equipo01\NAV\RoleTailored Clients\Links\Desarrollo\Versiones NAV.txt'

ActualizarVersion '2016' '90'

# ========================================================================================================================================
