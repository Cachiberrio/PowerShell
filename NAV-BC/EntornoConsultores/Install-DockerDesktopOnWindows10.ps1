### Pendiente instalación dockers

#Requires -RunAsAdministrator
#Run all the below line-by-line in administrator mode!
set-executionpolicy unrestricted

#Download latest nightly build (Docker Desktop - Windows (Edge))
#$DockerInstallFile = "$env:USERPROFILE\Downloads\DockerInstall.exe"
#Invoke-WebRequest -UseBasicparsing -Outfile $DockerInstallFile "https://download.docker.com/win/edge/Docker%20for%20Windows%20Installer.exe"

#Run Install
#start $DockerInstallFile

#pause;
#break

# Allow access to Docker Engine without admin rights
# https://www.axians-infoma.com/techblog/allow-access-to-the-docker-engine-without-admin-rights-on-windows/
[System.IO.Directory]::GetAccessControl("\\.\pipe\docker_engine") | Format-Table -Wrap
Install-Module -Name dockeraccesshelper -Force
Add-AccountToDockerAccess "$env:UserDomain\$env:UserName"

# Test docker
#docker run hello-world:nanoserver #you don't need to do this - you can also just trust me :-).

# Install NAVContainerHelper
install-module -Name navcontainerhelper -Force

# Set a hashtable for ease:
$dw = @{ HostAddress = 'npipe://./pipe/win_engine' }

# Temporary Fix for Containers Bug
Set-ItemProperty -Path 'HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization\Containers' -Name VSmbDisableOplocks -Type DWord -Value 0 -Force