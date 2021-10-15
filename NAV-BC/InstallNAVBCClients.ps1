function Install-NAV
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [String] $DVDFolder,
        [Parameter(Mandatory=$true)]
        $Configfile,
        [Parameter(Mandatory=$false)]
        $LicenseFile,
        [Parameter(Mandatory=$true)]
        $Log,
        [Parameter(Mandatory=$false)]
        [Switch] $DisableCompileBusinessLogic
    )
    process
    {
        $Logdir = [io.path]::GetDirectoryName($Log)
        if (!(Test-Path $Logdir)) {New-Item -Path $Logdir -ItemType directory}

        $ConfigFile = Get-Item $Configfile

        Write-Host "Starting install from $($DVDFolder) with Configfile $($ConfigFile.Fullname)" -ForegroundColor Green
        [xml]$InstallConfig = Get-Content $Configfile

        $InstallationResult = New-Object System.Object
        $InstallationResult | Add-Member -MemberType NoteProperty -Name Databasename -Value ($InstallConfig.Configuration.Parameter | Where-Object Id -eq SQLDatabaseName).Value
        $InstallationResult | Add-Member -MemberType NoteProperty -Name TargetPath -Value  ($InstallConfig.Configuration.Parameter | Where-Object Id -eq TargetPath).Value
        $InstallationResult | Add-Member -MemberType NoteProperty -Name TargetPathX64 -Value ($InstallConfig.Configuration.Parameter | Where-Object Id -eq TargetPathX64).Value
        $InstallationResult | Add-Member -MemberType NoteProperty -Name ServerInstance -Value ($InstallConfig.Configuration.Parameter | Where-Object Id -eq NavServiceInstanceName).Value

        #Install

        write-host -foregroundcolor green -object 'Installing ...'
        write-host -foregroundcolor green -object "   Database: $($InstallationResult.Databasename)"
        write-host -foregroundcolor green -object "   ServerInstance: $($InstallationResult.ServerInstance)"
        write-host -foregroundcolor green -object ''
        write-host -foregroundcolor green -object 'please be patient ...'

        if ($DVDFolder.Length -eq 3){
            $SetupPath = "$($DVDFolder)setup.exe"
        } else {
            $SetupPath = Join-Path $DVDFolder 'setup.exe'
        }
        Start-Process $SetupPath -ArgumentList "/config ""$($Configfile.Fullname)""",'/quiet',"/Log ""$($Log)""" -PassThru | Wait-Process

        if ($LicenseFile){
            $null = Import-Module (join-path $InstallationResult.TargetPathX64 'service\navadmintool.ps1' )
            $null = Get-NAVServerInstance -ServerInstance $installationresult.ServerInstance | Set-NAVServerInstance -Start -ErrorAction SilentlyContinue

            write-host -ForegroundColor Green -Object "Installing licensefile '$Licensefile'"
            $null = Get-NAVServerInstance -ServerInstance $installationresult.ServerInstance | Import-NAVServerLicense -LicenseFile $LicenseFile -Database NavDatabase
            write-host -ForegroundColor Green -Object "Restarting $($installationresult.ServerInstance)"
            $null = Get-NAVServerInstance -ServerInstance $installationresult.ServerInstance | Set-NAVServerInstance -Restart
        }

        if ($DisableCompileBusinessLogic){
            write-host -ForegroundColor Green -Object 'Disabling CompileBusinessApplicationAtStartup'
            $null = Import-Module (join-path $InstallationResult.TargetPathX64 'service\navadmintool.ps1' )
            $null = Get-NAVServerInstance -ServerInstance $installationresult.ServerInstance | Set-NAVServerConfiguration -KeyName 'CompileBusinessApplicationAtStartup' -KeyValue 'False'

            write-host -ForegroundColor Green -Object "Restarting $($installationresult.ServerInstance)"
            $null = Get-NAVServerInstance -ServerInstance $installationresult.ServerInstance | Set-NAVServerInstance -Restart
        }

        Write-Host 'Log output:' -ForegroundColor Green
        Get-Content $Log | ForEach-Object {
            Write-Host "  $_" -ForegroundColor Gray
        }

    }
    end
    {
        $InstallationResult
    }
}

Dism /online /Enable-Feature /FeatureName:"NetFx3"


$Licensefile    = '\\hoth\Compartida\Tipsa_Microsoft Dynamics 365 Business Central on premises_20191219.flf'
$NAVDVD2013R2         = 'Z:\CD Producto NAV\2013R2\RU\CU51\DVD'
$NAVDVD2015         = 'Z:\CD Producto NAV\2015\CU\CU63\DVD'
$NAVDVD2016         = 'Z:\CD Producto NAV\2016\CU51\DVD'
$NAVDVD2017         = 'Z:\CD Producto NAV\2017\CU\CU39\DVD'
$NAVDVD2018         = 'Z:\CD Producto NAV\2018\CU\CU26\DVD'
$NAVDVD130         = 'Z:\CD Producto NAV\BC365\CU\CU02\DVD'
$NAVDVD140         = 'Z:\CD Producto NAV\BC140\CU\CU02\DVD'
$ConfigFileNAV2013R2     = "Z:\CD Producto NAV\Utilidades\RoleTailored Clients\Ficheros configuración\NAV2013R2.xml"
$ConfigFileNAV2015     = "Z:\CD Producto NAV\Utilidades\RoleTailored Clients\Ficheros configuración\NAV2015.xml"
$ConfigFileNAV2016     = "Z:\CD Producto NAV\Utilidades\RoleTailored Clients\Ficheros configuración\NAV2016.xml"
$ConfigFileNAV2017     = "Z:\CD Producto NAV\Utilidades\RoleTailored Clients\Ficheros configuración\NAV2017.xml"
$ConfigFileNAV2018     = "Z:\CD Producto NAV\Utilidades\RoleTailored Clients\Ficheros configuración\NAV2018.xml"
$ConfigFileBC365     = "Z:\CD Producto NAV\Utilidades\RoleTailored Clients\Ficheros configuración\BC365.xml"
$ConfigFileBC140     = "Z:\CD Producto NAV\Utilidades\RoleTailored Clients\Ficheros configuración\BC140.xml"
$Log            = 'c:\NavInstall.txt'

$InstallationResult = Install-NAV -DVDFolder $NAVDVD2013R2 -Configfile $ConfigFileNAV2013R2 -Log $Log
$InstallationResult = Install-NAV -DVDFolder $NAVDVD2015 -Configfile $ConfigFileNAV2015 -Log $Log
$InstallationResult = Install-NAV -DVDFolder $NAVDVD2016 -Configfile $ConfigFileNAV2016 -Log $Log
$InstallationResult = Install-NAV -DVDFolder $NAVDVD2017 -Configfile $ConfigFileNAV2017 -Log $Log
$InstallationResult = Install-NAV -DVDFolder $NAVDVD2018 -Configfile $ConfigFileNAV2018 -Log $Log
$InstallationResult = Install-NAV -DVDFolder $NAVDVD130 -Configfile $ConfigFileBC365 -Log $Log
$InstallationResult = Install-NAV -DVDFolder $NAVDVD140 -Configfile $ConfigFileBC140 -Log $Log

